# INSTALLS
install.packages(c("tm", "SnowballC"))
library(tm)
library(SnowballC)

# FUNCTIONS
toSpace <- content_transformer((function(x, pattern) return(gsub(pattern, "", x))))

docs <- Corpus(DirSource("textmining/"))

docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, toSpace, "-")
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, removeWords, stopwords("en"))
docs <- tm_map(docs, stemDocument)

################## DOCUMENT MATRIX ##############
f1 <- 'Bananas are yellow'
f2 <- 'Some bananas are green'
f3 <- 'Green bananas are not ripe'

fdocs <- VCorpus(VectorSource( c(f1, f2, f3)))
fdocs <- tm_map(fdocs, tolower)
fdocs <- tm_map(fdocs, PlainTextDocument)
fdocs <- tm_map(fdocs, stemDocument)
fdocs <- tm_map(fdocs, removeWords, stopwords("en"))
fdocs <- tm_map(fdocs, stripWhitespace)

fdocsTM <- DocumentTermMatrix(fdocs)
fdocsTM

inspect(fdocsTM)

##########################################

dtm <- DocumentTermMatrix(docs)
freq <- colSums(as.matrix(dtm))
length(freq)

ordered <- order(freq, decreasing = TRUE)

head(ordered, 10)
tail(ordered, 10)

# Restricted dtm
dtmr <- DocumentTermMatrix(docs,
                           control =
                            list(
                                wordLengths = c(4, 20),
                                bounds = list(global = c(3, 27)))
                          )

freqr <- colSums(as.matrix(dtmr))
length(freqr)

orderedr <- order(freqr, decreasing = TRUE)

head(orderedr, 10)
tail(orderedr, 10)


findFreqTerms(dtmr, lowfreq = 80)

findAssocs(dtmr, "project", .3)
