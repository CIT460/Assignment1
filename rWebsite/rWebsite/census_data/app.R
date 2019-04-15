install.packages(c("maps", "mapproj"))

library(shiny)
library(maps)
library(mapproj)
source("helpers.R")

counties <- readRDS("data/counties.RDS")

mp <- map("county", plot = FALSE, namesonly = TRUE)
c.order <- match(mp,
  paste(counties$region, counties$subregion, sep = ","))

server <- (function(input, output) {

    indexInput <- reactive({
        var <- switch(input$var,
      "Total Population (logged)" = log(counties$pop),
      "Percent White" = counties$white,
      "Percent Black" = counties$black,
      "Percent Hispanic" = counties$hispanic,
      "Percent Asian" = counties$asian)

        var <- pmax(var, input$range[1])
        var <- pmin(var, input$range[2])
        as.integer(cut(var, 100, include.lowest = TRUE,
                   ordered = TRUE))[c.order]
    })

    shadesInput <- reactive({
        switch(input$var,
      "Percent White" = colorRampPalette(c("white", "purple"))(100),
      "Percent Black" = colorRampPalette(c("white", "black"))(100),
      "Percent Hispanic" = colorRampPalette(c("white", "darkorange3"))(100),
      "Percent Asian" = colorRampPalette(c("white", "gold"))(100))
    })

    legendText <- reactive({
        inc <- diff(range(input$range)) / 4
        c(paste0(input$range[1], " % or less"),
      paste0(input$range[1] + inc, " %"),
      paste0(input$range[1] + 2 * inc, " %"),
      paste0(input$range[1] + 3 * inc, " %"),
      paste0(input$range[2], " % or more"))
    })


    output$mapPlot <- renderPlot({
        fills <- shadesInput()[indexInput()]

        map("county", fill = TRUE, col = fills,
        resolution = 0, lty = 0, projection = "polyconic",
        myborder = 0, mar = c(0, 0, 0, 0))
        map("state", col = "white", fill = FALSE, add = TRUE, lty = 1,
        lwd = 1, projection = "polyconic", myborder = 0,
        mar = c(0, 0, 0, 0))
        legend("bottomleft", legend = legendText(),
           fill = shadesInput()[c(1, 25, 50, 75, 100)],
           title = input$var)
    })
})

ui <- shinyUI(pageWithSidebar(

  headerPanel("censusVis"),

  sidebarPanel(
    helpText("Create demographic maps with information from the 2010 US Census."),
    selectInput("var", "Choose a variable to display",
                choices = c(
                            "Percent White",
                            "Percent Black",
                            "Percent Hispanic",
                            "Percent Asian"
                            ),
                selected = "Percent White"
    ),
    sliderInput("range", "Range of interest:",
                min = 0, max = 100, value = c(0, 100))
  ),
  mainPanel(
    plotOutput("mapPlot", height = "600px")
  )
))

shinyApp(ui = ui, server = server)