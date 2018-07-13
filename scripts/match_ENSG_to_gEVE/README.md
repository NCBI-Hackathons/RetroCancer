# Matching gEVE to Ensembl IDs

Our main approach is to directly align RNA-seq data to endogenous
retroviral sequences. However, we also wanted to look into the
possibility of assessing EVE expression from existing processed count
data using a transcriptome of Ensembl IDs, such as that available from
TCGA (via the GDC data portal).

We decided to assign to each EVE the expression data from the most
overlapping gene. For each gene overlapping more than one EVE, we only
attributed its expression to the EVE with the largest overlap. We
determined the genomic loci of the genes from Ensembl (version 38 of
the genome), and found the overlap using bedtools intersect.

Of course, this method has many caveats. It is very likely that the
expression of an overlapping gene is completely different from the
expression of the EVE. Thus, this is an approach to be used only for
preliminary investigations.

In this directory, we have the scripts to create the correspondence
between Ensembl gene IDs and the EVEs.

## Data Sources

The gEVE database was used to obtain all EVE loci. We downloaded the
sequences and annotation file for the Human dataset from
http://geve.med.u-tokai.ac.jp/download/. This file is
Hsap38.geve.v1.gtf. 

The Ensembl data was downloaded from the Ensembl Genes 92 database,
and the "Human genes (GRCh38.p12)" dataset. We chose the following
attributes:

- Gene stable ID
- Chromosome/scaffold name
- Gene start (bp)
- Gene end (bp)
- Strand
- Gene name
- Gene type

The resulting file was downloaded from Ensembl on July 13, 2018, in
tab-delimited text format. 

This file should be named biomart_hg38_ENSG_annotations.txt.

## Creation of BED files

BED files are tab delimited and have chromosome, start, end and
identifier in the first four columns. Script make_bed.sh creates the
BED files for the two annotation files.

## Overlap of BED files


