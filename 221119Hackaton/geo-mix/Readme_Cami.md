# Linaje taxonomico completo a partir de TaxID ó TaxID  apartir del ultimo linaje taxonomico usando:

## ete3 -> Libreria NCBITaxa

from ete3 import NCBITaxa
ncbi = NCBITaxa() 
ncbi.update_taxonomy_database()


ncbi.get_lineage(2562024) # obtener el linaje
ncbi.get_taxid_translator(lineage) # traducir el linaje
ncbi.get_name_translator(['Rhodoplanes']) # optener el TaxID
