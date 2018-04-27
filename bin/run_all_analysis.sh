set -e 

function usage(){
	echo 'usage : run_all_analysis.sh -1 list of R1 fastq files (separate by ,) -2 list of R2 fastq files (separate by ,) [options]    
	If no option are specified, all analysis will be conduct. 
	[options] : 
	-o : output directory (default : results) 
	--uncompress : uncompress fastq files 
	--fastqc : launch fastqc quality check  
	--trimming : launch reads correction with trimmomatic
	--rarefaction : launch subsamples from fastq reads and assemblies 
	--assembly : launch megahit assembly 
	--assembly_metaspades : launch metaspades assembly 
	--subsample percent : launch subsampling with percent of reads (others steps like trimming or assembly will be launch with the new subsample) 
	' 
}

function concatenate_pe(){ 
	cat $r1 > $tmp_dir/all_r1.fastq
	cat $r2 > $tmp_dir/all_r2.fastq
}	

all=1
outdir=results

TEMP=$(getopt -o h,1:,2:,o: -l uncompress,fastqc,trimming,assembly,assembly_metaspades,subsample: -- "$@")
eval set -- "$TEMP" 

while true ; do 
	case "$1" in 
		--fastqc)
			all=0
			fastqc=1 
			shift ;; 
		--trimming)
			all=0
			trimming=1
			shift;; 	
		--assembly) 
			all=0
			assembly=1 
			shift ;; 
		--assembly_metaspades)
			all=0
			assembly_metaspades=1
			shift ;; 
		--subsample)
			all=0
			subsample=$2
			shift 2;; 
		-h) 
			usage
			exit 
			shift ;;
		-1) 
			r1=$(echo $2 | tr "," " ") 
			shift 2;;
		-2) 
			r2=$(echo $2 | tr "," " ") 
			shift 2;;	
		-o) 
			outdir=$2
			shift 2;; 
		--)  
			shift ; break ;; 
								
	esac 
done 	


if [[ ! $r1 ]] || [[ ! $r2 ]]; then 
	usage 
	echo "give R1 and R1 fastq files, with -1 and -2 arguments" 
	exit
fi 	

mkdir -p $outdir 
tmp_dir=`mktemp -d -p .`

if [[ $all -eq 1 ]]; then 
	uncompress=1 
	fastqc=1 
fi 

if [[ $subsample ]]; then 
	bash bin/subsample_fastq.sh $r1 $r2 $tmp_dir/subsample $subsample

	
fi 

if [[ $fastqc ]]; then
	mkdir -p $outdir/fastqc
	echo "-- QUALITY CHECK WITH FASTQC --" 
	fastqc -o $outdir/fastqc -f fastq $r1 $r2
fi 	

if [[ $trimming ]]; then 
	echo "-- READS CLEANING WITH TRIMMOMATIC --"  
	java -jar /usr/local/Trimmomatic-0.33/trimmomatic-0.33.jar PE -threads 6 -phred33 $r1 $r2 $tmp_dir/R1_trimmed_pe.fastq $tmp_dir/R1_trimmed_se.fastq $tmp_dir/R2_trimmed_pe.fastq $tmp_dir/R2_trimmed_se.fastq LEADING:28 TRAILING:28 SLIDINGWINDOW:4:15 MINLEN:30
	cat $tmp_dir/R1_trimmed_se.fastq $tmp_dir/R2_trimmed_se.fastq > $tmp_dir/R1R2_trimmed_se.fastq
	rm $tmp_dir/R1_trimmed_se.fastq $tmp_dir/R2_trimmed_se.fastq 
fi 	

if [[ $assembly ]]; then 
	if [[ ! -f $tmp_dir/R1_trimmed_pe.fastq ]]; then 
		usage
		echo "No trimmed files found, launch with --trimming option"  
		exit 
	fi 	
	megahit -1 $tmp_dir/R1_trimmed_pe.fastq -2 $tmp_dir/R2_trimmed_pe.fastq -r $tmp_dir/R1R2_trimmed_se.fastq -o $outdir/megahit 
	rm -r $outdir/megahit/intermediate_contigs 
fi 

if [[ $assembly_metaspades ]]; then 
	if [[ ! -f $tmp_dir/R1_trimmed_pe.fastq ]]; then 
		usage
		echo "No trimmed files found, launch with --trimming option"  
		exit 
	fi 
	/usr/local/SPAdes-3.9.0-Linux/bin/spades.py -1 $tmp_dir/R1_trimmed_pe.fastq -2 $tmp_dir/R2_trimmed_pe.fastq -s $tmp_dir/R1R2_trimmed_se.fastq -t 6 --meta -o $outdir/metaspades
	rm -r $outdir/metaspades/corrected $outdir/metaspades/K21 $outdir/metaspades/K55 $outdir/metaspades/K33 $outdir/metaspades/misc $outdir/metaspades/tmp 
	 
	
fi 
	
rm -r $tmp_dir 




 
