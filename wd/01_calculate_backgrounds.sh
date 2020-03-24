mkdir -p ../data/background/
for genome in danrer10 #danrer7 danrer10 galgal4 hg19 hg38 dm3 dm6 ce10 dicty
do
	ruby count_kmers.rb ../data/genomes/${genome}/${genome}.fa 2 > ../data/background/${genome}_bg_2.txt &
	ruby count_kmers.rb ../data/genomes/${genome}/${genome}.fa 1 > ../data/background/${genome}_bg_1.txt &
done
wait
