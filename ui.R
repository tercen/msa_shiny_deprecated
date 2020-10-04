library(shiny)

shinyUI(fluidPage(
  
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