library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)

df <- readr::read_csv("penguins.csv")
species <- unique(df$Species)

ui <- page_fillable(theme = bs_theme(bootswatch = "minty"),
  layout_sidebar(fillable = TRUE,
    sidebar(
      varSelectInput("xvar", "X variable", df, selected = "Bill Length (mm)"),
      varSelectInput("yvar", "Y variable", df, selected = "Bill Depth (mm)"),
      checkboxGroupInput(
        "species", "Filter by species", species, selected = species
      ),
      hr(),
      checkboxInput("by_species", "Show species", TRUE),
      checkboxInput("show_margins", "Show marginal plots", TRUE),
      checkboxInput("smooth", "Add smoother"),
    ),
    plotOutput("scatter")
  )
)

server <- function(input, output, session) {
  subsetted <- reactive({
    req(input$species)
    df |> filter(Species %in% input$species)
  })
  
  output$scatter <- renderPlot({
    p <- ggplot(subsetted(), aes(!!input$xvar, !!input$yvar)) + list(
      theme(legend.position = "bottom"),
      if (input$by_species) aes(color=Species),
      geom_point(),
      if (input$smooth) geom_smooth()
    )

    if (input$show_margins) {
      p <- ggExtra::ggMarginal(
        p,
        type = if (input$by_species) "density" else "histogram",
        margins = "both",
        size = 8,
        groupColour = input$by_species,
        groupFill = input$by_species
      )
    }
    p
  }, res = 100)
}

shinyApp(ui, server)
