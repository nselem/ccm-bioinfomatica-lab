We discovered that from the 505 AMR Ids markers from the misterious file only 180 were predicted using CARD v.XX over the assembled reads from US cities.  To comprehend the missing 325 markers we gathered our own [manually curated AMR gene list](https://docs.google.com/spreadsheets/d/1ThsVn6QuIEPvFqe_SwG1PawEghqHgQdvNgGiZd40jXY/edit?usp=sharing)
 by searching the IDs in the following databases 
- [microbigg-e](https://www.ncbi.nlm.nih.gov/pathogens/microbigge/#)  
- [CARD](https://card.mcmaster.ca/)    
- [bv-brc](https://www.bv-brc.org/view/SpecialtyGeneList/)    
- [pathogenes-refgene](https://www.ncbi.nlm.nih.gov/pathogens/refgene/)   
- [NCBI-gene](https://www.ncbi.nlm.nih.gov/gene)  

 
![image](https://github.com/nselem/ccm-bioinfomatica-lab/assets/6643162/6ec6a199-f44a-47d1-b55d-0367b4b4c90b)  
Figure 1 Manually curated AMR database, 180 CARD genes, 325 other databases    
  
![image](https://github.com/nselem/ccm-bioinfomatica-lab/assets/6643162/5bd9afaa-f3d5-4fd7-abf5-d1b21d033101)  
Figure 2. Workflow to produce AMR sample profiles.    

![image](https://github.com/nselem/ccm-bioinfomatica-lab/assets/6643162/c274d9eb-20e5-42a2-8fc5-8b5434486504)  
Figure 3 Example of sample-profile    


Table1 Ids that maybe SNPs  
| Gen1  | Function   | Organism   | Gen2   | Function2   | Organims2 |  
|---|---|---|---|---|---|  
| chuX  |   |   |shuX  |   |   |  
| chuY |   |    |shuY   |   |   |  
| chuZ  |   |   |shuZ   |   |   |  
| fliG  |   |   |fliI  |   |   |  
| iucA |   |    |iucC   |   |   |  
| papB  |   |   |sfaB   |   |   | 
| papI  |   |   |sfaC  |   |   |  
| rmpA |   |    |rmpA2   |   |   |  
| sfaD  |   |   |SfaG   |   |   |   
  
Ids that maybe variants  
| Gen1  | Function   | Organism   | Gen2   | Function2   | Organims2 |  
|---|---|---|---|---|---|  
| oxqA[3,6,8,10,11]  |   |   |oxqA  |   |   |  
| oxqB[5,9,14,19,20,22,24,25,32]  |   |   |oxqA  |   |   |   

Table 3 Ids that were not found  
| Gen  | Orgnism   | Problem   |   
|---|---|---|  
|papg-iii	|escherichia coli|		INVESTIGAR DIFERENCIA III vs II|  
|ec-148|	escherichia coli |NOT FOUND|  
|fimk	|klebsiella pneumoniae	|	NOT FOUND|  
|oqxr	|enterobacter hormaechei		|NOT FOUND|  
|shvl-64	|klebsiella pneumoniae	|	not found|  
|svhl-71	|klebsiella pneumoniae	|	NOT FOUND|  
|tcpc_group-2	|escherichia coli	|	NOT FOUND|  
|teml-100	|klebsiella pneumoniae|		NOT FOUND|  
|tle1|	klebsiella pneumoniae|		NOT FOUND|  
|vactox|	escherichia coli	|	NOT FOUND|  
|wcly	klebsiella |pneumoniae		NOT FOUND|  
|wcst	klebsiella |pneumoniae		NOT FOUND|  
