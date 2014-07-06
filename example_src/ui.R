library(shiny)
 
# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).
library(datasets)
 
# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(    
    
    # Give the page a title
    titlePanel("Telephones by region"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar with one input
      sidebarPanel(
        selectInput("region", "Region:", 
                    choices=colnames(WorldPhones)),
        hr(),
        helpText("Data from AT&T (1961) The World's Telephones."),
        selectInput("variable", "", 
          choices = c("Comments", "Votes"), selected = "Comments")
      ),
      
      # Create a spot for the barplot
      mainPanel(
        textOutput("ls"),
        plotOutput("phonePlot"),
        textOutput("plot")
        #tableOutput("head1")
      )
      
    )
  )
)