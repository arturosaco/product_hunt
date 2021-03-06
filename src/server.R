library(shiny)
library(data.table)
library(lubridate)
library(magrittr)

data.dt <- fread("processed.csv")
data.dt[, date := as.Date(date)]

plot.weekly <- function(variable.x, data.x){
  if(variable.x != "Comments"){
    data.x.1 <- data.x[max.daily.votes.share == votes.share ]
    setnames(data.x.1, "votes.share", "y")
    y.label <- "Share of days' votes"
  } else {
    data.x.1 <- data.x[max.daily.comment.share == comments.share, ]
    setnames(data.x.1, "comments.share", "y")
    y.label <- "Share of days' comments"
  }
  data.x.1$id <- 1:nrow(data.x.1)
  data.x.1 <- data.x.1 %>% as.data.frame 
  data.x.1$fill.aux <- as.numeric(data.x.1$y > 5)
  data.x.1 %>% 
    ggvis(x = ~date, y = ~100 * y, key := ~id) %>%
      layer_lines() %>% 
      layer_points(size := 150) %>%
      add_tooltip(function(df){
        if(is.null(df)) return(NULL)
        out <- c(Name = data.x.1[data.x.1$id == df$id, "name"],
          `# Comments` = data.x.1[data.x.1$id == df$id, "n.comments"],
          `# Up Votes` = data.x.1[data.x.1$id == df$id, "upvotes"],
          `Description` = data.x.1[data.x.1$id == df$id, "description"],
          `Author's twitter handle` = data.x.1[data.x.1$id == df$id, "tw.handle"])
        paste0(names(out), ": ", format(out), collapse = "<br />")
      }) %>% 
      add_axis("x", title = "Date") %>%
      add_axis("y", title = y.label) %>%
      bind_shiny("ggvis", "ggvis_ui")
}

shinyServer(function(input, output) {  
  observe({plot.weekly(input$variable, data.dt)})
})

