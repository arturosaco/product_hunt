library(ProjectTemplate)
load.project()

data.dt <- fread("src/download.csv")

data.dt[, name := as.character(name)]
data.dt[, date := as.Date(date)]
data.dt[, date.w := floor_date(date, "week")]
data.dt[, comments.share := n.comments / sum(n.comments), date]
data.dt[, votes.share := up.votes / sum(up.votes), date]
data.dt[, max.daily.comment.share := max(comments.share), date]
data.dt[, max.daily.votes.share := max(votes.share), date]
data.dt[, days.in.week := length(unique(date)), date.w]
data.dt <- data.dt[days.in.week != 1, ]

write.csv(data.dt, "src/processed.csv", row.names = FALSE)
