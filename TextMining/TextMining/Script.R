getwd()
install.packages("tm")
library(tm)

docs <- Corpus(DirSource("textmining/"))

? Corpus
class(docs)
length(docs)

docs[[1]]
writeLines(as.character(docs[[30]]))


