#######Script para filtrado de OTUs del dataset EMP ##########
#paulinapglz.99@gmail.com

#Paquetes usados

library("vroom")
library("ggplot2")
library("dplyr")

#cargando el dataset inicial

EMP_enviromental <- vroom(file = "EMPcomplete_pivot_count_fin.csv")

#Para identificar global las mas abundantes, exploracion de datos 

abundancias.p <- ggplot(EMP_enviromental, 
                       aes(x=X,
                           y = count,
                           col = "black"))  +
  geom_bar(stat = "identity") +
  scale_y_continuous(breaks = seq(0, 80, by = 10)) +
  ggtitle("Conteo total de abundancias de OTU por muestra") +
  theme_classic() +
  theme(legend.position = "none", 
        axis.text.x = element_blank()) +
  xlab("Muestras geográficas") +
  ylab("Conteo de abundancias")

#Vis

abundancias.p #plot de OTUS vs conteos

#Filtrado de datos
#el objetivo es identificar OTUS presentes en muchas muestras
#a nivel global

#El primer paso fue la exploracion de la distribucion de OTUS y 
#conteos

filtrado_abundancias_menos <- EMP_enviromental %>% 
  filter(count < 10.3098155) #se utilizo esta cifra porque es un threshold "a ojo" 

filtrado_abundancias_mas <- EMP_enviromental %>% 
  filter(count > 10.3098155)

#Ploteando 

#Para los conteos totales de menos de 10

abundancias_1.p <- ggplot(filtrado_abundancias_menos, 
                        aes(x=X,
                            y = count,
                            col = "pink"))  +
  geom_bar(stat = "identity") +
  theme(legend.position = "none", 
        axis.text.x = element_blank()) +
  xlab("Muestras geográficas") +
  ylab("Conteo de abundancias") +
  labs(title = "Conteo total de abundancias de OTU por muestra", 
          subtitle = "para muestras con abundancia menor a 10")

#Para datos con conteos de de mas de 10

abundancias_2.p <- ggplot(filtrado_abundancias_mas, 
                          aes(x=X,
                              y = count))  +
  geom_bar(stat = "identity", 
           colour="#000099") + 
theme(legend.position = "none", 
      axis.text.x = element_blank()) +
  xlab("Muestras geográficas") +
  ylab("Conteo de abundancias") +
  labs(title = "Conteo total de abundancias de OTU por muestra", 
       subtitle = "para muestras con abundancia mayor a 10")

#Vis general menos de 10

abundancias_1.p

#Vis mas de 10

abundancias_2.p

# Razonamiento es que necesitamos escoger los OTUS que tengan la mayor 
# presencia en muestras posibles, y al mismo tiempo, conteos


#Se manejo la tabla en excel 

EMP_enviromental_p_filtro <- vroom(file = "EMP.5k.CZ.Tags1.1.csv")

#Finalmente, filtrando

#Determinando variables
umbralMinimaAbundancia = 0.005  #para que quedaran al rededor de 500
umbralMinimoNumMuestras = 30  #es el 1% de los datos
otusConservados<-c() #generando lista vacia

for (j in 4:ncol(EMP_enviromental_p_filtro)-2)
{
  d<-EMP_enviromental_p_filtro[,j]
  if (sum(d > umbralMinimaAbundancia) > umbralMinimoNumMuestras)
  {
    otusConservados<-c(otusConservados, j)
  }
}

#finalmente, guardando en un objeto el resultado de filtrados

EMP_enviromental_p_filtro_fin <-EMP_enviromental_p_filtro [otusConservados]

#Guardando la tabla

write.csv( x = EMP_enviromental_p_filtro_fin, 
           file = "OTUS_conservados.csv", 
           row.names = T)

### visualizando de nuevo por pura ansiedad

final <- vroom(file = "OTUS_conservados.csv")
