The enviroments from Betterlab are [file](/envs_backup/list_envs.txt)

- base
- DeepBGC_Global  
[ ] anvio-7.1 
[ ] Pangenomics_Global  
[ ] Prokka_Global  
- TDA
- agromicrobiomaPagina  
[ ] GenomeMining_Global  
[ ] bigscape  
[ ] corason  
- ete3
- evomining-conda
- metagenomics
- ncbi-genome-download
- paginaInternet
- qiime2-2021.8
- quality_assembly_2022
- rnaseq
- spades3.11.1

1. Use Conda export
First export environment configuration of your current conda environment using `conda-env  export -n your_env_name > your_env_name.yml`. The yml files of the environments were generated and stored in [ymls_files](https://github.com/nselem/ccm-bioinfomatica-lab/tree/main/envs_backup/ymls_files)

~~~
cat list_envs.txt | while read line
do
name=$(echo $line | cut -d" " -f1)
conda-env export -n $name > envs_backup/ymls_files/$name.yml
done 
~~~
2. Use Conda List
You can use explicit specification files to build an identical conda environment on the same operating system platform, either on the same machine or on a different machine, with this commant `conda list --explicit > ` the files were generated and stored in [spec_files](https://github.com/nselem/ccm-bioinfomatica-lab/tree/main/envs_backup/spec_files)

~~~
cat list_envs.txt | while read line
do
name=$(echo $line | cut -d" " -f1)
conda activate $name
conda list --explicit > envs_backup/spec_files/spec-$name.txt
conda deactivate
done 
~~~

Finally, to install the environmment on the Alnitak you need use the command `conda create --name myenv --file spec-file.txt`. For example to create the **ncbi-genome-download** you need use `conda create --prefix /miniconda3/envs/ncbi-genome-download --file spec-ncbi-genome-download.txt` .

The environments installed in Alnitak with this form are the following

- [ ] DeepBGC_Global (eliminado)
- [X] GenomeMining_Global (shaday)
- [X] Pangenomics_Global (haydee)
- [X] Prokka_Global    (Andres)
- [X] TDA (Paco)
- [ ] agromicrobiomaPagina (Eliminado)
- [ ] anvio-7.1 (eliminado)
- [X] bigscape    (nelly)
- [X] corason     (nelly)
- [X] ete3       (Camila)
- [X] evomining-conda (Cesar )
- [X] metagenomics (listo probado kraken haydee)
- [X] ncbi-genome-download (anton)
- [X] paginaInternet (Fonty)
- [X] qiime2-2021.8    (Karina)
- [X] quality_assembly_2022  (eliminado)
- [X] rnaseq (abraham)
- [ ] spades3.11.1 (eliminado)
