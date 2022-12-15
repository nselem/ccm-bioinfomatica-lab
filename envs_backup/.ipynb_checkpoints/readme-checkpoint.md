The enviroments from Betterlab are [file](/envs_backup/list_envs.txt)

- [ ] DeepBGC_Global
- [ ] GenomeMining_Global
- [ ] Pangenomics_Global
- [ ] Prokka_Global
- [ ] TDA
- [ ] agromicrobiomaPagina
- [ ] anvio-7.1
- [ ] bigscape
- [ ] corason
- [ ] ete3
- [ ] evomining-conda
- [ ] metagenomics
- [ ] ncbi-genome-download
- [ ] paginaInternet
- [ ] qiime2-2021.8
- [ ] quality_assembly_2022
- [ ] rnaseq
- [ ] spades3.11.1

The yml files of the environments were generated and stored in [ymls_files](https://github.com/nselem/ccm-bioinfomatica-lab/tree/main/envs_backup/ymls_files)

~~~
cat list_envs.txt | while read line
do
name=$(echo $line | cut -d" " -f1)
conda-env export -n $name > envs_backup/ymls_files/$name.yml
done 
~~~
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

Finally, to install the environmment on the Alnitak you need use the command `conda create --name myenv --file spec-file.txt`
- [ ] DeepBGC_Global
- [X] GenomeMining_Global
- [ ] Pangenomics_Global
- [ ] Prokka_Global
- [X] TDA
- [ ] agromicrobiomaPagina
- [ ] anvio-7.1
- [ ] bigscape
- [ ] corason
- [ ] ete3
- [ ] evomining-conda
- [X] metagenomics
- [X] ncbi-genome-download
- [ ] paginaInternet
- [ ] qiime2-2021.8
- [ ] quality_assembly_2022
- [ ] rnaseq
- [ ] spades3.11.1