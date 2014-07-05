library(ProjectTemplate)
load.project()

data.dt <- fread("src/download.csv")

data.dt[, name := as.character(name)]
data.dt[, date := as.Date(date)]
data.dt[, date.w := floor_date(date, "week")]
data.dt[, comments.share.w := n.comments / sum(n.comments), date.w]
data.dt[, votes.share.w := up.votes / sum(up.votes), date.w]
data.dt[, max.daily.comment.share := max(comments.share.w), date]
data.dt[, max.daily.votes.share := max(votes.share.w), date]

write.csv(data.dt, "src/processed.csv", row.names = FALSE)

###########################

# data.1 <- data.dt[max.daily.comment.share == comments.share.w, ]
# data.1$id <- 1:nrow(data.1)

# data.1 %>% as.data.frame %>%
#   ggvis(x = ~date, y = ~100 * comments.share.w, key := ~id) %>%
#   layer_lines() %>% 
#   layer_points(size := 150) %>%
#   add_tooltip(function(df){
#     if(is.null(df)) return(NULL)
#     out <- c(
#       Name = data.1[data.1$id == df$id, name],
#       `# Comments` = data.1[data.1$id == df$id, n.comments],
#       `# Up Votes` = data.1[data.1$id == df$id, up.votes])
#     paste0(names(out), ": ", format(out), collapse = "<br />")
#   }) %>% add_axis("x", title = "Date") %>%
#   add_axis("y", title = "Share of week's comments")

########################

# data.2 <- data.dt[max.daily.votes.share == votes.share.w, ]
# data.2$id <- 1:nrow(data.2)
# data.dt[max.daily.votes.share == votes.share.w, ]
# data.2 %>% as.data.frame %>%
#   ggvis(x = ~date, y = ~100 * votes.share.w, key := ~id) %>%
#   layer_lines() %>% 
#   layer_points(size := 150) %>%
#   add_tooltip(function(df){
#     if(is.null(df)) return(NULL)
#     out <- c(
#       Name = data.1[data.1$id == df$id, name],
#       `# Comments` = data.1[data.1$id == df$id, n.comments],
#       `# Up Votes` = data.1[data.1$id == df$id, up.votes])
#     paste0(names(out), ": ", format(out), collapse = "<br />")
#   }) %>% add_axis("x", title = "Date") %>%
#   add_axis("y", title = "Share of week's votes")

#############################


