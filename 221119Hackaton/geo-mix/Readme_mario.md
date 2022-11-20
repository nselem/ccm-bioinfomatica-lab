# Ejemplo para usar la librería 'kgc' de R   

La función de kgc que desde dataframes con coordenadas devuelve una zona climática según la clasificación Köppen-Geiger es LookupCZ. El argumento principal de esta función es un dataframe con tres columnas que consten de: 

  * Identifcadores
  * Longitud 
  * Latitud 

A continuación se presenta un código con un ejemplo de juguete sobre el uso de esta función.

~~~
#install.packages("kgc")
library(kgc)

coordenadas <- data.frame( "IDs" = c(1) , "Longitude" = c(-90) , "Latitude" = c(45) )
#Es necesario redondear las coordenadas a la base de datos de 'kgc'
coordenadas <- data.frame(coordenadas$IDs , rndCoord.lon = RoundCoordinates(coordenadas$Longitude) , rndCoord.lat = RoundCoordinates(coordenadas$Latitude))
#Se aplica la función LookupCZ
cz <- LookupCZ(coordenadas, res = "course") 
~~~

El resultado, guardado en la variable `cz` es el siguiente:

~~~
[1] Dfb
~~~
