#shiny ui 
library(shiny)

source("test template.R", local = TRUE)

ui <- fluidPage(
  textInput("filename", "Provide Filename"), 
  downloadButton("downloadTemp", "Download Template")
)

server <- function(input, output, session){
  
    output$downloadTemp <- downloadHandler(
      filename = function(){
        paste0(input$filename, ".Rmd")
      },
      content = function(file){
        basic_template(filepath = file)
      }
    )
    
    session$onSessionEnded(function() {
      stopApp()
    })
  
}

shinyApp(ui, server)
