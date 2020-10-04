library(shiny)
library(tercen)
library(dplyr)
library(tidyr)
library(ggmsa)
library(Biostrings)
library(ape)
library(ggtree)

############################################
#### This part should not be included in ui.R and server.R scripts
getCtx <- function(session) {
  ctx <- tercenCtx(stepId = "d872747a-94bb-4b0b-8e56-2cd055f17238",
                   workflowId = "a77770c3923fad0ca99b77fa8905471d")
  return(ctx)
}
####
############################################

ui <- shinyUI(fluidPage(
  
  titlePanel("Multiple Sequence Alignment"),
  
  sidebarPanel(
    sliderInput("plotWidth", "Plot width (px)", 200, 2000, 500),
    sliderInput("plotHeight", "Plot height (px)", 200, 2000, 500),
    checkboxInput("tiplabels", "Add tip labels", value = FALSE),
    sliderInput("position", "Position", 1, 1000, value = c(50, 100)),
    sliderInput("msaoffset", "Offset", 0, 2, value = c(1), step = 0.1),
    sliderInput("msawidth", "MSA width", 0, 2, value = c(1), step = 0.1)
  ),
  
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

runApp(shinyApp(ui, server))  
