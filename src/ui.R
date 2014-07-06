library("shiny")
library("ggvis")

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
       "indicating the top performing product of the day.",
       "I'm considering two possible performance meassures:"),
      selectInput("variable", "", 
        choices = c("Comments", "Votes"), selected = "Comments"),
       p("Of the two measures I consider the share of comments to be",
        "more relevant, based on the fact that writing a comment",
        "requires a (perhaps only slightly) bigger effort and",
        "therefore it should be a better signal of true interest.")
    ),
    mainPanel(
      helpText("Mouse over to see details"),
      uiOutput("ggvis_ui"),
      ggvisOutput("ggvis")
      # textOutput("plot")
      # tableOutput("predictions"),
      # conditionalPanel(condition = "input.tier1 == 'BEN'",
      #   plotOutput("plot_ben", width = "100%", height = "300px")),
      # conditionalPanel(condition = "input.tier1 == 'DEB'",
      #   plotOutput("plot_deb", width = "100%", height = "300px"))
    )
  )
))