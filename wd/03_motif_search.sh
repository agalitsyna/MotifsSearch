# As input we have ChIP-Seq/ATAC-Seq/DNAse-Seq peaks in BED format and FASTQ genome file of species of interest. 
# As output we will have:
# 1. FASTA file with genomic sequences of peaks,
# 2. MOTIF found by ChIPMunk software.
# We also would like to make a correction for GC-content for the species of interest. 

FASTA="../data/genomes/dicty/dicty.fa"
for bed_file in ../data/peaks/dicty/*[^d].bed
do
  file_prefix="${bed_file%.*}" # Prefix of the file (no file extension)
  echo $file_prefix, $bed_file
	# Converting bed file to the file with scores as names (in 4th column)
  awk -v OFS='\t' '{print $1, $2, $3, $5}' ${file_prefix}.bed > ${file_prefix}.renamed.bed

	# Converting bed to fasta
	bedtools getfasta -fi $FASTA -name -bed ${file_prefix}.renamed.bed -fo ${file_prefix}.fasta

	# Running ChIPMunk for motifs from 5 to 40 letters in length, 100 iterations with step 1, 16 threads. GC content is set for Dicty (0.224)
	# Zero or 1 hits per sequence with score 1
  java -cp chipmunk.jar ru.autosome.ChIPMunk 5 40 yes 1.0 w:${file_prefix}.fasta 100 10 1 16 random 0.224 1>${file_prefix}.chipmunk_15-40_zops1.result 2>>${file_prefix}.log
	# Zero or 1 hits per sequence with score 0
  java -cp chipmunk.jar ru.autosome.ChIPMunk 5 40 yes 0.0 w:${file_prefix}.fasta 100 10 1 16 random 0.224 1>${file_prefix}.chipmunk_15-40_zops0.result 2>>${file_prefix}.log
done
