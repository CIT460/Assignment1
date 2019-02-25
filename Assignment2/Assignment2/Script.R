# Installs
install.packages(c("rvest", "dplyr", "readxl", "ggplot2"))
library(dplyr)
library(rvest)
library(readxl)
library(ggplot2)

# Functions
printf <- function(...) cat(sprintf(...))

# PROBLEM 1
url <- "https://emergency.cdc.gov/han/han00384.asp"
page <- read_html(url)
table <- html_table(page, fill = TRUE)

table <- as.data.frame(table)

# Problem 1.A
class(table)

# Problem 1.B
colnames(table)[3] = "NumFenSeiz"
HighestVal <- head(table, 1)
LowestVal <- tail(table, 1)

printValues <- function(High, Low)
{
    return(printf("Highest State: (%s) %d\nLowest State: (%s) %d", High$State[1], High$NumFenSeiz[1], Low$State[1], Low$NumFenSeiz[1]))
}
printValues(HighestVal, LowestVal)

# PROBLEM 2
hurricanes <- read.csv("https://people.sc.fsu.edu/~jburkardt/data/csv/hurricanes.csv")
hurricanes$AvgPre2010 <- NA
hurricanes$AvgPost2010 <- NA

AvgPre2010Yearly <- colSums(hurricanes[, c(3:7)])
AvgPost2010Yearly <- colSums(hurricanes[, c(8:13)])
PerYearAvg <- colSums(hurricanes[, c(3:13)])

AvgPre2010 <- sum(AvgPre2010Yearly) / 5
AvgPost2010 <- sum(AvgPost2010Yearly) / 6

png( filename = "hurricane_avgs_line_chart.png")
plot(AvgPre2010Yearly, type = "o", col = "red", xlab = "Yearly Averages", ylab = "Number of Hurricanes", main = "Hurricane Yearly Averages Pre % Post 2010")
lines(AvgPost2010Yearly, type = "o", col = "blue")
dev.off()

# PROBLEM 3
overdose.data <- read_excel("opioid.xlsx", sheet = 1, skip = 6)


totalDeaths <- overdose.data[1, 6:19]
femaleDeath <- overdose.data[2, 6:19]
maleDeath <- overdose.data[3, 6:19]

overdose.deaths <- cbind(rbind(femaleDeath, maleDeath))
