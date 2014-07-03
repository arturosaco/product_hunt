library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(  
  # Application title
  titlePanel("Product Hunt DataViz"),
  
  # Sidebar with controls to select a dataset and specify the
  # number of observations to view
  sidebarLayout(
    sidebarPanel(
      p("This webApp display information scrapped from ProductHunt",
       "starting from March 23rd to today."),

      p("The plot display one point per day",
       "indicating the top performing product of the day"),
      selectInput("variable", "Performance measure", 
        choices = c("Comments", "Votes"), selected = "Comments")
    ),
    mainPanel(
      uiOutput("ggvis_ui"),
      ggvisOutput("ggvis")
      # tableOutput("predictions"),
      # conditionalPanel(condition = "input.tier1 == 'BEN'",
      #   plotOutput("plot_ben", width = "100%", height = "300px")),
      # conditionalPanel(condition = "input.tier1 == 'DEB'",
      #   plotOutput("plot_deb", width = "100%", height = "300px"))
    )
  )
))