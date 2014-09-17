library(ProjectTemplate)
load.project()

url.list <- paste0("http://www.producthunt.com/?page=", 0:100, "#")

download.page <- function(url.x){
  print(url.x)
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

download.page.rvest <- function(page.x){
  library(rvest)
  page <- html(page.x)
  
  n.post.day <- page %>% html_nodes(css = ".day") %>%
    lapply(function(x){
      x %>% html_nodes(css = ".post")  %>% length
    }) %>% unlist
  
  date.x <- page %>% html_nodes(css = ".date") %>% html_text %>%
    gsub("\n", "", .) %>%
    gsub("\\s+", " ", .) %>%
    str_trim %>% 
    gsub("[a-zA-Z]*, ", "", .) %>%
    gsub("[a-z]{2,2}$", "", .) %>%
    paste("2014") %>%
    gsub("(?:^|(?:[.!?]\\s))(\\w+)", "", .) %>%
    str_trim %>%
    as.Date("%B%d%Y")
  
  dates.x <- lapply(1:length(date.x), function(x) rep(date.x[x], n.post.day[x])) %>%
    Reduce(c, .)
  
  upvotes <- page %>% html_nodes(xpath = 
    '//*[contains(concat( " ", @class, " " ), concat( " ", "vote-count", " " ))]') %>%
    html_text 
  description <- page %>% html_nodes(xpath =
    '//*[contains(concat( " ", @class, " " ), concat( " ", "description", " " ))]') %>%
    html_text
  name <- page %>% html_nodes(xpath = 
    '//*[contains(concat( " ", @class, " " ), concat( " ", "title", " " ))]') %>%
    html_text
  n.comments <- page %>% html_nodes(css = ".comment-count") %>% html_text %>% as.numeric
  tw.handle <- page %>% html_nodes(xpath =
    '//*[contains(concat( " ", @class, " " ), concat( " ", "user-username", " " ))]') %>%
    html_text %>% gsub("\n", "", .) %>% str_trim
  data.x <- data.table(date = dates.x, name, upvotes, description, tw.handle, n.comments)
}

data <- lapply(url.list, download.page.rvest) %>% rbindlist

# data <- lapply(url.list, function(url.x){
#   download.page(url.x) %>% Reduce(rbind, .)  
# }) %>% Reduce(rbind, .)

# data$date.aux <- gsub("[a-zA-Z]*, ", "", data$date)
# data$date.aux <- paste(gsub("[a-z]{2,2}$", "", data$date.aux), "2014")
# data$date.1 <- as.Date(data$date.aux, "%B%d%Y")
# data$n.comments.1 <- gsub("[^0-9]", "", data$n.comments) 
# data[data$n.comments.1 == "", "n.comments.1"] <- 0
# data$up.votes <- as.numeric(as.character(data$up.votes))

# data$n.comments.1 <- as.numeric(as.character(data$n.comments.1))
# data.dt <- as.data.table(data[, c("name", "up.votes", 
#   "date.1", "n.comments.1")]) %>% unique
# setnames(data.dt, c("date.1", "n.comments.1"), 
#   c("date", "n.comments"))

 write.csv(data, "src/download.csv", row.names = FALSE)

