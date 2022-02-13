rm(list = ls())
setwd("/home/creambbq/code/bikes/archivos")
library(tidyverse)
library(sf)
library(ggthemes)
library(RColorBrewer)
load("dataClean.RData")
colors <- colorRampPalette(brewer.pal(8, "Set3"))(15)
bairesMap <- st_read("http://cdn.buenosaires.gob.ar/datosabiertos/datasets/barrios/barrios.geojson",
                     stringsAsFactors = FALSE)
bairesMap$COMUNA <- as.integer(bairesMap$COMUNA)
bairesMap$COMUNA <- as.factor(bairesMap$COMUNA)
bairesMap <- bairesMap %>% mutate(km2 = as.numeric(AREA)/1000000)
stations <- ecoBiciData %>% group_by(nombre_estacion_origen,lat_estacion_origen,long_estacion_origen) %>% summarise() %>%  ungroup()
##Gráfico de densidad de estaciones por barrio. 
ggplot() + 
  geom_sf(data = bairesMap, color = "snow4") +
  geom_point(data = stations, aes(x = long_estacion_origen, y = lat_estacion_origen),
             color = "orange", size = 2, alpha = 0.6) +
  labs(title = "Estaciones de EcoBici en los barrios de CABA", 
       subtitle = "Año 2021") +
  theme_map() +
  theme(plot.title = element_text(size = 12, face = "bold"))

##Gráfico de densidad de estaciones por comuna 
#sum(is.na(stations))
#class(bairesMap$COMUNA)
spaceStations <- stations %>% st_as_sf(coords = c("long_estacion_origen", "lat_estacion_origen"), crs = 4326)
ggplot() +
  geom_sf(data = bairesMap, aes(fill = COMUNA)) + 
  geom_sf(data = spaceStations, color = "darkorange2", size = 2, alpha = 0.9) +
  labs(title = "Estaciones de EcoBici por comunas de la ciudad",
       subtitle = "Año 2021",
       fill = "Comuna") +
  theme_map() +
  theme(plot.title = element_text(size = 12, face = "bold"),
        legend.position = "right") +
  scale_fill_manual(values = colors)
