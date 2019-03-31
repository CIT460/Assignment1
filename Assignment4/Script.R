# Installs
install.packages(c("rvest", "dplyr", "ggplot2", "tm", "SnowballC", "wordcloud"))
library(dplyr)
library(rvest)
library(tm)
library(SnowballC)
library(wordcloud)
library(ggplot2)

# Problem 1
corpus <- Corpus(DirSource("churchill"))

corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, removeNumbers)
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords())
corpus = tm_map(corpus, stemDocument)
corpus = tm_map(corpus, stripWhitespace)

docMatrix <- TermDocumentMatrix(corpus)

m <- as.matrix(docMatrix)
v <- sort(rowSums(m), decreasing = TRUE)
d <- data.frame(word = names(v), freq = v)

#Part 1
set.seed(1996)
wordcloud(words = d$word, freq = d$frequency, min.freq = 1,
          max.words = 200, random.order = FALSE, rot.per = 0.35)

#Part 2
BarData <- head(d, 20)
bgraph <- ggplot(data = BarData, aes(x = word, y = freq)) +
    geom_bar(stat = "identity")
bgraph

#Part 3
head(unlist(findAssocs(docMatrix, "war", .2)), 100)
head(unlist(findAssocs(docMatrix, "peace", .2)), 100)

# Problem 2

# Part 1
url <- "https://www.supremecourt.gov/opinions/slipopinion/18"
page <- read_html(url)
table <- html_table(page, fill = FALSE, trim = TRUE)

df <- table[unlist(lapply(
  table,
  function(x) sum(grepl("Docket", names(x))) > 0
))] %>%
  bind_rows()

corpus <- VCorpus(VectorSource(df))
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, removeNumbers)
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords())
corpus = tm_map(corpus, stemDocument)
corpus = tm_map(corpus, stripWhitespace)

dtm = TermDocumentMatrix(corpus)
dtm = removeSparseTerms(dtm, 0.999)

m <- as.matrix(dtm)
v <- sort(rowSums(m), decreasing = TRUE)
d <- data.frame(word = names(v), freq = v)

set.seed(1996)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words = 200, random.order = FALSE, rot.per = 0.35)

# Part 2
limited <- head(d, 20)
limited
p <- ggplot(data = limited, aes(x = word, y = freq)) +
    geom_bar(stat = "identity")
p
