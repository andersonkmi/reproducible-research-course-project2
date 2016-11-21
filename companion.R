library(plyr)
library(dplyr)
library(lattice)
library(ggplot2)
library(data.table)

stormFileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
download.file(stormFileUrl, destfile="storm_data.csv.bz2")
stormData <- read.csv("storm_data.csv.bz2")