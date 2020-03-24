mkdir -p ../data/motifs_thresholds/autosome/pwm/hocomoco_11_human/
mkdir ../data/hits/

#### Example run for HOCOMOCO database


# Calculate thresholds for all given motifs in the database (should be in raw pfm format, rows are genomic positions, columns are nucleotides A-C-G-T):
java -cp ape.jar ru.autosome.ape.PrecalculateThresholds ../data/motifs/autosome/pwm/hocomoco_11_human/ ../data/motifs_thresholds/autosome/pwm/hocomoco_11_human/ --pvalues 1e-7,0.15,1.05,mul

# Run alignment for a single motif of interest:
motif_file="../data/motifs/autosome/pwm/hocomoco_11_human/CTCF_HUMAN.H11MO.0.A.pwm"
motif_name="hocomoco11CTCFhuman_H11MO"
pvalues_file="../data/motifs_thresholds/autosome/pwm/hocomoco_11_human/CTCF_HUMAN.H11MO.0.A.thr"
genome_file="../data/genomes/danrer10/danrer10.fa"
genome_name="danrer10"
#java -cp sarus.jar ru.autosome.SARUS ../data/genomes/danrer10/danrer10.fa ../data/motifs/autosome/pwm/hocomoco_11_human/CTCF_HUMAN.H11MO.0.A.pwm 0.0001 --pvalues-file ../data/motifs_thresholds/autosome/pwm/hocomoco_11_human/CTCF_HUMAN.H11MO.0.A.thr --threshold-mode pvalue > ../data/hits/danrer10_hocomoco11CTCFhuman_H11MO_1e4.txt
java -cp sarus.jar ru.autosome.SARUS $genome_file $motif_file 0.0001 --pvalues-file $pvalues_file --threshold-mode pvalue > ../data/hits/${genome_name}_${motif_name}_1e-4.txt
awk -v l="$( grep -v ">" $motif_file | wc -l )" '{if ($1 ~ /^>/) {ch=substr($0,2)} else {print ch, $2, $2+l, ".", $1, $3}}' ../data/hits/${genome_name}_${motif_name}_1e-4.txt > ../data/hits/${genome_name}_${motif_name}_1e-4.bed


## for jaspar converted matrix
#java -cp ape.jar ru.autosome.ape.PrecalculateThresholds ../data/motifs/pfm/jaspar2018_core/MA0531.1.pfm ../data/motifs_thresholds/ --single-motif --transpose --pvalues 1e-7,0.15,1.05,mul
#java -cp sarus.jar ru.autosome.SARUS ~/GENOMES/HG19_FASTA/hg19.fasta ../data/motifs/pfm/jaspar2018_core/MA0531.1.pfm 0.0001 --transpose --pvalues-file ../data/motifs_thresholds/MA0531.1.thr --threshold-mode pvalue --output-bed > ../data/hits/hg19_jasparCTCF_MA0531_1e4.bed
#
#for genome in hg19 hg38 mm9 danRer7 danrer10 dicty dm3 dm6 galGal4
#do
#	
#	genome_upper=${genome^^}
#	
#	java -cp sarus.jar ru.autosome.SARUS ~/GENOMES/${genome_upper}_FASTA/${genome}.fa ../data/motifs/autosome/pwm/hocomoco_11_human/CTCF_HUMAN.H11MO.0.A.pwm 0.0001 --pvalues-file ../data/motifs_thresholds/autosome/pwm/hocomoco_11_human/CTCF_HUMAN.H11MO.0.A.thr --threshold-mode pvalue --output-bed > ../data/hits/${genome}_hocomoco11CTCFhuman_H11MO_1e4.bed
#
#	java -cp sarus.jar ru.autosome.SARUS ~/GENOMES/${genome_upper}_FASTA/${genome}.fa ../data/motifs/pfm/jaspar2018_core/MA0531.1.pfm 0.0001 --pvalues-file ../data/motifs_thresholds/MA0531.1.thr --threshold-mode pvalue --output-bed --transpose > ../data/hits/${genome}_jasparCTCFdros_MA0531_1e4.bed
#
#done
