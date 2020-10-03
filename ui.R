library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Multiple Sequence Alignment"),

  mainPanel(
    uiOutput("reacOut")
  )
  
))