# 03 june 2023
# jose maria ibarra


# -------------------------------------------------------------------------
# count tables of each taxonomical level

# libraries ---------------------------------------------------------------
library("phyloseq") 

# Preprocessing -----------------------------------------------------------

# 1 biom.tsv to .biom
 
# in terminal :
# go to taxonomy/assembly-level/
 
# conda activate metagenomics
# kraken-biom *report --fmt json -o camda.biom

# go to /taxonomy/assembly-level/
# kraken-biom *report --fmt json -o reads_level.biom

# Esto nos da una tabla biom que ya podemos cortar en phyloseq


# Extract  by taxonomic levels --------------------------------------------

# Importar el biom de ensamblados  

# read biom from reads level
reads_biom <- import_biom("CAMDAjm/c23/taxonomy/read-level/reads_level.biom")


## Correct names in taxonomic table
View(reads_biom@tax_table@.Data) # View current names in table
# assign new names
colnames(reads_biom@tax_table@.Data) <- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
View(reads_biom@tax_table@.Data) # View new correct names

# eliminate extra characters in the beggining of each entry
reads_biom@tax_table@.Data <- substring(reads_biom@tax_table@.Data, 4)
View(reads_biom@tax_table@.Data)

### OPTIONAL PREPROCESSING
###Cargar metadatos 
### metadata_camda <- read.csv2("/home/camila/GIT/Tesis_Maestria/Data/fresa_solena/Data1/metadata.csv",header =  FALSE, row.names = 1, sep = ",")
###  reads_biom@sam_data <- sample_data(metadata_camda)
#### reads_biom@sam_data$Sample<-row.names(reads_biom@sam_data)

# colnames(fresa_kraken@sam_data)<-c('Treatment','Samples')
# fresa_kraken_fil <- prune_samples(!(sample_names(fresa_kraken) %in% samples_to_remove), fresa_kraken)

## Convertir a abundancias relativas  
### percentages_fil <- transform_sample_counts(fresa_kraken_fil, function(x) x*100 / sum(x) )
### percentages_df <- psmelt(percentages_fil)


# TEST
# Kingdom level
reads_glom_kingdom <- tax_glom(reads_biom, taxrank = 'Kingdom')
View(reads_glom_kingdom@tax_table@.Data)

### PLAN
# For 
# a) All data together
# b) Archea and Bacteria
# c) Eukaryota
# d) Viruses
# Create count table and tax table (dictionary) as data frames for this taxonomical levels:
# "Phylum", "Class", "Order", "Family", "Genus", "Species"

#  All reads --------------------------------------------------------------

# Phylum  -----------------------------------------------------------------
# conglomerate to phylum level
reads_glom_phylum <- tax_glom(reads_biom, taxrank = 'Phylum')
#View(reads_glom_phylum@otu_table@.Data)

# to data frame 
phylum_reads.df = as.data.frame(reads_glom_phylum@otu_table)
phylum_reads_tax.df = as.data.frame(reads_glom_phylum@tax_table)

# Quality
# 
sum(sample_sums(reads_glom_phylum)) == sum(sample_sums(subset_taxa(reads_biom, Phylum != "")))
# Save data frames
write.csv(phylum_reads.df,"~/CAMDAjm/taxonomy_levels/reads_all/read_count_phylum.csv")
write.csv(phylum_reads_tax.df,"~/CAMDAjm/taxonomy_levels/reads_all/read_taxDict_phylum.csv")


# Order -------------------------------------------------------------------
# conglomerate to order level
reads_glom_order <- tax_glom(reads_biom, taxrank = 'Order')
#View(reads_glom_order@otu_table@.Data)

# to data frame 
order_reads.df = as.data.frame(reads_glom_order@otu_table)
order_reads_tax.df = as.data.frame(reads_glom_order@tax_table)

# Quality
sum(sample_sums(reads_glom_order)) == sum(sample_sums(subset_taxa(reads_biom, Order != "")))

# Save data frames
write.csv(order_reads.df,"~/CAMDAjm/taxonomy_levels/reads_all/read_count_order.csv")
write.csv(order_reads_tax.df,"~/CAMDAjm/taxonomy_levels/reads_all/read_taxDict_order.csv")

