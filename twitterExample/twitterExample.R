#Twitter Examples
#install the required package
install.packages("twitteR")
library("twitteR")
#To continue, you must have a Twitter account.  If you do not hav eone
#create one.

#Log into apps.twitter.com and create an create an app
#Create key for your app.  API Key, API secret key
#Accesss Token key, and Access Token secret keys are generated
#Copy the values into R as follows:


api_key <- "wTVvqzir8v06cMxlMTiiA3lvg" #your API key in the quotes
api_secret <- "HCpBnZuDP5JSFjnr6uAO7TmJSixZwlOKWZzrugNOq30diHfILE" #your API secret token in the quotes 
token <- "353393002-eOcHL9HdID15hW6YuDeNtPCmEwclKglJUTMG0lzl" #your token in the quotes
token_secret <- "781l0L3NG3kqSWptoaVb1V7N8fihSydrsyHv3rKwSitwd" #your token secret in the quotes


#Set up the Twitter oauth
setup_twitter_oauth(api_key, api_secret, token, token_secret)



?searchTwitter


tweets <- searchTwitter("having fun OR #havingfun OR funny OR #feelinggood", n = 50, lang = "en")
tweets


tweets.df <-twListToDF(tweets)

colnames(tweets.df)


write.csv(tweets.df, "tweets.csv") 
#an example of a file extension of the folder in which you 
#want to save the .csv file.


install.packages(c("leaflet", "maps"))
library(leaflet)
library(maps)

mymap <- read.csv("tweets.csv", stringsAsFactors = FALSE)


m <- leaflet(tweets.df) %>% addTiles()
tweets.df$latitude <- as.numeric(tweets.df$latitud)
tweets.df$longitude <- as.numeric(tweets.df$longitude)

m %>% addCircles(lng = ~longitude, lat = ~latitude, 
                 popup = mymap$type, weight = 8, radius = 40, 
                 color = "#fb3004", stroke = TRUE, 
                 fillOpacity = 0.8)



########################################



#install.packages("RCurl")   #install if must
#install.packages("twitteR")   #install if must
library(RCurl)
library(twitteR)



##an alternative way
#
#connect2twitter = function() {
#  # Set SSL certs globally
#  options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
#  
#  reqURL = "https://api.twitter.com/oauth/request_token"
#  accessURL = "https://api.twitter.com/oauth/access_token"
#  authURL = "https://api.twitter.com/oauth/authorize"
#  consumerKey = ''  #your key here
#  consumerSecret = ''  #key secret
#  
#  twitCred = OAuthFactory$new(consumerKey=consumerKey,consumerSecret=consumerSecret,requestURL=reqURL,accessURL=accessURL,authURL=authURL)
#  twitCred$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
#  registerTwitterOAuth(twitCred)
#}
#connect2twitter() #execute function



tweets = searchTwitter("elections", n=100,
                       since="2016-01-01",
                       geocode="37.78,-122.41,100km",
                       retryOnRateLimit=200)

#create df out of query
tweets.df = do.call("rbind",lapply(tweets,as.data.frame))



install.packages("maps")
library(maps)
#plots worldmap
map('usa')
#plots tweets
#tweets.df$longitude[800] <- 41.8721
#tweets.df$latitude[800] <- -71.2312
points(tweets.df$longitude,tweets.df$latitude, pch=20, cex=1, col="red")
#points(41.8721, -71.2312,pch=20, cex=1, col="red")
?points




###################################################

#            another example
#   Source:  https://towardsdatascience.com/setting-up-twitter-for-text-mining-in-r-bcfc5ba910f4


#fetch tweets associated with that hashtag , 50 tweets-n in 
#(en)glish-lang since the indicated date yy/mm/dd
tweets <- twitteR::searchTwitter("#rstats",n =50,lang ="en",since = '2018–01–01')
#strip retweets
strip_retweets(tweets)

#convert to data frame using the twListtoDF function
df <- twListToDF(tweets) #extract the data frame save it locally
saveRDS(df, file="data/tweets.rds")
df1 <- readRDS("mytweets.rds")



library(dplyr)
#clean up any duplicate tweets from the data frame using #dplyr::distinct
dplyr::distinct(df1)


winner <-df1 %>% select(text,retweetCount,screenName,id )%>% filter(retweetCount == max(retweetCount))
View(winner)



us <- userFactory$new(screenName= winner$screenName)
dmSend("Thank you for participating in #rstats,Your tweet had the highest retweets" , us$screenName)





#######################################

#   Another example

#     Source:   



#library(rtweet)


# Retrieve tweets
tweets <- searchTwitter("#Russia", n = 500, la="en", since = '2018-01-01')
tweets.df <- twListToDF(tweets)

## plot time series of tweets
ts_plot(tweets.df, "3 hours") +
  ggplot2::theme_minimal() +
  ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(
    x = NULL, y = NULL,
    title = "Frequency of #MachineLearning Twitter statuses from past 9 days",
    subtitle = "Twitter status (tweet) counts aggregated using three-hour intervals",
    caption = "\nSource: Data collected from Twitter's REST API via rtweet"
  )
