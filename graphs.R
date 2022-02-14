rm(list = ls())
setwd("/home/creambbq/code/bikes/archivos")

#Librerias
library(tidyverse)
library(sf)
library(ggthemes)
library(RColorBrewer)

#Carga de datos 
load("dataClean.RData")
colors <- colorRampPalette(brewer.pal(8, "Set3"))(15)
bairesMap <- st_read("http://cdn.buenosaires.gob.ar/datosabiertos/datasets/barrios/barrios.geojson",
                     stringsAsFactors = FALSE)
bairesMap$COMUNA <- as.integer(bairesMap$COMUNA)
bairesMap$COMUNA <- as.factor(bairesMap$COMUNA)
bairesMap <- bairesMap %>% mutate(km2 = as.numeric(AREA)/1000000)
subte <- st_read("http://cdn.buenosaires.gob.ar/datosabiertos/datasets/subte-estaciones/subte_estaciones.geojson")
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

##Comparación con estaciones del subte 
ggplot() +
  geom_sf(data = bairesMap, color = "snow4") + 
  geom_sf(data = spaceStations, color = "darkorange2", size = 1, alpha = 0.9) +
  geom_sf(data = subte, aes(color = LINEA), size = 2) +
  labs(title = "Distribución de estaciones EcoBici en comparación con SUBTE",
       subtitle = "Año 2021") +
  theme_map() +
  theme(plot.title = element_text(size = 12, face = "bold"),
        legend.position = "right") +
  scale_color_manual(values = c("turquoise1", "red", "blue", "green", "purple", "yellow"))

##Mínutos de viaje dependiendo de si es fin de semana o no 
ggplot(ecoBiciData, 
       aes(x = duracion_recorrido_min, fill = fin_de_semana), ..scaled..) +
       geom_boxplot(alpha = 0.7) +
       coord_cartesian(xlim = c(0, 100)) +
       labs(title = "Duración de viajes en EcoBici",
            subtitle = "DIstinción por fin de semana",
            x = "Duración del viaje en minutos") +
       scale_fill_manual(values = c("#004c69","#72737e")) +
       theme_economist() +
       scale_x_continuous(breaks = seq(0,100,15)) +
       theme(legend.position = "right",
             legend.title = element_blank(),
             axis.ticks.y = element_blank(),
             axis.text.y = element_blank())

#Hora de extracción distinguiendo por si es fin de semana o no
ecoBiciData$fecha <- as.Date(ecoBiciData$fecha_origen_recorrido, tz = "America/Argentina/Buenos_Aires" ) #PONER EN EL CLEAN
ecoBiciData %>% group_by(fecha, fin_de_semana, hora) %>% 
  summarise(total = n()) %>%  group_by(fin_de_semana, hora) %>% 
  summarise(media = mean(total)) %>% 
  ggplot(aes(x = hora, y = media, fill = fin_de_semana)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Promedio de retiros de EcoBici en cada hora del día",
       subtitle = "Año 2021") + 
  scale_fill_manual(values = c("#004c69","#72737e")) +
  scale_x_continuous(breaks = seq(0, 23, 2)) +
  scale_y_continuous(breaks = seq(0, 850, 100)) + 
  theme_economist() + 
  theme(legend.title = element_blank(), 
        axis.title = element_blank()) 
  
## 20 estaciones con mayor indice de extracción

ecoBiciData %>% group_by(nombre_estacion_origen) %>% summarise(total = n()) %>% 
  arrange(desc(total)) %>% top_n(20) %>% 
  ggplot(aes(x = total, y = reorder(nombre_estacion_origen, total))) +
  geom_bar(stat = "identity", fill = "#004c69") +
  theme_economist() +
  labs(title = "20 Estaciones EcoBici con mayor cantidad de extracciones", 
       subtitle = "Año 2021",
       y = "[id est.] - [nombre]\n",
       x = "\nCantidad de extracciones") 

##Bicis nuevas: fit entró en agosto 

ecoBiciData %>% filter(fecha > as.Date("2021-07-01")) %>% 
  group_by(fecha, modelo_bicicleta) %>% summarise(total = n()) %>% 
  ggplot(aes(x = fecha, y = total, colour = modelo_bicicleta)) +
  geom_line() +
  scale_color_manual(values = c("#004c69","#72737e")) +
  labs(title = "Incorporación del nuevo módelo FIT", 
       subtitle = "Cantidad de extracciones condicional al módelo de bicicleta\n",
       y = element_blank(),
       x = element_blank()) +
  theme_economist() +
  theme(legend.title = element_blank())
  
  
         


