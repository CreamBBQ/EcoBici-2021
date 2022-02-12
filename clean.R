rm(list = ls())
setwd("/home/creambbq/code/bikes")

#Load data
ecoBiciData <- read.table("trips_2021.csv", header = TRUE, sep = ",", stringsAsFactors = TRUE)
ecoBiciData$id_recorrido <- NULL
ecoBiciData$id_estacion_origen <- NULL
ecoBiciData$id_estacion_destino <- NULL
ecoBiciData$direccion_estacion_origen <- NULL
ecoBiciData$direccion_estacion_destino <- NULL
#save(ecoBiciData, file = "cleanData.Rdata")
