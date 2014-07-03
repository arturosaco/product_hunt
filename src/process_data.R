library(ProjectTemplate)
load.project()

path.x <- paste0("cache/download_",
  gsub("-", "_", Sys.Date()), ".rds")
data.dt <- readRDS(path.x)

data.dt[, name := as.character(name)]
data.dt[, date.w := floor_date(date, "week")]
data.dt[, comments.share.w := n.comments / sum(n.comments), date.w]
data.dt[, max.daily.comment.share := max(comments.share.w), date]

data.1 <- data.dt[max.daily.comment.share == comments.share.w, ]
data.1$id <- 1:nrow(data.1)

data.1 %>%
  as.data.frame %>%
  ggvis(x = ~date, y = ~100 * comments.share.w,
    key := ~id) %>%
  layer_lines() %>% layer_points(size := 150) %>%
  add_tooltip(function(df){
    if(is.null(df)) return(NULL)
    out <- c(
      Name = data.1[data.1$id == df$id, name],
      `# Comments` = data.1[data.1$id == df$id, n.comments],
      `# Up Votes` = data.1[data.1$id == df$id, up.votes])
    paste0(names(out), ": ", format(out), collapse = "<br />")
  }) %>% add_axis("x", title = "Date") %>%
  add_axis("y", title = "Comments share")
