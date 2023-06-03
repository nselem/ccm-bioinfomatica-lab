# Variance reduction
Our goal is to reduce zeros in Zero inflated data and evaluate if this modeling impacts in the forensic challenge of city prediction. 
First we are subseting the total OTU table into the following tables.

- Archaea and Bacteria Phylum    
- Archaea and Bacteria Class    
- Archaea and Bacteria Order   
- Archaea and Bacteria Family   
- Archaea and Bacteria Genus  

- Eukarya Phylum  
- Eukarya Class   
- Eukarya Order  
- Eukarya Family   
- Eukarya Genus  

- Virus Phylum   
- Virus Class   
- Virus Order   
- Virus Family   
- Virus Genus  

- All Kingdoms Phylum   
- All Kingdoms Class   
- All Kingdoms Order   
- All Kingdoms Family   
- All Kingdoms Genus  

## 2023 06 03  
We glomed two OTU tables:reads-OTU table and one for assemblies into several tables by taxonomic agglomeration.  
We model the distribution of zero's in the all kingdoms-phylum table.  
We run machine learning models (Victor's code) in the original reads-OTU table. 
