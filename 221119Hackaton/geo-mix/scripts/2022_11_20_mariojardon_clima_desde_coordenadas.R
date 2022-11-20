#!/usr/bin/env Rscript

#Este script sirve para agregar datos sobre clima, según la clasificación Köppen-Geiger, a sets de datos que contenga coordenadas de latitud y longitud
#Los argumentos del script son un archivo .csv de entrada con tres columnas en el orden: ids, longitud y latitud 
#Y un 
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "out.csv"
}



#Librerías requeridas para "kgc"
#Librería que contiene datos sobre el clima según la clasificación Köppen-Geiger, y que predice tipo de clima a partir de coordenadas de latitud y longitud.
if (!require(shiny)) install.packages('shiny')
library(shiny)
if (!require(shinythemes)) install.packages('shinythemes')
library(shinythemes)
if (!require(plyr)) install.packages('plyr')
library(plyr)
if (!require(kgc)) install.packages('kgc')
library(kgc)


#Carga de datos
#carga del archivo .csv.
data <- read.csv(args[1])

#La función kgc::LookupCZ requiere un data frame con 3 columnas la de identificación, y las correspondientes a las coordenadas geográficas. 
#Se redondean las coordenadas de nuestro dataset a coordenadas en la tabla de referencia kgc::climatezones

coordinates <- data.frame(data[,1] , rndCoord.lon = RoundCoordinates(data[,2]) , rndCoord.lat = RoundCoordinates(data[,3]))

#Se agregan los resultdos de la función kgc::LookupCZ de nuestro 
data$Climate_Zone <- LookupCZ(coordinates, res = "course")

#Se guarda el dataset de nuevo con la nueva columna
write.csv(data , args[2], row.names = TRUE)



