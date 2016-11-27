library(plyr)
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

par(mar = c(10.5, 5, 1, 1))
barplot(totalFatalitiesByEvent$Total[1:20], names.arg=totalFatalitiesByEvent$Event[1:20], las = 2, cex.names = 0.8, col="red", main="Top 20 most fatal events", ylab="Fatalities")


totalInjuriesByEvent <- with(stormDataFrame, aggregate(INJURIES, by = list(EVTYPE), sum), na.rm=TRUE)
names(totalInjuriesByEvent) <- c("Event", "Total")
totalInjuriesByEvent <- totalInjuriesByEvent[totalInjuriesByEvent$Total > 0, ]
totalInjuriesByEvent <- totalInjuriesByEvent[order(totalInjuriesByEvent$Total, decreasing = TRUE), ]

par(mar = c(9.5, 5, 1, 1))
barplot(totalInjuriesByEvent$Total[1:20], names.arg=totalInjuriesByEvent$Event[1:20], las = 2, cex.names = 0.8, col="orange", main="Top 20 most injurious events")
title(ylab="Injuries", line=4)


## Damage calculations

expsymbol <- c("", "+", "-", "?", 0:9, "h", "H", "k", "K", "m", "M", "b", "B")
factor <- c(rep(10^0, 4), 10^0, 10^1, 10^2, 10^3, 10^4, 10^5, 10^6, 10^7, 10^8, 10^9, 10^2, 10^2, 10^3, 10^3, 10^6, 10^6, 10^9, 10^9)
multiplier <- data.frame (expsymbol, factor)

stormDataFrame$CalculatedPropertyDmg <- stormDataFrame$PROPDMG * multiplier[match(stormDataFrame$PROPDMGEXP, multiplier$expsymbol), 2]
stormDataFrame$CalculatedCropDmg <- stormDataFrame$CROPDMG * multiplier[match(stormDataFrame$CROPDMGEXP, multiplier$expsymbol), 2]
stormDataFrame$TotalDamages <- stormDataFrame$CalculatedPropertyDmg + stormDataFrame$CalculatedCropDmg
stormDataFrame$TotalDamages <- stormDataFrame$TotalDamages / 1000000000

totalDamagesByEvent <- with(stormDataFrame, aggregate(TotalDamages, by = list(EVTYPE), sum), na.rm=TRUE)
names(totalDamagesByEvent) <- c("Event", "Total")
totalDamagesByEvent <- totalDamagesByEvent[totalDamagesByEvent$Total > 0, ]
totalDamagesByEvent <- totalDamagesByEvent[order(totalDamagesByEvent$Total, decreasing = TRUE), ]

par(mar = c(9.5, 5, 1, 1))
barplot(totalDamagesByEvent$Total[1:20], names.arg=totalDamagesByEvent$Event[1:20], las = 2, cex.names = 0.8, col="blue", main="Top 20 most damaging events")
title(ylab="Damages in billion US$", line=4)