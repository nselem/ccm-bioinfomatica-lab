# Ejemplo para usar la librería 'kgc' de R   

La función de kgc que desde dataframes con coordenadas devuelve una zona climática según la clasificación Köppen-Geiger es LookupCZ. El argumento principal de esta función es un dataframe con tres columnas que consten de: 

  * Identifcadores
  * Longitud 
  * Latitud 

A continuación se presenta un código con un ejemplo de juguete sobre el uso de esta función.

` library(kgc)

coordenadas <- data.frame( "IDs" = c(1) , "Longitude" = c(-90) , "Latitude" = c(45) )

coordenadas <- data.frame(coordenadas$IDs , rndCoord.lon = RoundCoordinates(coordenadas$Longitude) , rndCoord.lat = RoundCoordinates(coordenadas$Latitude))

cz <- LookupCZ(coordenadas, res = "course") `
