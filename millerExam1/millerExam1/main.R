# Installs
install.packages(c("dplyr", "ggplot2"))
library(dplyr)
library(ggplot2)

# Step 1
movies <- read.csv("movies.csv")

# Step 2
writeLines("Movie Count: ")
nrow(movies)
nonZeroBudgets <- movies %>% filter(budget > 0)
writeLines("Movie Count (Budget != 0): ")
nrow(nonZeroBudgets)
aggregate(budget ~ country, nonZeroBudgets, sum)

# Step 3
writeLines("Movie Count: ")
nrow(movies)
nonZeroBudgets <- movies %>% filter(budget > 0)
writeLines("Movie Count (Budget != 0): ")
nrow(nonZeroBudgets)
nonZeroBudgets <- movies %>% filter(budget > 0)
aggregate(budget ~ genre, nonZeroBudgets, sum)

# Step 4
usMoviesInRange <- movies %>% filter(country == "USA")
usMoviesInRange <- filter(usMoviesInRange, between(usMoviesInRange$year, 1986, 2016))
usMoviesInRangeGraphable <- aggregate(budget ~ year, usMoviesInRange, sum)
graph <- ggplot(data = usMoviesInRangeGraphable, aes(x = year, y = budget, group = 1)) +
    scale_x_continuous(breaks = seq(1986, 2016, 2)) +
    geom_line() +
    geom_point() +
    ggtitle("USA Yearly Budget")

ggsave("step4.png", plot = graph)

# Step 5
MoviesInRange <- movies
MoviesInRange <- filter(MoviesInRange, between(MoviesInRange$year, 1986, 2016))
MoviesInRangeGraphable <- aggregate(budget ~ year, MoviesInRange, sum)
graph5 <- ggplot(data = MoviesInRangeGraphable, aes(x = year, y = budget, group = 1)) +
    scale_x_continuous(breaks = seq(1986, 2016, 2)) +
    geom_line() +
    geom_point() +
    ggtitle("All countries yearly budget")

ggsave("step5.png", plot = graph5)

# Not Sure what you meant by redo for all countries so
# Here is a combined graph and here is a graph for everyone aside from the USA inside a for loop

nonZeroBudgetsBetweenYears <- movies %>% filter(budget > 0 & year >= 1986 & year <= 2016 & country != "USA")
countries <- unique(nonZeroBudgetsBetweenYears$country)
for (place in countries) {
    data <- movies %>% filter(country == as.character(place))
    data <- filter(data, between(data$year,1986, 2016))
    budgetSum <- aggregate(budget ~ year, data, sum)
    countryGraph <- ggplot(data = budgetSum, aes(x = year, y = budget, group = 1)) +
    scale_x_continuous(breaks = seq(1986, 2016, 2)) +
    geom_line() +
    geom_point() +
    ggtitle(place)
    title <- paste(place, "-step5-looped", ".png")
    ggsave(title, plot = countryGraph)
}

# Step 6
movies$newCol <- (movies$gross / movies$budget)
colnames(movies)[16] = "gross to budget ratio"
nonInfMovies <- movies %>% filter(`gross to budget ratio` != Inf)
head(nonInfMovies %>% arrange(desc(`gross to budget ratio`)) %>% select(name, `gross to budget ratio`), 10)

# Step 7
movie.count <- function(person) {
    count <- nrow(movies %>% filter(star == person))
    return(count)
}

movie.count("Steve Martin")
movie.count("Drew Barrymore")