# family -------------------------------------------------------------------
# conglomerate to family level
reads_glom_family <- tax_glom(reads_biom, taxrank = 'Family')
#View(reads_glom_family@otu_table@.Data)

# to data frame 
family_reads.df = as.data.frame(reads_glom_family@otu_table)
family_reads_tax.df = as.data.frame(reads_glom_family@tax_table)

# Quality
sum(sample_sums(reads_glom_family)) ==sum(sample_sums(subset_taxa(reads_biom, Family != "")))

# Save data frames
write.csv(family_reads.df,"~/CAMDAjm/taxonomy_levels/reads_all/read_count_family.csv")
write.csv(family_reads_tax.df,"~/CAMDAjm/taxonomy_levels/reads_all/read_taxDict_family.csv")

# genus -------------------------------------------------------------------
# conglomerate to genus level
reads_glom_genus <- tax_glom(reads_biom, taxrank = 'Genus')
#View(reads_glom_genus@otu_table@.Data)

# to data frame 
genus_reads.df = as.data.frame(reads_glom_genus@otu_table)
genus_reads_tax.df = as.data.frame(reads_glom_genus@tax_table)

# Quality
sum(sample_sums(reads_glom_genus)) == sum(sample_sums(subset_taxa(reads_biom, Genus != "")))

# Save data frames
write.csv(genus_reads.df,"~/CAMDAjm/taxonomy_levels/reads_all/read_count_genus.csv")
write.csv(genus_reads_tax.df,"~/CAMDAjm/taxonomy_levels/reads_all/read_taxDict_genus.csv")



###  Archaea and Bacteria ----------------------------------------------------
readsArchaeaBacteria = subset_taxa(reads_biom, Kingdom %in% c("Archaea","Bacteria"))

# Phylum  -----------------------------------------------------------------
# conglomerate to phylum level
readsAB_glom_phylum <- tax_glom(readsArchaeaBacteria , taxrank = 'Phylum')
#View(readsAB_glom_phylum@otu_table@.Data)

# to data frame 
phylum_readsAB.df = as.data.frame(readsAB_glom_phylum@otu_table)
phylum_readsAB_tax.df = as.data.frame(readsAB_glom_phylum@tax_table)

# Quality
# 
sum(sample_sums(readsAB_glom_phylum))  == sum(sample_sums(subset_taxa(readsArchaeaBacteria , Phylum != "")))
# Save data frames
write.csv(phylum_readsAB.df,"~/CAMDAjm/taxonomy_levels/readsAB/readsAB_count_phylum.csv")
write.csv(phylum_readsAB_tax.df,"~/CAMDAjm/taxonomy_levels/readsAB/readsAB_taxDict_phylum.csv")


# Order -------------------------------------------------------------------
# conglomerate to order level
readsAB_glom_order <- tax_glom(readsArchaeaBacteria , taxrank = 'Order')
#View(reads_glom_order@otu_table@.Data)

# to data frame 
order_readsAB.df = as.data.frame(readsAB_glom_order@otu_table)
order_readsAB_tax.df = as.data.frame(readsAB_glom_order@tax_table)

# Quality
sum(sample_sums(readsAB_glom_order)) == sum(sample_sums(subset_taxa(readsArchaeaBacteria , Order != "")))

# Save data frames
write.csv(order_readsAB.df,"~/CAMDAjm/taxonomy_levels/readsAB/readsAB_count_order.csv")
write.csv(order_readsAB_tax.df,"~/CAMDAjm/taxonomy_levels/readsAB/readsAB_taxDict_order.csv")

# family -------------------------------------------------------------------
# conglomerate to family level
readsAB_glom_family <- tax_glom(readsArchaeaBacteria , taxrank = 'Family')
#View(readsAB__glom_family@otu_table@.Data)

# to data frame 
family_readsAB.df = as.data.frame(readsAB_glom_family@otu_table)
family_readsAB_tax.df = as.data.frame(readsAB_glom_family@tax_table)

