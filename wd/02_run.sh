# python -c "from Bio import motifs; f=open('jaspar/jaspar2018_core/MA0139.1.jaspar', 'r'); m = motifs.read(f, 'jaspar'); f.close(); print(m.format('pfm'))" > pfm/jaspar2018_core/MA0139.1.pfm
# wget http://opera.autosome.ru/downloads/all_collections_pack.tar.gz
# requires java1.6 or java 1.8, not java1.7; activate tmp environment to run

# Calculate background thresholds and scores for the motif:
# http://opera.autosome.ru/downloads/MACRO-PERFECTOS-APE_manual.pdf

java -cp ape.jar ru.autosome.ape.PrecalculateThresholds ../data/motifs/autosome/pwm/hocomoco_11_human/ ../data/motifs_thresholds/autosome/pwm/hocomoco_11_human/ --pvalues 1e-7,0.15,1.05,mul

# Run alignment: 
# https://github.com/VorontsovIE/sarus
java -cp sarus.jar ru.autosome.SARUS ~/GENOMES/HG19_FASTA/hg19.fasta ../data/motifs/autosome/pwm/hocomoco_11_human/CTCF_HUMAN.H11MO.0.A.pwm 0.0001 --pvalues-file ../data/motifs_thresholds/autosome/pwm/hocomoco_11_human/CTCF_HUMAN.H11MO.0.A.thr --threshold-mode pvalue --output-bed > ../data/hits/hg19_hocomoco11CTCFhuman_H11MO_1e4.bed

# for jaspar converted matrix
java -cp ape.jar ru.autosome.ape.PrecalculateThresholds ../data/motifs/pfm/jaspar2018_core/MA0531.1.pfm ../data/motifs_thresholds/ --single-motif --transpose --pvalues 1e-7,0.15,1.05,mul
java -cp sarus.jar ru.autosome.SARUS ~/GENOMES/HG19_FASTA/hg19.fasta ../data/motifs/pfm/jaspar2018_core/MA0531.1.pfm 0.0001 --transpose --pvalues-file ../data/motifs_thresholds/MA0531.1.thr --threshold-mode pvalue --output-bed > ../data/hits/hg19_jasparCTCF_MA0531_1e4.bed

for genome in hg19 hg38 mm9 danRer7 danrer10 dicty dm3 dm6 galGal4
do
	
	genome_upper=${genome^^}
	
	java -cp sarus.jar ru.autosome.SARUS ~/GENOMES/${genome_upper}_FASTA/${genome}.fa ../data/motifs/autosome/pwm/hocomoco_11_human/CTCF_HUMAN.H11MO.0.A.pwm 0.0001 --pvalues-file ../data/motifs_thresholds/autosome/pwm/hocomoco_11_human/CTCF_HUMAN.H11MO.0.A.thr --threshold-mode pvalue --output-bed > ../data/hits/${genome}_hocomoco11CTCFhuman_H11MO_1e4.bed

	java -cp sarus.jar ru.autosome.SARUS ~/GENOMES/${genome_upper}_FASTA/${genome}.fa ../data/motifs/pfm/jaspar2018_core/MA0531.1.pfm 0.0001 --pvalues-file ../data/motifs_thresholds/MA0531.1.thr --threshold-mode pvalue --output-bed --transpose > ../data/hits/${genome}_jasparCTCFdros_MA0531_1e4.bed

done
