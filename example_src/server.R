library(shiny)
library(ggplot2)
 
# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).
library(datasets)



# Define a server for the Shiny app
shinyServer(function(input, output) {
  data.dt <- read.csv("processed.csv")  
  # Fill in the spot we created for a plot
  output$phonePlot <- renderPlot({
    
    # Render a barplot
    barplot(WorldPhones[,input$region]*1000, 
            main=input$region,
            ylab="Number of Telephones",
            xlab="Year")
  })
  output$plot <- renderText(as.character(input$variable))
  output$head1 <- renderTable(head(data.dt))
  output$ls <- renderText(print(paste(ls(), collapse = ",")))
  # output$ls <- renderText(as.character(exists("data.dt")))
})