function usage(){
	echo 'usage : subsample_fastq.sh <R1 fastq file> <R2 fastq file> <prefix outfile (with path)> <percent>'       
}

if [[ $# -ne 4 ]]; then 
	usage 
	exit 1 
fi 

r1=$1
r2=$2
out=$3
pr=$4

nb_lines=`wc -l $r1 | cut -f 1 -d " "`
echo $nb_lines
nb_reads=$(( $nb_lines / 4))  
echo $nb_reads
echo "SUBSAMPLE" $pr 
number_subsample=$(( $nb_reads * $pr / 100)) 
seed=$RANDOM
~/seqtk/seqtk sample -s$seed $r1 $number_subsample > $out\_R1.sub$pr.fastq
~/seqtk/seqtk sample -s$seed $r2 $number_subsample > $out\_R2.sub$pr.fastq

