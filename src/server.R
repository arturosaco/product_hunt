path.x <- paste0("../cache/processed_",
  gsub("-", "_", Sys.Date()), ".rds")
data.dt <- readRDS(path.x)
# data.1 <- data.dt[max.daily.comment.share == comments.share.w, ]
# data.1$id <- 1:nrow(data.1)

# data.1 <- data.1 %>% as.data.frame

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
  data.x.1 %>% 
    ggvis(x = ~date, y = ~100 * y, key := ~id) %>%
      layer_lines() %>% 
      layer_points(size := 150) %>%
      add_tooltip(function(df){
        if(is.null(df)) return(NULL)
        out <- c(Name = data.x.1[data.x.1$id == df$id, "name"],
          `# Comments` = data.x.1[data.x.1$id == df$id, "n.comments"],
          `# Up Votes` = data.x.1[data.x.1$id == df$id, "up.votes"])
        paste0(names(out), ": ", format(out), collapse = "<br />")
      }) %>% 
      add_axis("x", title = "Date") %>%
      add_axis("y", title = y.label) %>%
      bind_shiny("ggvis", "ggvis_ui")
}

shinyServer(function(input, output) {  
  observe({plot.weekly(input$variable, data.dt)})
    
  # output$simple_plot <- renderPlot(plot(1:15, -15:-1))
  # output$plot_deb <- renderPlot({
  #   print(prediction.plot(input$gov.region,
  #      input$tier1, input$tier2_deb, input$no.periods, data.case.weekly))
  # })
})

