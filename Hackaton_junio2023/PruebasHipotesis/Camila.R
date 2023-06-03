library("phyloseq") 
setwd("/home/camila/GIT/ccm-bioinfomatica-lab/Hackaton_junio2023/PruebasHipotesis")
# lectura dedatosen archivo .biom
Camda2023 <- import_biom("camda23.biom")
class(Camda2023 )

# cambio de los nombres de los niveles taxonomicos
colnames(Camda2023@tax_table@.Data)<- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
# se elimina ruido del inicio de los nombres 
Camda2023@tax_table@.Data <- substring(Camda2023@tax_table@.Data,4)
# tabla de taxonomia
head(Camda2023@tax_table@.Data)

# tabla de otus
head(Camda2023@otu_table@.Data)
# colnames(Camda2023@otu_table@.Data) <- substring(colnames(Camda2023@otu_table@.Data),17)

# metadatos
metadata_Camda2023 <- read.csv2("metadata_camda23.csv",header =  TRUE, row.names = 1, sep = ",")
#rownames(metadata_Camda2023) <- sample_names(metadata_Camda2023)
Camda2023@sam_data <- sample_data(metadata_Camda2023)

## diversidad alfa
index = estimate_richness(Camda2023)
index

plot_richness(physeq = Camda2023, measures = c("Observed","Chao1","Shannon","simpson"))
plot_richness(physeq = Camda2023, measures = c("Observed","Chao1","Shannon","simpson"),x = "ID_city", color = "ID_city") 

## diversidad beta
percentages <- transform_sample_counts(Camda2023, function(x) x*100 / sum(x) )
head(percentages@otu_table@.Data)
meta_ord <- ordinate(physeq = percentages, method = "NMDS", distance = "bray") 
plot_ordination(physeq = percentages, ordination = meta_ord, color = "ID_city") +
  geom_text(mapping = aes(label = colnames(Camda2023@otu_table@.Data)), size = 3, vjust = 1.5)

#####################################################################################################################

## StackBar

percentages_df <- psmelt(percentages)

# Ahora vamos a ordenar el data frame, para que nos quede en el orden que queremos graficar
percentages_df$Sample<-as.factor(percentages_df$Sample)
percentages_df$category<-as.factor(percentages_df$ID_city)
# Ordenamos respecto a categoria 
percentages_df<-percentages_df[order(percentages_df$ID_city,percentages_df$Sample),]

library("ggplot2")
ggplot(data=percentages_df, aes_string(x='Sample', y='Abundance', fill='Phylum' ,color='ID_city'))  +
  #scale_colour_manual(values=c('cyan','pink','yellow')) +
  geom_bar(aes(), stat="identity", position="stack") +
  #scale_x_discrete(limits = rev(levels(percentages_df$Category))) +
  labs(title = "Abundance", x='Sample', y='Abundance', color = 'ID_city') +
  theme(legend.key.size = unit(0.2, "cm"),
        legend.key.width = unit(0.25,"cm"),
        legend.position = "bottom",
        legend.direction = "horizontal",
        legend.title=element_text(size=8, face = "bold"),
        legend.text=element_text(size=6),
        text = element_text(size=12),
        axis.text.x = element_text(angle=90, size=5, hjust=1, vjust=0.5))



