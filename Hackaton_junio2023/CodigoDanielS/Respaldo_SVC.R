#install.packages("readr")
#install.packages("tidyverse")
#install.packages("generics")
#install.packages("caret")
#install.packages("e1071")
library(generics)
library(e1071)
library(tidyverse)
library(readr)
library(caret)


setwd("~/CAMDA_2023/Data4")

#################################################### MinMaxScaler
MinMaxScaler <- read_delim("dta_original_MinMaxScaler.tsv", 
                           delim = "\t", escape_double = FALSE, 
                           trim_ws = TRUE)  #Importación de datos normalizados con MinMaxScaler.

### Manipulación de las etiquetas de la base de datos para su manejo en algoritmos
y0 <- substring(colnames(MinMaxScaler[,2:length(colnames(MinMaxScaler))]), 16, 26) 
colnames(MinMaxScaler)[2:length(colnames(MinMaxScaler))] <- y0
y <- colnames(MinMaxScaler)[2:length(colnames(MinMaxScaler))]
a <- unlist(MinMaxScaler[-1,1])
b <- t(a)
MinMaxScaler_T <- as.data.frame(t(MinMaxScaler[-1,-1])) 
colnames(MinMaxScaler_T) <- b
### Finaliza el etiquetado

#random_numbers <- sample(1:length(y0), size = 58)
rango <- 500:17010 # Número de OTUS que usará el algoritmo
#rango <- 500:ncol(MinMaxScaler_T)

### Entrenamiento
attach(MinMaxScaler_T) # Facilita el acceso a la base de datos

avgMMS <- c() # Vector para almacenar los resultados de las predicciones

for(i in 1:5){ #Para realizar las predicciones iteradamente
  
  dat_train <- data.frame(y = factor(y[-as.vector(random_numbers)]), MinMaxScaler_T[-random_numbers,rango]) #Declaración de data frame para entrenamiento de algoritmo
  classifier <- svm(y ~ ., data = dat_train, scale = FALSE, kernel = "linear", cost = 10) #Entrenamiento de algoritmo SVM
  #Resultados promedio obtenidos con los distintos núcleos
  #linear 0.6206897
  #radial 0.13793103
  #sigmoid(3) 0.12068966
  #polynomial(3) 0.06896552     
  #polynomial(5) 0.06896552     
  #polynomial(2) 0.06896552     
  
  ### Predicción
  dat_test <- data.frame(y = factor(y[as.vector(random_numbers)]), MinMaxScaler_T[as.vector(random_numbers),rango]) # Datos que probará a clasificar el algoritmo
  y_pred <- predict(classifier, dat_test) # Predicción de etiquetado de la muestra dat_test
  
  ### Cálculo de matriz de confusiones
  cm <- confusionMatrix(as.factor(dat_test$y), as.factor(y_pred))
  avgMMS[i] <- cm$overall[1] #Vector de efectividad de predicciones
  
}

mean(avgMMS) #Promedio de efectividad de la predicción

#################################################### PowerTransformer

PowerTransformer <- read_delim("dta_original_PowerTransformer.tsv", 
                               delim = "\t", escape_double = FALSE, 
                               trim_ws = TRUE)  #Importación de datos normalizados con MinMaxScaler.

### Manipulación de las etiquetas de la base de datos para su manejo en algoritmos
y0 <- substring(colnames(PowerTransformer[,2:length(colnames(PowerTransformer))]), 16, 26) 
colnames(PowerTransformer)[2:length(colnames(PowerTransformer))] <- y0
y <- colnames(PowerTransformer)[2:length(colnames(PowerTransformer))]
a <- unlist(PowerTransformer[-1,1])
b <- t(a)
PowerTransformer_T <- as.data.frame(t(PowerTransformer[-1,-1])) 
colnames(PowerTransformer_T) <- b
### Finaliza el etiquetado

#random_numbers <- sample(1:length(y0), size = 58)
rango <- 500:17010
#rango <- 500:ncol(PowerTransformer_T)

### Entrenamiento
attach(PowerTransformer_T)

avgPwT <- c()

for(i in 1:10){
  
  dat_train <- data.frame(y = factor(y[-as.vector(random_numbers)]), PowerTransformer_T[-random_numbers,rango]) #Declaración de data frame para entrenamiento de algoritmo
  classifier <- svm(y ~ ., data = dat_train, scale = FALSE, kernel = "radial", cost = 10) #Entrenamiento de algoritmo SVM
  #linear 0.32
  #radial 0.32
  #sigmoid(4) 0.05172414 
  #polynomial(3) 0.05
  #polynomial(5) 0.05172414
  #polynomial(2) 0.05172414 
  
  ### Predicción
  dat_test <- data.frame(y = factor(y[as.vector(random_numbers)]), PowerTransformer_T[as.vector(random_numbers),rango])
  y_pred <- predict(classifier, dat_test)
  
  ### Cálculo de matriz de confusiones
  cm <- confusionMatrix(as.factor(dat_test$y), as.factor(y_pred))
  cm
  avgPwT[i] <- cm$overall[1]
  
}

