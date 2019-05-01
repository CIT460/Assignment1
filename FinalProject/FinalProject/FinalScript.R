install.packages("rvest");
install.packages("readxl")
install.packages("stringr")
install.packages("tidyverse")

library(rvest)
library(stringr)
library(tidyverse)
library(readxl)
df = read_excel ("CityList.xlsx")
cityDataFrame <- data.frame()

for(row in 1:nrow(df)) {
  
city.url <- (df[1,3])
                         
city.url<-as.character(city.url)
city.ny <- html_session(city.url)


hospital<-html_nodes(city.ny,'.hospitals') %>% html_text() 
business <- city.ny %>% html_nodes('.businesses-count-table') %>% html_text() 
naturalDisters <- city.ny %>% html_nodes('.natural-disasters') %>% html_text()
tourTraps <- city.ny %>% html_nodes('.article-links') %>% html_text() 
police <- city.ny %>% html_nodes('.police') %>% html_text() 
divorceRates <- city.ny %>% html_nodes('.marital-info') %>% html_text()
population <- city.ny  %>% html_nodes('.city-population') %>% html_text()
medianIncome<-city.ny %>% html_nodes('.median-income') %>% html_text() 


hospitalData <- str_split(hospital, "\\)")[[1]]


numHospital <- as.integer(length(hospitalData)-1)


numNaturalDisasters<- str_split(naturalDisters,":")[[1]]
numNaturalDisasters <- str_split(numNaturalDisasters, "\\(")[[2]]
numNaturalDisasters <- str_split(numNaturalDisasters, "\\)")[[2]]
numNaturalDisasters <- as.integer(numNaturalDisasters[1])


dataTourTraps <- str_split(tourTraps,"\r")[[1]]
numTourTraps <- as.integer(length(dataTourTraps)-3)


policeData <- str_split(police,":")[[1]]
policeData <- str_split(policeData,"\\(")[[2]]
policeData <- str_split(policeData," ")[[2]]
numPolice <- (policeData[1])
numPolice<-trimws(numPolice, which = c("both"))
numPolice<-as.numeric(gsub(",","",numPolice))
numPolice<-as.integer(numPolice)


divorceData <- str_split(divorceRates,":")[[1]]
divorceData <- divorceData[7]

populationData <- str_split(population,":")[[1]]
populationData<- populationData[[2]]
populationData<-trimws(populationData, which = c("both"))
populationData= as.numeric(gsub(",","",populationData))
populationNum <- as.integer(populationData)

addDF= data.frame(row.names = df[row,1],populationNum,divorceData,numNaturalDisasters,numTourTraps,numPolice,numHospital)
cityDataFrame <- rbind(cityDataFrame,addDF)
}


hospitalOrder$happyScore<- NULL

hospitalOrder$hospitalCapita <- (hospitalOrder$numHospital/hospitalOrder$populationNum)
hospitalOrder <- data.frame(hospitalOrder[order(hospitalOrder$hospitalCapita),])
hospitalOrder$happyScore <- c(1:65)
hospitalOrder$policeCapita <- (hospitalOrder$numPolice/hospitalOrder$populationNum)
hospitalOrder <- data.frame(hospitalOrder[order(hospitalOrder$policeCapita),])

hospitalOrder$happyScore<- (hospitalOrder$happyScore+c(1:65))

hospitalOrder$tourCapita <- (hospitalOrder$numTourTraps)
hospitalOrder <- data.frame(hospitalOrder[order(hospitalOrder$numTourTraps),])
hospitalOrder$happyScore<- (hospitalOrder$happyScore+c(1:65))

hospitalOrder <- data.frame(hospitalOrder[order(hospitalOrder$numNaturalDisasters),])
hospitalOrder$happyScore<- (hospitalOrder$happyScore+c(1:65)) 

cityDataFrame <- data.frame(hospitalOrder[order(hospitalOrder$happyScore),])

saddiesCities<-data.frame(head(cityDataFrame,20))
cityDataFrame <- data.frame(hospitalOrder[order(-hospitalOrder$happyScore),])
happiestCities<-data.frame(head(cityDataFrame,20))
library(ggplot2)
library(ggmap)
install.packages("rworldmap")
library(rworldmap)
happiestCities$cityNames <- rownames(happiestCities)
happiestCities$cityNames <- as.character(happiestCities$cityNames)

happiestCities$lon <- NULL
happiestCities$lat <- NULL

  
  latlon = geocode()
  
  happiestCities$lat[7] = as.numeric(34.052234)
  happiestCities$lon[7] = as.numeric(-118.2436)
   happiestCities$lat[9] = as.numeric(33.748995)
   
   happiestCities$lon[9] = as.numeric(-84.387982)
   

   happiestCities$lat[11] = as.numeric(39.099727)
   happiestCities$lon[11] = as.numeric(-94.578567)
   happiestCities$lat[10] = as.numeric(41.87114)
   happiestCities$lon[10] = as.numeric(-87.6297)
  
  happCitiesLocations = data.frame(happiestCities$happyScore, happiestCities$lon, happiestCities$lat)
  colnames(happCitiesLocations) = c('happyScore','lon','lat')
  usa_center = as.numeric(geocode("United States"))

  USAMap = ggmap(get_googlemap(center=usa_center, scale=2, zoom=4))
  
  
  
USAMap +
geom_point(aes(x=lon, y=lat), data=happCitiesLocations, col="orange", alpha=0.4, 
           size=happCitiesLocations$happyScore*.08) + 
scale_size_continuous(range=range(happCitiesLocations$happyScore))

saddiesCities$cityNames <- rownames(saddiesCities)
saddiesCities$cityNames <- as.character(saddiesCities$cityNames)


for (i in 1:nrow(saddiesCities)) {
  
  latlon = geocode(saddiesCities[i,10])
  
  saddiesCities$lon[i] = as.numeric(latlon[1])
  
  saddiesCities$lat[i] = as.numeric(latlon[2])
  
}

saddiesCities$lon[13] = as.numeric(-119.1587741)
saddiesCities$lat[13] = as.numeric(35.3211764)

sadiestCityLocations = data.frame(saddiesCities$happyScore, saddiesCities$lon, saddiesCities$lat)
colnames(sadiestCityLocations) = c('happyScore','lon','lat')
usa_center = as.numeric(geocode("United States"))

USAMap = ggmap(get_googlemap(center=usa_center, scale=2, zoom=4))



USAMap +
  geom_point(aes(x=lon, y=lat), data=sadiestCityLocations, col="orange", alpha=0.4, 
             size=sadiestCityLocations$happyScore*.08) + 
  scale_size_continuous(range=range(sadiestCityLocations$happyScore))




businessData <- str_split(business,"Chipotle")[[1]]
businessData <- str_split(businessData, "Quiznos")[[2]]
numChipotle <- as.integer(businessData[1])
cityDataFrame
hospitalData
