library(ProjectTemplate)
load.project()

url.list <- paste0("http://www.producthunt.com/?page=", 0:50, "#")

download.page <- function(url.x){
  doc <- htmlTreeParse(url.x, useInternalNodes = T)
  docs.df <- xpathApply(doc, 
    "//div[normalize-space(@class)='day']",
    function(day.x){
      date.x <- xmlChildren(day.x)$time %>% 
        xmlChildren %>% use_series("text") %>%
          xmlValue
      list.posts <- xmlChildren(day.x)$table %>% xmlChildren
      list.info <- lapply(list.posts, function(post.x){
        # browser()
        name <- post.x[[5]][[2]] %>% 
          xmlChildren %>% use_series("text") %>%
          xmlValue
        up.votes <- post.x[[1]] %>% 
          xmlChildren %>% 
          use_series("span") %>% 
          xmlChildren %>% 
          use_series("text") %>%
          xmlValue
        n.comments <- post.x %>%
          xmlValue %>%
          str_extract("[0-9]+ comments?|View details")
        c(name = as.character(name),
          up.votes = as.character(up.votes),
          n.comments = n.comments)
      })
      names(list.info) <- NULL
      info.df <- data.frame(Reduce(rbind, list.info))
      info.df$date <- date.x
      info.df$date <- gsub("\n", "", info.df$date)
      info.df$date <- str_trim(info.df$date)
      info.df$n.comments <- gsub("\n", "", info.df$n.comments)
      info.df$n.comments <- str_trim(info.df$n.comments)    
      info.df
  })

}
data <- lapply(url.list, function(url.x){
  download.page(url.x) %>% Reduce(rbind, .)  
}) %>% Reduce(rbind, .)

data$date.aux <- gsub("[a-zA-Z]*, ", "", data$date)
data$date.aux <- paste(gsub("[a-z]{2,2}$", "", data$date.aux), "2014")
data$date.1 <- as.Date(data$date.aux, "%B%d%Y")
data$n.comments.1 <- gsub("[^0-9]", "", data$n.comments) 
data[data$n.comments.1 == "", "n.comments.1"] <- 0
data$up.votes <- as.numeric(as.character(data$up.votes))

data$n.comments.1 <- as.numeric(as.character(data$n.comments.1))
data.dt <- as.data.table(data[, c("name", "up.votes", 
  "date.1", "n.comments.1")]) %>% unique
setnames(data.dt, c("date.1", "n.comments.1"), 
  c("date", "n.comments"))
path.x <- paste0("cache/download_",
  gsub("-", "_", Sys.Date()), ".rds")
saveRDS(unique(data.dt), path.x)
