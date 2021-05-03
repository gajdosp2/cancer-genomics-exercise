# Cancer Genomics Data Analysis Exercise

----------

1. download human genome rference sequence: \
`curl "http://ftp.ensembl.org/pub/current_fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.X.fa.gz" --output Homo_sapiens.GRCh38.dna.chromosome.X.fa.gz`
`./scripts/read_dept_plot.sh Homo_sapiens.GRCh38.dna.chromosome.X.fa.gz tu.r1.fq.gz tu.r2.fq.gz wt.r1.fq.gz wt.r2.fq.gz `
2. download samples
3. run script\
`scripts/read_dept_plot.sh <ref sequence> <tumor reads 1> <tumor reads 2> <wild reads 1> <wild reads 2>`
## scripts/read_dept_plot.sh:
1. create index for reference sequence\
`samtools faidx`
2. create bwa index for reference sequence\
`bwa index`
3. map tumor samples and wild type samples to reference sequence\
`bwa mem`
4. convert sam files to bam files\
`samtools view -S -b`
5. sort bam files\
`samtools sort`
6. index bam msorted files\
`samtools index`
7. generate read-dept statistics of mapped samples\
`samtools depth`
8. run R script to plot read-dept plot\
`Rscript ./amcr.R`
