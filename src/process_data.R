library(ProjectTemplate)
load.project()

data.dt <- fread("src/download.csv")

data.dt[, name := as.character(name)]
data.dt[, date := as.Date(date)]
data.dt[, date.w := floor_date(date, "week")]
data.dt[, comments.share := as.numeric(n.comments) / sum(as.numeric(n.comments)), date.w]
data.dt[, votes.share := as.numeric(upvotes) / sum(as.numeric(upvotes)), date.w]
data.dt[, max.daily.comment.share := max(comments.share), date]
data.dt[, max.daily.votes.share := max(votes.share), date]
data.dt[, days.in.week := length(unique(date)), date.w]
data.dt <- data.dt[days.in.week != 1 & !is.na(data.dt$comments.share), ]

write.csv(data.dt, "src/processed.csv", row.names = FALSE)
