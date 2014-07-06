install.packages(c('ggvis', 'shiny', 
  "data.table", "lubridate", "magrittr"))

library(ggplot2)
library(shiny)
# library(dplyr)
library(data.table)
library(lubridate)
library(magrittr)

data.dt <- fread("processed.csv")
data.dt[, date := as.Date(date)]

plot.weekly <- function(variable.x, data.x){
  if(variable.x != "Comments"){
    data.x.1 <- data.x[max.daily.votes.share == votes.share.w, ]
    setnames(data.x.1, "votes.share.w", "y")
    y.label <- "Share of week's votes"
  } else {
    data.x.1 <- data.x[max.daily.comment.share == comments.share.w, ]
    setnames(data.x.1, "comments.share.w", "y")
    y.label <- "Share of week's comments"
  }
  data.x.1$id <- 1:nrow(data.x.1)
  data.x.1 <- data.x.1 %>% as.data.frame 
  # data.x.1 %>% 
  #   ggvis(x = ~date, y = ~100 * y, key := ~id) %>%
  #     layer_lines() %>% 
  #     layer_points(size := 150) %>%
  #     add_tooltip(function(df){
  #       if(is.null(df)) return(NULL)
  #       out <- c(Name = data.x.1[data.x.1$id == df$id, "name"],
  #         `# Comments` = data.x.1[data.x.1$id == df$id, "n.comments"],
  #         `# Up Votes` = data.x.1[data.x.1$id == df$id, "up.votes"])
  #       paste0(names(out), ": ", format(out), collapse = "<br />")
  #     }) %>% 
  #     add_axis("x", title = "Date") %>%
  #     add_axis("y", title = y.label) %>%
  #     bind_shiny("ggvis", "ggvis_ui")
  ggplot(data.x.1, aes(x = date, y = y)) +
    geom_line() + geom_point()
}

shinyServer(function(input, output) {  
  # observe({plot.weekly(input$variable, data.dt)})
  output$plot <- renderPlot(print(plot.weekly(input$variable, data.dt)))
})