# Quality
sum(sample_sums(readsAB_glom_family)) ==sum(sample_sums(subset_taxa(readsArchaeaBacteria , Family != "")))

# Save data frames
write.csv(family_readsAB.df,"~/CAMDAjm/taxonomy_levels/readsAB/readsAB_count_family.csv")
write.csv(family_readsAB_tax.df,"~/CAMDAjm/taxonomy_levels/readsAB/readsAB_taxDict_family.csv")

# genus -------------------------------------------------------------------
# conglomerate to genus level
readsAB_glom_genus <- tax_glom(readsArchaeaBacteria , taxrank = 'Genus')
#View(readsAB__glom_genus@otu_table@.Data)

# to data frame 
genus_readsAB.df = as.data.frame(readsAB_glom_genus@otu_table)
genus_readsAB_tax.df = as.data.frame(readsAB_glom_genus@tax_table)

# Quality
sum(sample_sums(readsAB_glom_genus)) == sum(sample_sums(subset_taxa(readsArchaeaBacteria , Genus != "")))

# Save data frames
write.csv(genus_readsAB.df,"readsAB_count_genus.csv")
write.csv(genus_readsAB_tax.df,"readsAB_taxDict_genus.csv")



###  Eukaryota ----------------------------------------------------
readsEukaryota = subset_taxa(reads_biom, Kingdom =="Eukaryota")

# Phylum  -----------------------------------------------------------------
# conglomerate to phylum level
readsE_glom_phylum <- tax_glom(readsEukaryota , taxrank = 'Phylum')
#View(readsE_glom_phylum@otu_table@.Data)

# to data frame 
phylum_readsE.df = as.data.frame(readsE_glom_phylum@otu_table)
phylum_readsE_tax.df = as.data.frame(readsE_glom_phylum@tax_table)

# Quality
# 
sum(sample_sums(readsE_glom_phylum))  == sum(sample_sums(subset_taxa(readsEukaryota , Phylum != "")))
# Save data frames
write.csv(phylum_readsE.df,"~/CAMDAjm/taxonomy_levels/readsE/readsE_count_phylum.csv")
write.csv(phylum_reads_taxAB.df,"~/CAMDAjm/taxonomy_levels/readsE/readsE_taxDict_phylum.csv")


# Order -------------------------------------------------------------------
# conglomerate to order level
readsE_glom_order <- tax_glom(readsEukaryota , taxrank = 'Order')
#View(reads_glom_order@otu_table@.Data)

# to data frame 
order_readsE.df = as.data.frame(readsE_glom_order@otu_table)
order_readsE_tax.df = as.data.frame(readsE_glom_order@tax_table)

# Quality
sum(sample_sums(readsE_glom_order)) == sum(sample_sums(subset_taxa(readsEukaryota , Order != "")))

# Save data frames
write.csv(order_readsE.df,"~/CAMDAjm/taxonomy_levels/readsE/readsE_count_order.csv")
write.csv(order_readsE_tax.df,"~/CAMDAjm/taxonomy_levels/readsE/readsE_taxDict_order.csv")

# family -------------------------------------------------------------------
# conglomerate to family level
readsE_glom_family <- tax_glom(readsEukaryota , taxrank = 'Family')
#View(readsE__glom_family@otu_table@.Data)

# to data frame 
family_readsE.df = as.data.frame(readsE_glom_family@otu_table)
family_readsE_tax.df = as.data.frame(readsE_glom_family@tax_table)

# Quality
sum(sample_sums(readsE_glom_family)) ==sum(sample_sums(subset_taxa(readsEukaryota , Family != "")))

# Save data frames
write.csv(family_readsE.df,"~/CAMDAjm/taxonomy_levels/readsE/readsE_count_family.csv")
write.csv(family_readsE_tax.df,"~/CAMDAjm/taxonomy_levels/readsE/readsE_taxDict_family.csv")

# genus -------------------------------------------------------------------
# conglomerate to genus level
readsE_glom_genus <- tax_glom(readsEukaryota , taxrank = 'Genus')
#View(readsE__glom_genus@otu_table@.Data)

