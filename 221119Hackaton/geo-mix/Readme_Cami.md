# Linaje taxonomico completo a partir de TaxID ó TaxID  apartir del ultimo linaje taxonomico usando ETE3

Se importa la libreria en python 
`from ete3 import NCBITaxa`
Se carga por primera vez la base de datos de NCBI de linajes taxonomicos
`ncbi = NCBITaxa()`
si se quiere actualizar la base de datos cargada, se usa la siguiente linea.
`ncbi.update_taxonomy_database()`

Si se tiene el TaxID y se quiere ver el linaje taxonomico completo se puede usar `ncbi.get_lineage(2562024)` con lo que se obtieen el linaje completo con sus TaxID `[1, 131567, 2759, 33154, 33208, 6072, 33213, 33317, 1206794, 88770, 6656, 197563, 197562, 6960, 50557, 85512, 7496, 33340, 33392, 85604, 7088, 41191, 41196, 41197, 37567, 37582, 33464, 397427, 2562024]` y para obtener los nombres de este linaje completo se puede usar `ncbi.get_taxid_translator(lineage)`que hace una traduccion  de los TaxID's a sus respectivos nombres `['root', 'cellular organisms', 'Eukaryota', 'Opisthokonta', 'Metazoa', 'Eumetazoa', 'Bilateria', 'Protostomia', 'Ecdysozoa', 'Panarthropoda', 'Arthropoda', 'Mandibulata', 'Pancrustacea', 'Hexapoda', 'Insecta', 'Dicondylia', 'Pterygota', 'Neoptera', 'Endopterygota', 'Amphiesmenoptera', 'Lepidoptera', 'Glossata', 'Neolepidoptera', 'Heteroneura', 'Ditrysia', 'Yponomeutoidea', 'Yponomeutidae', 'Yponomeutinae', 'Paradoxus']`

Luego, si se tienen los nombre de algun linaje taxonomico, se puede llegar a su TaxID, se puede usar `ncbi.get_name_translator(['Rhodoplanes'])` obteniendo `{'Rhodoplanes': [29407]}`.
