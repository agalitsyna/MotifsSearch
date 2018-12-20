### Motif search with autosome.ru software

This is in-lab tools for motif search in a set of genomes.
We use tools from [http://autosome.ru/](http://autosome.ru/): APE for motif threshold calculation, SARUS for motif search and CHIPMUNK for motif _de novo_ search.
Current implementation works on Linux machines (and on MacOS with some exceptions).

#### Pipeline outline

0. Setup the environment:

```bash
conda create --name motifs-search 
conda activate motifs-search
conda install -c conda-forge ruby
conda install -c cyclus java-jdk
```

1. Download autosome software:

```bash 00\_download\_autosome\_software.sh```

2. Download genomes:

```bash 00\_download\_genomes.sh```

3. Calculate background nucleotides and di-nucleotide content for genomes:

```bash 01\_calculate\_backgrounds.sh```

4. 
02_run.sh
ape.jar
chipmunk.jar
count_kmers.rb
environment.txt
sarus.jar

