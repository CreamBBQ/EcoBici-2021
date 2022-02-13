rm(list = ls())
setwd("/home/creambbq/code/bikes/archivos")
library(tidyverse)
library(sf)
library(ggthemes)
load("cleanData.RData")
bairesMap <- st_read("http://cdn.buenosaires.gob.ar/datosabiertos/datasets/barrios/barrios.geojson",
                     stringsAsFactors = FALSE)
bairesMap <- bairesMap %>% mutate(km2 = as.numeric(AREA)/1000000)
stations <- ecoBiciData %>% group_by(nombre_estacion_origen,lat_estacion_origen,long_estacion_origen) %>% summarise() %>%  ungroup()

ggplot() + 
  geom_sf(data = bairesMap, color = "snow4") +
  geom_point(data = stations, aes(x = long_estacion_origen, y = lat_estacion_origen),
             color = "orange", size = 2, alpha = 0.6) +
  labs(title = "Estaciones de EcoBici en los barrios de CABA", 
       subtitle = "Año 2021") +
  theme_map() +
  theme(plot.title = element_text(size = 12, face = "bold"))



