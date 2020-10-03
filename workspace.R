library(shiny)
library(tercen)
library(dplyr)
library(tidyr)
# library(msaR)
library(ggmsa)
library(Biostrings)
library(ape)
library(ggtree)

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
    names(tst) <- 1:length(tst)
    # names(tst) <- aln$nam
    SEQ <- Biostrings::AAStringSet(tst)
    x <- Biostrings::AAStringSet(tst)
    d <- as.dist(stringDist(x, method = "hamming")/width(x)[1])
    tree <- bionj(d)
    p <- ggtree(tree) + geom_tiplab()
    x <- ape::as.AAbin(x)
    msaplot(p, fasta = x, window = c(10,20))    
    # msaR::msaR(SEQ)
  })
  
})

getValues <- function(session){
  ctx <- getCtx(session)
  values <- list()
  values$data$set <- ctx$rselect(ctx$rnames[[1]])

  return(values)
}

runApp(shinyApp(ui, server))  
