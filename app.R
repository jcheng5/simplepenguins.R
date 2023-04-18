library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)

df <- palmerpenguins::penguins

choices <- c(
  "Bill length (mm)" = "bill_length_mm",
  "Bill depth (mm)" = "bill_depth_mm",
  "Flipper length (mm)" = "flipper_length_mm",
  "Body mass (g)" = "body_mass_g"
)

ui <- page_fillable(theme = bs_theme(bootswatch = "minty"),
  layout_sidebar(fillable = TRUE,
    sidebar(
      selectInput("xvar", "X variable", choices, selected = choices[[1]]),
      selectInput("yvar", "Y variable", choices, selected = choices[[2]]),
      checkboxInput("smooth", "Add smoother"),
      checkboxInput("species", "By species", TRUE)
    ),
    plotOutput("scatter")
  )
)

server <- function(input, output, session) {
  subsetted <- reactive({
    df[, unique(c(input$xvar, input$yvar, "species"))]
  })
  
  output$scatter <- renderPlot({
    ggplot(subsetted(), aes_string(input$xvar, input$yvar, color = if (input$species) "species")) +
      geom_point() +
      xlab(names(choices)[choices == input$xvar]) +
      ylab(names(choices)[choices == input$yvar]) +
      if (input$smooth) geom_smooth()
  }, res = 100)
}

shinyApp(ui, server)
