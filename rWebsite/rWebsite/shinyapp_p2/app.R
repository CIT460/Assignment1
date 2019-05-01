library(shiny)
library(ggplot2)
library(dplyr)

server <- (function(input, output) {
    output$table <- renderDataTable({ diamonds %>% filter(cut == input$cut) %>% filter(price <= input$price) %>% filter(clarity == input$clarity) %>% arrange(desc(price)) })
})

ui <- shinyUI(pageWithSidebar(
  headerPanel("Diamond Selector"),

  sidebarPanel(
    numericInput("price", "Price", value = 150,min = 0),
    selectInput("cut", "Cut",
                c("Ideal", "Premium", "Good", "Very Good", "Fair")),
    selectInput("clarity", "Clarity",
                c("SI2","SI1","VS1","VS2","VVS2","VVS1","I1","IF"))
  ),
  mainPanel(
      dataTableOutput('table')
    )
))

shinyApp(ui = ui, server = server)