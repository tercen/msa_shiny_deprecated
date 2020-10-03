library(shiny)
library(tercen)
library(dplyr)
library(tidyr)
library(msaR)
library(Biostrings)

############################################
#### This part should not be included in ui.R and server.R scripts
getCtx <- function(session) {
  ctx <- tercenCtx(stepId = "7f89df50-e79a-437b-b6f8-96da4eea6afb",
                   workflowId = "a77770c3923fad0ca99b77fa8905471d")
  return(ctx)
}
####
############################################

ui <- shinyUI(fluidPage(
  
  titlePanel("Multiple Sequence Alignment"),
  
  mainPanel(
    uiOutput("reacOut")
  )
  
))

server <- shinyServer(function(input, output, session) {
  
  dataInput <- reactive({
    getValues(session)
  })
  
  output$reacOut <- renderUI({
    plotOutput(
      "main.plot"
    )
  }) 
  
  output$main.plot <- renderPlot({
    values <- dataInput()
    tst <- values$data$set[[1]]
    # names(tst) <- aln$nam
    print(tst)
    SEQ <- Biostrings::AAStringSet(tst)
    msaR::msaR(SEQ)
  })
  
})

getValues <- function(session){
  ctx <- getCtx(session)
  values <- list()
  values$data$set <- ctx$rselect(ctx$rnames[[1]])
  return(values)
}

runApp(shinyApp(ui, server))  
