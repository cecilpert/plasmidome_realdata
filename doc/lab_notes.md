## 12/06/2018

* Nonpareil3 (-T alignement) avec seulement les reads paired-end nettoyés *RUNNING* 

`cat data/R1_trimmed_pe.fastq | paste - - - - | awk 'BEGIN{FS="\t"}{print ">"substr($1,2)"\n"$2}' > data/R1_trimmed_pe.fasta` -> transformer fastq en fasta 

* Lancement MetaSPAdes pour subsamples 40 à 90 *RUNNING*

* Téléchargements séquences chromosomiques (NCBI microbial genomes) *RUNNING* 

https://www.ncbi.nlm.nih.gov/genome/browse#!/prokaryotes/ (filters : assembly level = complete) 
https://www.ncbi.nlm.nih.gov/genome/browse#!/eukaryotes/ (filters : assembly level = complete) 

`tail -n +2 | grep "ftp"` -> suppression header, conserver uniquement les lignes avec lien ftp 

`split -n11 -d prokaryotes.nohead.ftp.csv prokaryotes.nohead.ftp.csv` -> split le fichier en 11, pour lancer les téléchargement les uns après les autres (et éviter de stocker 10k séquences en mémoire d'un coup) 
`run_download_chromosomes.sh` (utilise `download_contaminants_ncbi.py`) 
