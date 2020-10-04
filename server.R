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
      "main.plot",
      height = input$plotHeight,
      width = input$plotWidth
    )
  }) 
  
  output$main.plot <- renderPlot({
    values <- dataInput()
    tst <- values$data$sequence[[1]]
    names(tst) <- 1:length(tst)
    names(tst) <- values$data$names[[1]]
    SEQ <- Biostrings::AAStringSet(tst)
    x <- Biostrings::AAStringSet(tst)
    d <- as.dist(stringDist(x, method = "hamming")/width(x)[1])
    tree <- bionj(d)
    p <- ggtree(tree)
    if(input$tiplabels) p <- p + geom_tiplab()
    x <- ape::as.AAbin(x)
    msaplot(p, fasta = x, window = input$position, offset = input$msaoffset, width = input$msawidth)    
  })
  
})

getValues <- function(session){
  ctx <- getCtx(session)
  values <- list()
  values$data$names <- ctx$rselect(ctx$rnames[[grep(pattern = "name", ctx$rnames)]])
  values$data$sequence <- ctx$rselect(ctx$rnames[[grep(pattern = "sequence", ctx$rnames)]])
  
  return(values)
}
