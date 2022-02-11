rm(list = ls())
setwd("/home/creambbq/code/bikes")

#Load data
ecoBiciData <- read.table("trips_2021.csv", header = TRUE, sep = ",", stringsAsFactors = TRUE)
