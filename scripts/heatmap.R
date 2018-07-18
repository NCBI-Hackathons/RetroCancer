
###########################################
#  - Endogenous  Ritrovirus cancer   Project#
#  -Load data   main function           #
#  - Main function to be called           #
#  - 2018-07-11                            #
#  - Copyright: Mohamed Hamed             #
###########################################

#R programming environments:
# R version 3.4.1 (2017-06-30)
# Platform: x86_64-apple-darwin15.6.0 (64-bit)
# Running under: OS X El Capitan 10.11.6
# locale: en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

### define parameters
library("pheatmap")
library("Cairo")
library("DESeq2")
library(readr)

ensemble.map.path="data/hg38_ENSG_gEVE_best_match_final.txt"
group1.path="/Users/hamed/hackathon/work/data/melanoma/melanoma_anno.txt"
# group1.path="annotated_data.tsv"
group2.path="/Users/hamed/hackathon/work/data/melanoma/control_skin_anno.txt"
group1="Melanoma"
group2="Ctrl"
output.path="data/heatmap.pdf"
lfc.thr=1
pval.thr=0.05


group1.data <- read.delim(group1.path)
rownames=as.character(unlist(group1.data[,1]))
group1.data=group1.data[,grep("SRR",colnames(group1.data))]
rownames(group1.data)=rownames
# group1.data=group1.data+1
# group1.data=log2(group1.data)

# data=x
# m2=scale(t(data),center=T,scale=T)
# m2=t(m2)
# pheatmap(m2, cluster_rows=F, show_rownames=T,cluster_cols=T, fontsize_row = 8,fontsize_col = 10)


group2.data <- read.delim(group2.path)
rownames=as.character(unlist(group2.data[,1]))
group2.data=group2.data[,grep("SRR",colnames(group2.data))]
rownames(group2.data)=rownames
# group2.data=group2.data+1  # to overcome the log (0)
# group2.data=log2(group2.data)


common.ids=intersect( unique(rownames(group1.data)) , unique(rownames(group2.data))  )

group1.data=group1.data[rownames(group1.data) %in% common.ids, ]
group2.data=group2.data[rownames(group2.data) %in% common.ids, ]



data=cbind(group1.data,group2.data)
annotation= data.frame( Sample= c(rep(group1,dim(group1.data)[2]) , rep(group2,dim(group2.data)[2]) ))
phenotype=cbind( c( colnames(group1.data) , colnames(group2.data)) , annotation)
names(phenotype)=c("Sample","Case")


dds = DESeqDataSetFromMatrix( countData = data , colData = phenotype , design = ~ Case)
# dds = DESeqDataSetFromMatrix( countData = exp , colData = pheno , design = ~ Sample.Type)
dds.run = DESeq(dds)
res=results(dds.run, contrast = c("Case",group1,group2) )
plotMA(res, ylim=c(-1,1)) 
res=as.data.frame(res)
res=res[complete.cases(res), ]
summary(res)
res.degs=res[res$padj< pval.thr & abs(res$log2FoldChange)>lfc.thr,]
degs=rownames(res.degs)
data.degs=data[rownames(data) %in% degs,  ]


# Heatmap
annotaion=as.data.frame (phenotype$Case)
rownames(annotaion)=phenotype$Sample
names(annotaion)=c("Case")

m2=scale(t(data.degs),center=T,scale=T)
m2=t(m2)

pdf(encoding = "ISOLatin1", file=output.path,width=8,height=9)
pheatmap(m2, cluster_rows=F, show_rownames=T,cluster_cols=T, annotation=annotaion, fontsize_row = 8,fontsize_col = 10)
dev.off()
dev.new()

# map the DEGs to the corresponding ENSEMBLE IDs  @@@@  bY barb
herv_to_ens <- read.delim(ensemble.map.path,header = F)
names(herv_to_ens)=c("ens","herv")
ens.degs=as.character( herv_to_ens[herv_to_ens$herv %in% degs,]$ens)



# load the pCa cancer from the TCGA 
# ens.degs= rownames(mrna.exp)[177:277]
load("PCa.RDATA")

x=sapply(strsplit(rownames(mrna.exp), "\\."), "[", 1)

pca.degs=mrna.exp[which(x %in% ens.degs),]
pca.degs=pca.degs+1
pca.degs=log2(pca.degs)

#Heatmap
sample.ids=sample.sheet$Sample.ID
annotation= as.data.frame(sample.sheet$Sample.Type)
rownames(annotation)=sample.ids

m2=scale(t(pca.degs),center=T,scale=T)
m2=t(m2)

pdf(encoding = "ISOLatin1", file=output.path,width=8,height=9)
pheatmap(m2, cluster_rows=F, show_rownames=T,cluster_cols=T, annotation=annotation, fontsize_row = 7,fontsize_col = 2)
dev.off()
dev.new()













