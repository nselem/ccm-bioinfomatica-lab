#Este script sirve para agregar datos sobre clima, según la clasificación Köppen-Geiger, a sets de datos que contenga coordenadas de latitud y longitud



#install.packages("shiny")
#install.packages("shinythemes")
#install.packages("readxl")
#install.packages("kgc")

#Librería para leer archivos de excel
library(readxl)
#Librerías requeridas para "kgc"
library(shiny)
library(shinythemes)
#Librería que contiene datos sobre el clima según la clasificación Köppen-Geiger, y que predice tipo de clima a partir de coordenadas de latitud y longitud.
library(kgc)

#Carga de datos
#Ejemplo de carga de archivo formato excel
data <- read_xlsx(path = "~/GlobalAtlas-16S/Dataset_01_22_2018.xlsx", sheet = 1, col_names = TRUE)
#Ejemplo de carga de datos en .csv, .tsv, o parecidos.
data_emp <- read.csv("GlobalAtlas-16S/CAMDA_2019_EMP_metainformation.tsv", sep = "\t")


#La función kgc::LookupCZ requiere un data frame con 3 columnas la de identificación, y las correspondientes a las coordenadas geográficas. 
coordinates_emp <- data_emp[,c("SampleID", "latitude_deg", "longitude_deg" )]
#Se redondean las coordenadas de nuestro dataset a coordenadas en la tabla de referencia kgc::climatezones
coordinates_emp <- data.frame(coordinates_emp$SampleID , rndCoord.lon = RoundCoordinates(coordinates_emp$longitude_deg) , rndCoord.lat = RoundCoordinates(coordinates_emp$latitude_deg))
#Se agregan los resultdos de la función kgc::LookupCZ de nuestro 
data_emp$CZ <- LookupCZ(coordinates_emp, res = "course")
#Se guarda el dataset de nuevo con la nueva columna
write.csv(data,"GlobalAtlas-16S/CAMDA_2019_EMP_metainformation.csv", row.names = TRUE)



