# cargamos librerias
library("phyloseq")
library("ggplot2")
library("igraph")
library("vegan")
library(readr)
library(dplyr)
library("GUniFrac")
library("pbkrtest")
library("phyloseq")
library("RColorBrewer")
library("patchwork")
#library("BiodiversityR")

setwd("/home/shaday/GIT/ccm-bioinfomatica-lab/Hackaton_junio2023/Resistencia")

Camda=import_biom("data/camda23.biom")

Camda@tax_table@.Data <- substring(Camda@tax_table@.Data, 4) #cut the firts character of tax
colnames(Camda@tax_table@.Data)<- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")

absolute_order <- tax_glom(Camda, taxrank = 'Order')
percentages_order <- transform_sample_counts(absolute_order, function(x) x / sum(x) )


otu_order_absolute=t(absolute_order@otu_table@.Data)
otu_order_relative=t(percentages_order@otu_table@.Data)

meta <- read_csv("data/metadata_camda23.csv")
View(meta)

otu_order_absolute=data.frame(otu_order_absolute)
meta=data.frame(meta)
df_complete_order_absolute=cbind(meta,otu_order_absolute)

otu_order_relative=data.frame(otu_order_relative)
meta=data.frame(meta)
df_complete_order_relative=cbind(meta,otu_order_relative)

write_csv(df_complete_order_absolute, "data/absolute_order.csv", col_names = TRUE)
write_csv(df_complete_order_relative, "data/relative_order.csv", col_names = TRUE)


amr <- read.delim("/home/shaday/c23/amr/amr-biom.tsv", sep = "\t")
amr=t(amr)
nombres_columnas <- amr[1, ]
colnames(amr) <- nombres_columnas
amr=data.frame(amr)
amr <- slice(amr, -1)

write_csv(amr, "data/amr_metadatos.csv", col_names = TRUE)