avgPwT

mean(avgPwT)


#################################################### Normalizer

Normalizer <- read_delim("dta_original_Normalizer.tsv", 
                         delim = "\t", escape_double = FALSE, 
                         trim_ws = TRUE)  #Importación de datos normalizados con MinMaxScaler.

### Manipulación de las etiquetas de la base de datos para su manejo en algoritmos
y0 <- substring(colnames(Normalizer[,2:length(colnames(Normalizer))]), 16, 26) 
colnames(Normalizer)[2:length(colnames(Normalizer))] <- y0
y <- colnames(Normalizer)[2:length(colnames(Normalizer))]
a <- unlist(Normalizer[-1,1])
b <- t(a)
Normalizer_T <- as.data.frame(t(Normalizer[-1,-1])) 
colnames(Normalizer_T) <- b
### Finaliza el etiquetado

#random_numbers <- sample(1:length(y0), size = 58)
rango <- 500:17010
#rango <- 500:ncol(Normalizer_T)

### Entrenamiento
attach(Normalizer_T)

avgNor <- c()

#for(i in 1:10){

dat_train <- data.frame(y = factor(y[-as.vector(random_numbers)]), Normalizer_T[-random_numbers,rango]) #Declaración de data frame para entrenamiento de algoritmo
classifier <- svm(y ~ ., data = dat_train, scale = FALSE, kernel = "sigmoid", degree = 4, cost = 10) #Entrenamiento de algoritmo SVM
#linear 0.32
#radial 0.32
#sigmoid(4) 0.05172414 
#polynomial(3) 0.05
#polynomial(5) 0.05172414
#polynomial(2) 0.05172414 

#Queda mejor el kernel "linear" o "radial"

### Predicción
dat_test <- data.frame(y = factor(y[as.vector(random_numbers)]), Normalizer_T[as.vector(random_numbers),rango])
y_pred <- predict(classifier, dat_test)

### Cálculo de matriz de confusiones
cm <- confusionMatrix(as.factor(dat_test$y), as.factor(y_pred))
cm$overall[1]
avgNor[i] <- cm$overall[1]

#}

avgNor

mean(avgNor)


#################################################### QuantileTransformer

QuantileTransformer <- read_delim("dta_original_QuantileTransformer.tsv", 
                                  delim = "\t", escape_double = FALSE, 
                                  trim_ws = TRUE)  #Importación de datos normalizados con MinMaxScaler.

### Manipulación de las etiquetas de la base de datos para su manejo en algoritmos
y0 <- substring(colnames(QuantileTransformer[,2:length(colnames(QuantileTransformer))]), 16, 26) 
colnames(QuantileTransformer)[2:length(colnames(QuantileTransformer))] <- y0
y <- colnames(QuantileTransformer)[2:length(colnames(QuantileTransformer))]
a <- unlist(QuantileTransformer[-1,1])
b <- t(a)
QuantileTransformer_T <- as.data.frame(t(QuantileTransformer[-1,-1])) 
colnames(QuantileTransformer_T) <- b
### Finaliza el etiquetado

#random_numbers <- sample(1:length(y0), size = 58)
rango <- 500:17010
#rango <- 500:ncol(Normalizer_T)

### Entrenamiento
attach(QuantileTransformer_T)

#avgNor <- c()

#for(i in 1:10){

dat_train <- data.frame(y = factor(y[-as.vector(random_numbers)]), QuantileTransformer_T[-random_numbers,rango]) #Declaración de data frame para entrenamiento de algoritmo
classifier <- svm(y ~ ., data = dat_train, scale = FALSE, kernel = "sigmoid", cost = 10) #Entrenamiento de algoritmo SVM
#linear 0.7241379 
#radial 0.6724138 
#sigmoid(3) 0.5517241 
#polynomial(3) 0.137931 
#polynomial(5) 
#polynomial(2)  

#Queda mejor el kernel "linear"

### Predicción
dat_test <- data.frame(y = factor(y[as.vector(random_numbers)]), QuantileTransformer_T[as.vector(random_numbers),rango])
y_pred <- predict(classifier, dat_test)