# to data frame 
genus_readsE.df = as.data.frame(readsE_glom_genus@otu_table)
genus_readsE_tax.df = as.data.frame(readsE_glom_genus@tax_table)

# Quality
sum(sample_sums(readsE_glom_genus)) == sum(sample_sums(subset_taxa(readsEukaryota , Genus != "")))

# Save data frames
write.csv(genus_readsE.df,"~/CAMDAjm/taxonomy_levels/readsE/readsE_count_genus.csv")
write.csv(genus_readsE_tax.df,"~/CAMDAjm/taxonomy_levels/readsE/readsE_taxDict_genus.csv")




###  Viruses ----------------------------------------------------
readsViruses = subset_taxa(reads_biom, Kingdom =="Viruses")

# Phylum  -----------------------------------------------------------------
# conglomerate to phylum level
readsV_glom_phylum <- tax_glom(readsViruses , taxrank = 'Phylum')
#View(readsV_glom_phylum@otu_table@.Data)

# to data frame 
phylum_readsV.df = as.data.frame(readsV_glom_phylum@otu_table)
phylum_readsV_tax.df = as.data.frame(readsV_glom_phylum@tax_table)

# Quality
# 
sum(sample_sums(readsV_glom_phylum))  == sum(sample_sums(subset_taxa(readsViruses , Phylum != "")))
# Save data frames
write.csv(phylum_readsV.df,"~/CAMDAjm/taxonomy_levels/readsV/readsV_count_phylum.csv")
write.csv(phylum_reads_taxAB.df,"~/CAMDAjm/taxonomy_levels/readsV/readsV_taxDict_phylum.csv")


# Order -------------------------------------------------------------------
# conglomerate to order level
readsV_glom_order <- tax_glom(readsViruses , taxrank = 'Order')
#View(reads_glom_order@otu_table@.Data)

# to data frame 
order_readsV.df = as.data.frame(readsV_glom_order@otu_table)
order_readsV_tax.df = as.data.frame(readsV_glom_order@tax_table)

# Quality
sum(sample_sums(readsV_glom_order)) == sum(sample_sums(subset_taxa(readsViruses , Order != "")))

# Save data frames
write.csv(order_readsV.df,"~/CAMDAjm/taxonomy_levels/readsV/readsV_count_order.csv")
write.csv(order_readsV_tax.df,"~/CAMDAjm/taxonomy_levels/readsV/readsV_taxDict_order.csv")

# family -------------------------------------------------------------------
# conglomerate to family level
readsV_glom_family <- tax_glom(readsViruses , taxrank = 'Family')
#View(readsV__glom_family@otu_table@.Data)

# to data frame 
family_readsV.df = as.data.frame(readsV_glom_family@otu_table)
family_readsV_tax.df = as.data.frame(readsV_glom_family@tax_table)

# Quality
sum(sample_sums(readsV_glom_family)) ==sum(sample_sums(subset_taxa(readsViruses , Family != "")))

# Save data frames
write.csv(family_readsV.df,"~/CAMDAjm/taxonomy_levels/readsV/readsV_count_family.csv")
write.csv(family_readsV_tax.df,"~/CAMDAjm/taxonomy_levels/readsV/readsV_taxDict_family.csv")

# genus -------------------------------------------------------------------
# conglomerate to genus level
readsV_glom_genus <- tax_glom(readsViruses , taxrank = 'Genus')
#View(readsV__glom_genus@otu_table@.Data)

# to data frame 
genus_readsV.df = as.data.frame(readsV_glom_genus@otu_table)
genus_readsV_tax.df = as.data.frame(readsV_glom_genus@tax_table)

# Quality
sum(sample_sums(readsV_glom_genus)) == sum(sample_sums(subset_taxa(readsViruses , Genus != "")))

# Save data frames
write.csv(genus_readsV.df,"~/CAMDAjm/taxonomy_levels/readsV/readsV_count_genus.csv")
write.csv(genus_readsV_tax.df,"~/CAMDAjm/taxonomy_levels/readsV/readsV_taxDict_genus.csv")
