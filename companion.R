library(plyr)
library(dtplyr)
library(dplyr)
library(lattice)
library(ggplot2)

stormFileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
destFileName <- "storm_data.csv.bz2"
if (!file.exists(destFileName)) download.file(stormFileUrl, destfile=destFileName, quiet=TRUE)
stormData <- read.csv("storm_data.csv.bz2", header=TRUE, sep=",")
stormDataFrame <- select(stormData, EVTYPE, FATALITIES, INJURIES, PROPDMG, PROPDMGEXP, CROPDMG, CROPDMGEXP)
unique(stormDataFrame$PROPDMGEXP)
unique(stormDataFrame$CROPDMGEXP)