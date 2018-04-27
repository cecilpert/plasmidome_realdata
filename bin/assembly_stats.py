import sys 
from Bio import SeqIO 

def usage(): 
	print("usage: python3 assembly_stats.py <input fasta file 1> <input fasta file 2> <...> <output tsv file> <comma separated list of assembly names")
	print("Calculate N50, largest contig and total assembly length from fasta file(s)")

def N50_calc(list_length): 
	half_sum=sum(list_length)/2 
	list_length.sort(reverse=True) 
	sum_i=0 
	for i in list_length: 
		sum_i+=i 	
		if half_sum <= sum_i : 
			return(i)   
				 									
						
if len(sys.argv)<3: 
	usage() 
	exit() 
	
assemblies=sys.argv[-1].split(",")
outfile=sys.argv[-2]
infiles=sys.argv[1:-2]

if len(assemblies) != len(infiles): 
	usage()
	print("#Error# You give "+str(len(infiles))+" contigs files and "+str(len(assemblies))+" assemblies name. It has to be equal.") 
	exit() 
	
out=open(outfile,"w") 
out.write("Assembly\tTotal length\tMax length\tN50\tTotal_length>1000bp\tN50>1000bp\n") 
	
for i in range(len(assemblies)): 
	assembly_length=0
	assembly_length1000=0
	max_length=0
	list_length=[]
	list_length_1000=[]
	for record in SeqIO.parse(infiles[i],"fasta"): 
		seq_len=len(record.seq) 
		if seq_len > max_length: 
			max_length=seq_len 
		if (seq_len >= 1000): 
			list_length_1000.append(seq_len) 	
			assembly_length1000+=seq_len
		assembly_length+=seq_len 	
		list_length.append(seq_len) 
	N50=N50_calc(list_length)	
	N50_1000=N50_calc(list_length_1000)
	out.write(assemblies[i]+"\t"+str(assembly_length)+"\t"+str(max_length)+"\t"+str(N50)+"\t"+str(assembly_length1000)+"\t"+str(N50_1000)+"\n") 		
				
		

		
	

	
	
		