### Cálculo de matriz de confusiones
cm <- confusionMatrix(as.factor(dat_test$y), as.factor(y_pred))
cm$overall[1]
#avgNor[i] <- cm$overall[1]

#}

#avgNor

#mean(avgNor)


#################################################### RobustScaler

RobustScaler <- read_delim("dta_original_RobustScaler.tsv", 
                           delim = "\t", escape_double = FALSE, 
                           trim_ws = TRUE)  #Importación de datos normalizados con MinMaxScaler.

### Manipulación de las etiquetas de la base de datos para su manejo en algoritmos
y0 <- substring(colnames(RobustScaler[,2:length(colnames(RobustScaler))]), 16, 26) 
colnames(RobustScaler)[2:length(colnames(RobustScaler))] <- y0
y <- colnames(RobustScaler)[2:length(colnames(RobustScaler))]
a <- unlist(RobustScaler[-1,1])
b <- t(a)
RobustScaler_T <- as.data.frame(t(RobustScaler[-1,-1])) 
colnames(RobustScaler_T) <- b
### Finaliza el etiquetado

#random_numbers <- sample(1:length(y0), size = 58)
rango <- 500:17010
#rango <- 500:ncol(RobustScaler_T)

### Entrenamiento
attach(RobustScaler_T)

#avgNor <- c()

#for(i in 1:10){

dat_train <- data.frame(y = factor(y[-as.vector(random_numbers)]), RobustScaler_T[-random_numbers,rango]) #Declaración de data frame para entrenamiento de algoritmo
classifier <- svm(y ~ ., data = dat_train, scale = FALSE, kernel = "polynomial", degree = 2, cost = 10) #Entrenamiento de algoritmo SVM
#linear 0.5172414 
#radial 0.2931034 
#sigmoid(3) 0.2241379 
#polynomial(3) 0.2758621 
#polynomial(4) 0.2586207 
#polynomial(2) 0.3275862 

#Queda mejor el kernel "linear"

### Predicción
dat_test <- data.frame(y = factor(y[as.vector(random_numbers)]), RobustScaler_T[as.vector(random_numbers),rango])
y_pred <- predict(classifier, dat_test)

### Cálculo de matriz de confusiones
cm <- confusionMatrix(as.factor(dat_test$y), as.factor(y_pred))
cm$overall[1]
#avgNor[i] <- cm$overall[1]

#}

#avgNor

#mean(avgNor)


#################################################### StandardScaler

StandardScaler <- read_delim("dta_original_StandardScaler.tsv", 
                             delim = "\t", escape_double = FALSE, 
                             trim_ws = TRUE)  #Importación de datos normalizados con MinMaxScaler.

### Manipulación de las etiquetas de la base de datos para su manejo en algoritmos
y0 <- substring(colnames(StandardScaler[,2:length(colnames(StandardScaler))]), 16, 26) 
colnames(StandardScaler)[2:length(colnames(StandardScaler))] <- y0
y <- colnames(StandardScaler)[2:length(colnames(StandardScaler))]
a <- unlist(StandardScaler[-1,1])
b <- t(a)
StandardScaler_T <- as.data.frame(t(StandardScaler[-1,-1])) 
colnames(StandardScaler_T) <- b
### Finaliza el etiquetado

#random_numbers <- sample(1:length(y0), size = 58)
rango <- 500:17010
#rango <- 500:ncol(StandardScaler_T)

### Entrenamiento
attach(StandardScaler_T)

#avgNor <- c()

#for(i in 1:10){

dat_train <- data.frame(y = factor(y[-as.vector(random_numbers)]), StandardScaler_T[-random_numbers,rango]) #Declaración de data frame para entrenamiento de algoritmo
classifier <- svm(y ~ ., data = dat_train, scale = FALSE, kernel = "sigmoid", cost = 10) #Entrenamiento de algoritmo SVM
#linear 0.5172414 
#radial 0.4137931 
#sigmoid(3) 0.4482759 
#polynomial(3) 0.06896552 
#polynomial(4) 0.05172414 
#polynomial(2) 0.1034483 

#Queda mejor el kernel "linear"

### Predicción
dat_test <- data.frame(y = factor(y[as.vector(random_numbers)]), StandardScaler_T[as.vector(random_numbers),rango])
y_pred <- predict(classifier, dat_test)

### Cálculo de matriz de confusiones
cm <- confusionMatrix(as.factor(dat_test$y), as.factor(y_pred))
cm$overall[1]
#avgNor[i] <- cm$overall[1]

#}

#avgNor

#mean(avgNor)
