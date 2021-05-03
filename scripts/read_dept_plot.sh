#!/bin/sh

tmp="./tmp"
mkdir "$tmp"
#file with reference sequence
ref=$1

#file with tumor samples 
tu1=$2
tu2=$3

#file with wild type samples
wt1=$4
wt2=$5

echo "INFO: create indexes:"
gzip -dk "$ref"
samtools faidx "${ref%.*}"
bwa index "${ref%.*}"

echo "INFO: map samples"
#gzip -dk "$tu1"
#gzip -dk "$tu2"
#gzip -dk "$wt1"
#gzip -dk "$wt2"
bwa mem "${ref%.*}" "$tu1" "$tu2" > "$tmp/amcg_tu.sam"
bwa mem "${ref%.*}" "$wt1" "$wt2" > "$tmp/amcg_wt.sam"

echo "INFO: convert sam to bam"
samtools view -S -b "$tmp/amcg_tu.sam" > "$tmp/amcg_tu.bam"
samtools view -S -b "$tmp/amcg_wt.sam" > "$tmp/amcg_wt.bam"

echo "INFO: sort samples"
samtools sort "$tmp/amcg_tu.bam" -o "$tmp/amcg_tu.sorted.bam"
samtools sort "$tmp/amcg_wt.bam" -o "$tmp/amcg_wt.sorted.bam"

echo "INFO: index samples"
samtools index "$tmp/amcg_tu.sorted.bam"
samtools index "$tmp/amcg_wt.sorted.bam"

echo "INFO: get samples read dept"
samtools depth "$tmp/amcg_tu.sorted.bam" > "$tmp/amcg_tu.sorted.bam.depth.txt"
samtools depth "$tmp/amcg_wt.sorted.bam" > "$tmp/amcg_wt.sorted.bam.depth.txt"

echo "INFO: plot read-depth"
pwd
Rscript ./scripts/amcg.R "$tmp/amcg_wt.sorted.bam.depth.txt" "$tmp/amcg_tu.sorted.bam.depth.txt"

