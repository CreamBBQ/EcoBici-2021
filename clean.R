rm(list = ls())
setwd("/home/creambbq/code/bikes/archivos")
library(tidyverse)

##load data
ecoBiciData <- read.table("trips_2021.csv", header = TRUE, sep = ",", stringsAsFactors = TRUE)

##clean
ecoBiciData$id_recorrido <- NULL
ecoBiciData$id_estacion_origen <- NULL
ecoBiciData$id_estacion_destino <- NULL
ecoBiciData$direccion_estacion_origen <- NULL
ecoBiciData$direccion_estacion_destino <- NULL
#Elimino los tres datos asociados a la estación "-006 planeada", que solo poseen 
#tres observaciones con variables muy raras en una dirección donde no hay ninguna 
#estación habitlitada al momento. 
ecoBiciData <- ecoBiciData %>% filter(nombre_estacion_destino != "006 - planeada")
ecoBiciData$nombre_estacion_destino <- factor(ecoBiciData$nombre_estacion_destino)

##new variables
ecoBiciData$fecha_origen_recorrido <- as.POSIXct(ecoBiciData$fecha_origen_recorrido, format = "%Y-%m-%d %H:%M:%OS")
ecoBiciData$fecha_destino_recorrido <- as.POSIXct(ecoBiciData$fecha_destino_recorrido, format = "%Y-%m-%d %H:%M:%OS")
ecoBiciData$dia <-  strftime(ecoBiciData$fecha_origen_recorrido, format = "%w")
ecoBiciData$fecha <- as.Date(ecoBiciData$fecha_origen_recorrido, tz = "America/Argentina/Buenos_Aires" )
ecoBiciData$duracion_recorrido_min <- ecoBiciData$duracion_recorrido / 60
ecoBiciData <- ecoBiciData %>% mutate(hora = strftime(ecoBiciData$fecha_origen_recorrido, format = "%H"),
                                      hora = as.numeric(hora))
ecoBiciData <- ecoBiciData %>% mutate(fin_de_semana = case_when(dia %in% c(1,2,3,4,5) ~ "Día de semana", 
                                                                dia %in% c(0,6) ~ "Fin de semana"),
                                      fin_de_semana = as.factor(fin_de_semana))
ecoBiciData <- ecoBiciData %>% mutate(misma_estacion = case_when((nombre_estacion_destino == nombre_estacion_origen) == TRUE ~ "misma",
                                                                 (nombre_estacion_destino == nombre_estacion_origen) == FALSE ~ "distinta"),
                                      misma_estacion = as.factor(misma_estacion))

#save(ecoBiciData, file = "dataClean.RData")
