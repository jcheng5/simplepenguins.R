library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)

df <- readr::read_csv("penguins.csv")

ui <- page_fillable(theme = bs_theme(bootswatch = "minty"),
  layout_sidebar(fillable = TRUE,
    sidebar(
      varSelectInput("xvar", "X variable", df, selected = "Bill Length (mm)"),
      varSelectInput("yvar", "Y variable", df, selected = "Bill Depth (mm)"),
      checkboxInput("smooth", "Add smoother"),
      checkboxInput("species", "By species", TRUE)
    ),
    plotOutput("scatter")
  )
)

server <- function(input, output, session) {
  subsetted <- reactive({
    df |> select(!!input$xvar, !!input$yvar, "Species")
  })
  
  output$scatter <- renderPlot({
    ggplot(subsetted(), aes(!!input$xvar, !!input$yvar)) +
      geom_point(if (input$species) aes(color=Species)) +
      if (input$smooth) geom_smooth()
  }, res = 100)
}

shinyApp(ui, server)
