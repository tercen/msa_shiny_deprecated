library(shiny)
library(tercen)
library(dplyr)
library(tidyr)
library(msaR)
library(Biostrings)

############################################
#### This part should not be modified
getCtx <- function(session) {
  # retreive url query parameters provided by tercen
  query <- parseQueryString(session$clientData$url_search)
  token <- query[["token"]]
  taskId <- query[["taskId"]]
  
  # create a Tercen context object using the token
  ctx <- tercenCtx(taskId = taskId, authToken = token)
  return(ctx)
}
####
############################################

shinyServer(function(input, output, session) {
  
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