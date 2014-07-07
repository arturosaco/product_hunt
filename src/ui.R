library("shiny")
library("ggvis")

# Define UI for dataset viewer application
shinyUI(fluidPage(  
  # Application title
  titlePanel("Product Hunt Daily Top Performer"),
  
  # Sidebar with controls to select a dataset and specify the
  # number of observations to view
  sidebarLayout(
    sidebarPanel(
      p("This web app display information scrapped from Product Hunt",
       "starting from February to today."),

      p("The idea is that the plot displays everyday's top performing",
        "product, aiming to provide a quick way to identify products that 
        are getting a lot of buzz relative to that day's activity (mouse over to see some details about the product).",
        "I'm considering two performance measures here:"),
      selectInput("variable", "", 
        choices = c("Comments", "Votes"), selected = "Comments"),
       p("Of the two measures I consider the share of comments to be",
        "more relevant, based on the fact that writing a comment",
        "requires a (perhaps only slightly) bigger effort and",
        "therefore it should be a better signal of true interest."),
       p("A couple of ways I can think of in which this could be further",
        "developed are:",
        tags$ul(
          tags$li("Add a product categorization that allows to filter products by type."), 
          tags$li("Scrape the ids of the people posting the products, and people commenting on",
            "products to try to understand Product Hunt's network."), 
          tags$li("Set up an automated email sending each day's top performer including ",
            "the product's info."))),
       p("The source code for scraping Product Hunt and running this",
        "app is at:",
        a("github/arturosaco", 
          href = "https://github.com/arturosaco/product_hunt"))
    ),
    mainPanel(
      helpText("Mouse over to find each days top performing product details."),
      uiOutput("ggvis_ui"),
      ggvisOutput("ggvis"),
      p("Each point shows the comments/upvotes share for the top performing product of that day.",
      "It is a good idea to consider daily shares to account for two features of the data",
      "that were exposed during the exploration phase:"),
      tags$ul(
          tags$li("There is clearly more activity on some days of the week (peak is usually on Tuesdays and weekends have a lot less activity)."), 
          tags$li("Activity on Product Hunt is growing; The same product would receive more upvotes and comments today than one month ago."))

    )
  )
))

# aux <- data.dt[,sum(n.comments), date]
# aux$weekday <- weekdays(aux$date)
# aux %>% ggplot(aes(x=date, y = V1, 
#   colour = factor(weekday), group = 1)) + 
#   geom_line(colour = "black") + geom_point()
