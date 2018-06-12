## 12/06/2018

* Nonpareil3 (-T alignement) avec seulement les reads paired-end nettoyés RUNNING 
`cat data/R1_trimmed_pe.fastq | paste - - - - | awk 'BEGIN{FS="\t"}{print ">"substr($1,2)"\n"$2}' > data/R1_trimmed_pe.fasta` -> transformer fastq en fasta 

* Lancement MetaSPAdes pour subsamples 40 à 90 RUNNING
