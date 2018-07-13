#!/bin/bash

# convert the samfiles to bam files 

for i in `ls *.sam` ; 
    do 
    samtools view -S -b $i > $i.bam;
    samtools index $i.bam;
    samtools sort $i.bam -o $i.sorted.bam;
done;

# takes bam file and quantifies the number of aligned reads to genomic locus
# script takes the bam file and quantifies the genome locus
# >25% covered ?
 
for i in `ls *.bam` ; 
    do 
    samtools view -F 260 $i | cut -f 3 | sort | uniq -c | awk '{printf("%s\t%s\n", $2, $1)}' > $i.counts.txt
done;

# merging files
#awk 'FNR==NR{a[$1]=$2 FS $3;next}{ print $0, a[$1]}' counts2.txt counts1.txt
# coverage estimation 