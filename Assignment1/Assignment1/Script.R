# Written by Bailey Miller 
# 1/28/2019 7:02 PM


# 1 Create a data frame based on the following data
userHeightWeight <- data.frame(name = c("Joe", "Sue", "Jane", "Adam", "Bob", "Dale", "Kim", "Trish"),
                               height = c(167, 145, 155, 190, 164, 155, 152, 161),
                               weight = c(63, 55, 57, 71, 70, 52, 53, 61))


# 2 Use the first column of previous data frame and create a second data frame
userGender <- data.frame(name = userHeightWeight[1], Sex = c("M", "F", "F", "M", "M", "M", "F", "F"))

# 3 Combine the two data frames into one data frame object
users <- merge.data.frame(userHeightWeight, userGender)

users

# 4 In this exercise you are working with a built in objects state.abb and state.center.
# Part A
stateLocations <- data.frame(stateAbrv = state.abb, state.center["x"], state.center["y"])
colnames(stateLocations)[2] <- "Lat"
colnames(stateLocations)[3] <- "Long"

# Part B
searchStates <- c("NY", "PA", "MA", "VT", "CT", "NJ", "MD", "NH", "RI")

# Part C
filteredLocations <- stateLocations[match(searchStates, stateLocations$stateAbrv),]
filteredLocations

# 5 Print the names of the top 5 states with the highest life expectancy
lifeExpects <- data.frame(state.x77)
sortedLifeExpects <- head(lifeExpects[order(lifeExpects$Life.Exp, decreasing = TRUE),] , n = 5)
sortedLifeExpects["Life.Exp"]
