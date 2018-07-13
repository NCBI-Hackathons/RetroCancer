## First, skip the header row.
tail -n +2 biomart_hg38_ENSG_annotations.txt | awk 'BEGIN { OFS="\t" }
 { print $4, $2, $3, $1, 0, $5 }' > hg38_ENSG_loci.bed

## 
awk 'BEGIN { OFS="\t" }
 { print $1, $4, $5, $10, 0, $7 }' Hsap38.geve.v1.gtf > hg38_gEVE_loci.bed


