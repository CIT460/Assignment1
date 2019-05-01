library(shiny)


server <- (function(input, output) {

    output$sinCurve <- renderPlot({
        plot(my_sin <- function(x) { return(input$amp * sin(x)) }
            , input$minX * pi, input$maxX * pi)
    })
})

ui <- shinyUI(pageWithSidebar(

  headerPanel("Sin Curve"),

  sidebarPanel(
    numericInput("maxX", "Max X Value", value = 5,
                min = -100, max = 100, step = 5),
    numericInput("minX", "Min X Value", value = -5,
                min = -100, max = 100, step = 5),
    numericInput("amp", "Amplitude Values", value = 5,
                min = -100, max = 100, step = 5)
  ),
  mainPanel(
      plotOutput("sinCurve")
    )
))


shinyApp(ui = ui, server = server)