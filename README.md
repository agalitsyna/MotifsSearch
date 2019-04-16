### Motif search with autosome.ru software

This is in-lab tools for motif search in a set of genomes.
We use tools from [http://autosome.ru/](http://autosome.ru) : 

* APE for motif threshold calculation 
* SARUS for motif search
* CHIPMUNK for motif _de novo_ search.

Current implementation works on Linux machines (and on MacOS with some exceptions).

#### Pipeline outline

0. Setup the environment:

```bash
conda create --name motifs-search 
conda activate motifs-search
conda install -c conda-forge ruby
conda install -c cyclus java-jdk
```

Keep your environment up-to-date with environment.txt.

1. Download autosome software:

```bash 00_download_autosome_software.sh```

2. Download genomes. Currently we support _Danio rerio_ (danRer7, danRer10), _Gallus gallus_ (galGal4), _Homo sapiens_ (hg19, hg38), _Drosophila melanogaster_ (dm3, dm6), _Caenorhabditis elegans_ (ce10) and _Dictyostelium discoideum_ (dicty) genomes. You can vary the genomes for download in the script.

```bash 00_download_genomes.sh```

3. Calculate background nucleotides and di-nucleotide content for genomes. 
For this step we use ruby script provided by autosome.ru supporters.

```bash 01_calculate_backgrounds.sh```

4. Search given motifs in the downloaded genomes. Calculate thresholds for motifs from scores, straingtforward way in bash: 

```bash 02_run.sh``` 

Python script:

```python 02_hit_motif.py --genome dm3 --background 0.29,0.21,0.21,0.29 --folderMotifs ../data/motifs/pfm/ --folderThresholds ../data/motifs_thresholds/dm3/autosome/pwm/``` 

4. Search _de novo_ motifs with [ChIPMunk](http://autosome.ru/ChIPMunk/userguide.pdf). For that, first you need to install bedtools:

```conda install -c bioconda bedtools```

Bash script will run for all .bed files given in the folder data/peaks/dicty:

```bash 03_motif_search.sh```
