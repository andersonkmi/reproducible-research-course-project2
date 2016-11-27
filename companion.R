library(plyr)
library(dtplyr)
library(dplyr)
library(lattice)
library(ggplot2)

stormFileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
destFileName <- "storm_data.csv.bz2"
if (!file.exists(destFileName)) download.file(stormFileUrl, destfile=destFileName, quiet=TRUE)
stormData <- read.csv("storm_data.csv.bz2", header=TRUE, sep=",")
dim(stormData)
str(stormData)
stormDataFrame <- select(stormData, EVTYPE, FATALITIES, INJURIES, PROPDMG, PROPDMGEXP, CROPDMG, CROPDMGEXP)

totalFatalitiesByEvent <- with(stormDataFrame, aggregate(FATALITIES, by = list(EVTYPE), sum), na.rm=TRUE)
names(totalFatalitiesByEvent) <- c("Event", "Total")
totalFatalitiesByEvent <- totalFatalitiesByEvent[totalFatalitiesByEvent$Total > 0, ]
totalFatalitiesByEvent <- totalFatalitiesByEvent[order(totalFatalitiesByEvent$Total, decreasing = TRUE), ]

totalInjuriesByEvent <- with(stormDataFrame, aggregate(INJURIES, by = list(EVTYPE), sum), na.rm=TRUE)
names(totalInjuriesByEvent) <- c("Event", "Total")
totalInjuriesByEvent <- totalInjuriesByEvent[totalInjuriesByEvent$Total > 0, ]
totalInjuriesByEvent <- totalInjuriesByEvent[order(totalInjuriesByEvent$Total, decreasing = TRUE), ]

## Damage calculations

expsymbol <- c("", "+", "-", "?", 0:9, "h", "H", "k", "K", "m", "M", "b", "B")
factor <- c(rep(10^0, 4), 10^0, 10^1, 10^2, 10^3, 10^4, 10^5, 10^6, 10^7, 10^8, 10^9, 10^1, 10^2, 10^2, 10^3, 10^3, 10^6, 10^6, 10^9, 10^9)
multiplier <- data.frame (symbol, factor)
