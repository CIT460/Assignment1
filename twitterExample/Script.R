install.packages("twitteR")
install.packages("RCurl")
library("twitteR")
library("RCurl")

api_key <- ""
api_secret <- ""
token <- ""
token_secret <- ""

setup_twitter_oauth(api_key, api_secret, token, token_secret)
