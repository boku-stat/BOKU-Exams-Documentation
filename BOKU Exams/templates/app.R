# shiny ui
library(shiny)
library(bslib)


####### define function  ###### 
# basic template  generation
basic_template <- function(n, meta_name, meta_title, meta_version, types = NULL, ex_type, image){
  header <- "\`\`\`{r data generation, echo = FALSE, results = \"hide\"}\n"
  lists <- "answers <- list()\nsolutions <- list()\ntypes <- list()\nexplanations <- list() \ntolerances <- list()\n\n"
  lists_assignment <- NULL
  if(!is.null(n)){ 
    for(i in 1:n){
      lists_assignment <- paste0(lists_assignment, "answers[[", i, "]] <- \nsolutions[[", i, "]] <- \ntypes[[", i,"]] <- \"", types[i], "\"", "\nexplanations[[", i, "]] <- \ntolerances[[", i, "]] <- \n\n")
      end <- "\n\n\`\`\`\n\n"
    }
  }else{
    end <- "\n### fill in lists here\n\n\`\`\`\n\n"
  }
  
  content <- paste0(header, lists, lists_assignment, end)
  
  question <- "Question\n========\n\n*Write the question text here*\n\n"
  picture <- paste0("![](", image, ")\n\n")
  questionlist_code_1 <- "`\`\`{r questionlist, echo = FALSE, results = \"asis\"}\nfor (x in 1:length(types)) {\n\tif (types[x] %in% c(\"num\", \"string\")) {\n"
  questionlist_code_2 <- "\t\tanswers[x] <- \"\"\n\t}\n}\nanswerlist(unlist(answers), markup = \"markdown\")\n\`\`\`\n\n"
  
  content <- paste0(content, question, picture, questionlist_code_1, questionlist_code_2)
  
  solution <- "Solution\n========\n\n*Write the feedback here*\n\n"
  solution_list <- "\`\`\`{r solutionlist, echo = FALSE, results = \"asis\"}  \nfor (x in 1:length(solutions)) {  \n  if (types[x] == \"schoice\") {\n    explanations[x] <- solutions[x] |> lapply(function(x) ifelse(x, \"True\", \"False\"))  \n  } else {  \n    explanations[x] <- solutions[x]  \n  }  \n}  \nanswerlist(unlist(explanations), markup = \"markdown\")  \n\`\`\`\n\n"
  meta_list <- "\`\`\`{r meta, echo = FALSE, results = 'hide'}\nfor (x in 1:length(solutions)) {\n  if (types[x] == \"schoice\") {\n    solutions[x] <- solutions[x] |>\n      unlist() |>\n      mchoice2string()\n  }\n}\n\`\`\`\n\n"
  
  content <- paste0(content, solution, solution_list, meta_list)
  
  metainfo <- paste0("Meta-information\n========\n\nexname: ", meta_name, " \nextitle: ", meta_title, " \nextype: ", ex_type, "\nexsolution: \`r paste(solutions, collapse = \"|\")\` \nexclozetype: \`r paste(types, collapse = \"|\")\` \nextol: \`r paste(tolerances, collapse = \"|\")\` \nexshuffle: TRUE \nexversion: ", meta_version) 
  
  content <- paste0(content, metainfo) 
  return(content)
}

###### define panel tabs ###### 

type_tabs <- tabsetPanel(
  id = "types",
  type = "hidden",
  tabPanel(""),
  tabPanel("yes", radioButtons("type_for_all_questions", "Please select the type of question.", choices = c("numeric", "text", "single choice", "multiple choice"))),
  tabPanel("no", uiOutput("input_ui"))
)

question_tabs <- tabsetPanel(
  id = "questions",
  type = "hidden",
  tabPanel("no"),
  tabPanel(
    "yes",
    numericInput("n", "Number of Questions", value = 1, min = 1),
    selectInput("same_type", "Should all questions have the same type?", choices = c("", "yes", "no"), selected = ""),
    type_tabs
  )
)

##### define ui and server ###### 

ui <- fluidPage(
  theme = bs_theme(primary = "#007BFF", secondary = "#6C757D", font_scale = 1.1),
  textOutput("preview"),
  sidebarLayout(
    sidebarPanel(
      textInput("filename", "Please provide a filename.", value = Sys.Date()),
      textInput("meta_name", "Name of the exercise:", value = "*write a name here*"),
      textInput("meta_title", "Title of the exercise:", value = "*write a title here*"),
      textInput("meta_version", "Version of the exercise:", value = "v1"),
      selectInput("question_choice", "Should the template include the structure for questions?", choices = c("", "no", "yes")),
      question_tabs,
      fileInput("file1", "Choose an Image to include, when opening the downloaded template, it must be stored in the same folder! (in progress)"),
      downloadButton("download", "Download Template"),
    ),
    mainPanel("Download a customizable template. Disclaimer: app is still in progress.")
  )
)

server <- function(input, output, session) {
  # create dynamic ui elements
  output$input_ui <- renderUI({ # https://gist.github.com/christopherlovell/b7ecdf8b0aa82c20fa46
    if (!is.na(input$n)) {
      n <- input$n
      lapply(1:n, function(i) {
        radioButtons(inputId = paste0("type_question", i), label = paste("Question", i), choices = c("numeric", "text", "single choice", "multiple choice"))
        # https://stackoverflow.com/questions/19130455/create-dynamic-number-of-input-elements-with-r-shiny
      })
    }
  })


  # dynmaic inputs
  observeEvent(input$question_choice, {
    updateTabsetPanel(inputId = "questions", selected = input$question_choice)
  })
  observeEvent(input$same_type, {
    updateTabsetPanel(inputId = "types", selected = input$same_type)
  })


  # create template for download
  output$download <- downloadHandler(
    filename = function() {
      paste0(input$filename, ".Rmd")
    },
    content = function(file) {
      if (input$same_type == "yes") {
        type <- switch(input$type_for_all_questions,
          "numeric" = "num",
          "text" = "string",
          "single choice" = "schoice",
          "multiple choice" = "mchoice"
        )
        types <- rep(type, input$n)
        ex_type <- type
      } else {
        types <- NULL
        for (i in 1:input$n) {
          types[i] <- switch(input[[paste0("type_question", i)]],
            "numeric" = "num",
            "text" = "string",
            "single choice" = "schoice",
            "multiple choice" = "mchoice"
          )
        }
        ex_type <- "cloze"
      }
      image <- input$file1 
      image_path <- image$name
      
      template <- basic_template(n = input$n, meta_name = input$meta_name, 
                                 meta_title = input$meta_title, meta_version = input$meta_version, 
                                 types = types, ex_type = ex_type, image = image_path)
      write(template, file = file)
    }
  )

  

  session$onSessionEnded(function() {
    stopApp()
  })
}


###### run app ###### 
shinyApp(ui, server)
