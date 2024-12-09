#shiny ui 
library(shiny)

source("test template.R", local = TRUE)

ui <- fluidPage(
  textInput("filename", "Please provide a filename"),
  numericInput("n", "Number of Questions", value = NULL, min = 0), 
  downloadButton("download", "Download Template")
)

server <- function(input, output, session){
  
    output$download <- downloadHandler(
      filename = function(){
        paste0(input$filename, ".Rmd")
      },
      content = function(file){
        write(basic_template(n = input$n), file = file)
      }
    )
    
    session$onSessionEnded(function() {
      stopApp()
    })
  
}

shinyApp(ui, server)
