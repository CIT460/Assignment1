install.packages("tm")
library(tm)

docs <- Corpus(DirSource("textmining/"))

length(docs)


# Create a function
toSpace <- content_transformer((function(x, pattern) return(gsub(pattern, "", x))))
writelines(as.character(docs[[1]]))
docs <- tm_map(docs, toSpace, "-")
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, toLower)
docs <- tm_map(docs, removeNumbers)









