#20/nov/22
#Dr. Obed Ramirez
#Assign Labels to coordinates
#calculate error in predicted coordinates

rm(list=ls())
library(ggplot2)
library(ggforce)
library(maps)

setwd("/home/macross/compartida/data/MetagenomicForensics/MetagenomicForensics/EMP-16S/")

metadata = read.csv("New_Labels (1).csv")
dim(metadata)
head(metadata)
table(metadata$NewLabels)

#data visualization
world = map_data("world")
ggplot(data = world, aes(x=long, y=lat)) +
  coord_fixed(1.3) +
  geom_polygon(aes(group=group),fill="white") +
  geom_point(data=metadata,
             mapping=aes(x=Longitud,y=Latitud,fill=NewLabels,color=NewLabels),
             size=1,alpha=0.6) +
  geom_mark_ellipse(data=metadata,
                    mapping=aes(x=Longitud,y=Latitud,fill=NewLabels,color=NewLabels))

#get centroids and standard deviation for each label
clusters_cetroids = data.frame(LongitudeC=tapply(metadata$Longitud,metadata$NewLabels,mean),
                               LatitudeC=tapply(metadata$Latitud,metadata$NewLabels,mean),
                               LongitudeSd=tapply(metadata$Longitud,metadata$NewLabels,sd),
                               LatitudeSd=tapply(metadata$Latitud,metadata$NewLabels,sd))
head(clusters_cetroids)
write.csv(clusters_cetroids,"label_centroids.csv")
