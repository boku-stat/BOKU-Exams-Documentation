# shiny ui
library(shiny)

source("test template.R", local = TRUE)


type_tabs <- tabsetPanel( 
  id = "types", 
  type= "hidden", 
  tabPanel(""),
  tabPanel("yes", 
           radioButtons("type_for_all_questions", "Please select the type of question.", choices = c("numeric", "text", "single choice", "multiple choice"))
  ), 
  tabPanel("no", uiOutput("input_ui")
           )
)

question_tabs <- tabsetPanel(
  id = "questions", 
  type = "hidden", 
  tabPanel("no"), 
  tabPanel("yes", 
           numericInput("n", "Number of Questions", value = 1, min = 1),
           selectInput("same_type", "Should all questions have the same type?", choices = c("", "yes", "no"), selected = ""),
           type_tabs
           
           
           )
)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("filename", "Please provide a filename.", value = Sys.time()),
      textInput("meta_name", "Name of the exercise:", value = "*write a name here*"),
      textInput("meta_title", "Title of the exercise:", value = "*write a title here*"),
      textInput("meta_version", "Version of the exercise:", value = "v1"),
      selectInput("question_choice", "Should the template include the structure for questions?", choices = c("", "no", "yes")),
      question_tabs,
      downloadButton("download", "Download Template"),
      ), 
    mainPanel("This will show a summary of the choices made.")
    )
)

server <- function(input, output, session) {
  #create dynamic ui elements 
  output$input_ui <- renderUI({ #https://gist.github.com/christopherlovell/b7ecdf8b0aa82c20fa46 
    n <- input$n 
    lapply(1:n, function(i){
      radioButtons(inputId = paste0("type_question", i), label = paste("Question", i), choices = c("numeric", "text", "single choice", "multiple choice"))
      #https://stackoverflow.com/questions/19130455/create-dynamic-number-of-input-elements-with-r-shiny
    }) 
  })
  
  #dynmaic inputs 
  observeEvent(input$question_choice, {
    updateTabsetPanel(inputId = "questions", selected = input$question_choice)
  })
  observeEvent(input$same_type, {
    updateTabsetPanel(inputId = "types", selected = input$same_type)
  })
 
  
  #create template for download
  output$download <- downloadHandler(
    filename = function() {
      paste0(input$filename, ".Rmd")
    },
    content = function(file) {
      if(input$same_type == "yes"){
        type <- switch(input$type_for_all_questions, 
                       "numeric" = "num", 
                       "text" = "string", 
                       "single choice" = "schoice", 
                       "multiple choice" = "mchoice"
        )
        types <- rep(type, input$n)
        ex_type <- type
      }else{
        types <- NULL
        for(i in 1:input$n){
          types[i] <- switch(input[[paste0("type_question", i)]], 
                             "numeric" = "num", 
                             "text" = "string", 
                             "single choice" = "schoice", 
                             "multiple choice" = "mchoice")
        }
        ex_type <- "cloze"
      }
      
      template <- basic_template(n = input$n, meta_name = input$meta_name, meta_title = input$meta_title, meta_version = input$meta_version, types = types, ex_type = ex_type)
      write(template, file = file)
    }
  )
  

  session$onSessionEnded(function() {
    stopApp()
  })
}

shinyApp(ui, server)
