# The script for download and unpacking of interesting genomes from UCSC

for genome in dm6 #danRer7 danRer10 galGal4 hg19 hg38 dm3 dm6 ce10
do
	
	mkdir -p ../data/genomes/${genome,,}
	cd ../data/genomes/${genome,,}

	if [[ $genome == *"dan"* ]] || [[ $genome == *"hg38"* ]] || [[ $genome == *"gal"* ]] || [[ $genome == *"dm6"* ]]
	then
	  genome_file="ftp://hgdownload.soe.ucsc.edu/goldenPath/${genome}/bigZips/${genome}.fa.gz"
		wget $genome_file
		gzip -d ${genome}.fa.gz
	else
		genome_file="ftp://hgdownload.soe.ucsc.edu/goldenPath/${genome}/bigZips/chromFa.tar.gz"
		wget $genome_file
		tar -xzf chromFa.tar.gz
		rm chromFa.tar.gz
		cat chr*.fa > ${genome}.fa
		rm chr*.fa
	fi


	wget ftp://hgdownload.soe.ucsc.edu/goldenPath/${genome}/bigZips/${genome}.chrom.sizes
	#cp ~/GENOMES/${genome_upper}_FASTA/${genome}.fa ../data/genomes/${genome,,}/${genome,,}.fa
	
	mv ${genome}.fa > ${genome,,}.fa
	mv ${genome}.chrom.sizes > ${genome,,}.chrom.sizes

	cd ../../../wd/

done

# Downloading and parsing of Dicty genome
mkdir -p ../data/genomes/dicty
cd ../data/genomes/dicty
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/004/695/GCA_000004695.1_dicty_2.7/GCA_000004695.1_dicty_2.7_genomic.fna.gz
gzip -d GCA_000004695.1_dicty_2.7_genomic.fna.gz
sed -r "s/>.*chromosome ([[:digit:]]*).*$/>chr\1/g" GCA_000004695.1_dicty_2.7_genomic.fna | sed '/chrUn/q'| head -n -1 > dicty.fa
rm GCA_000004695.1_dicty_2.7_genomic.fna
python -c "l=''.join([x.strip() for x in open('dicty.fa', 'r').readlines()]).split('>')[1:]; l = [(x[:4]+'\t'+str(len(x[4:]))) for x in l]; print('\n'.join( l ) )" > dicty.chrom.sizes
