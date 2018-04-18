set -e 

function usage(){
	echo 'usage : run_all_analysis.sh [options]    
	If no option are specified, all analysis will be conduct. 
	[options] : 
	--uncompress : uncompress fastq files 
	--fastqc : launch fastqc quality check  
	' 
}

all=1

TEMP=$(getopt -o h -l uncompress,fastqc -- "$@")
eval set -- "$TEMP" 

while true ; do 
	case "$1" in 
		--uncompress) 
			all=0
			uncompress=1 
			shift;; 
		--fastqc)
			all=0
			fastqc=1 
			shift ;; 		
		-h) 
			usage
			shift ;;
		--)  
			shift ; break ;; 
								
	esac 
done 	

lib1_r1=data/NG-14342_WWTP2_lib236998_5767_3_1.fastq
lib1_r2=data/NG-14342_WWTP2_lib236998_5767_3_2.fastq
lib2_r1=data/NG-14342_WWTP2_lib236998_5794_6_1.fastq
lib2_r2=data/NG-14342_WWTP2_lib236998_5794_6_2.fastq 

if [[ $all -eq 1 ]]; then 
	uncompress=1 
	fastqc=1 
fi 

if [[ $uncompress ]]; then 
	echo "-- UNCOMPRESS FASTQ --" 
	gunzip $lib1_r1
	gunzip $lib1_r2
	gunzip $lib2_r1
	gunzip $lib2_r2
fi

if [[ $fastqc ]]; then 
	echo "-- QUALITY CHECK WITH FASTQC --" 
fi 	


 
