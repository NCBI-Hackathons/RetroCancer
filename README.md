# RetroCancer

![retrocancer](retrologo.png)

# Introduction

## What are Endogenous retroviruses(ERVs)?
"Endogenous retroviruses (ERVs) are remnants of ancient active retroviruses that infected germline cells, and these viruses are transmitted vertically through successive generations in a Mendelian fashion. ERVs have undergone repeated amplification and transposition to such an extent that human endogenous retroviruses (HERVs), which integrated into the human genome 30–40 million years ago, currently make up about 8% of the human genome sequence" [ref1](https://retrovirology.biomedcentral.com/articles/10.1186/1742-4690-8-90)

## Why are these important ?
ERVs lack infectious capacity due to accumulated nonsense mutations,indels of internal coding regions & long terminal repeats (LTRs), which serve as the retroviral promoters. Despite changes HERVs have intact open reading frames (ORFs) that encode functional proteins and in some cases can form retrovirs like particles.[ref2](https://retrovirology.biomedcentral.com/articles/10.1186/1742-4690-8-90).HERvs along with beneficial roles, have also been associated with a variety of human diseases and disorders. However, no concrete beneficial or harmful effects have yet been establised.[ref3](https://www.nature.com/articles/srep41960)   

## What is retrocancer going to do ?

=======
1. Generation of HERV expression profiles for Cancer Patients
2. Precision Cancer-Therapy based on HERV expression profiles

## What is RetroCancer?
The human genome has about 8% Human Endogenous Retroviruses (HERVs) located within it. There have been reports of Human Endogenous Retroviral involvement in certain diseases. In this study, we are analyzing cancer datasets in order to investigate HERVs response to cancer. We therefore seek to measure Human Endogenous Retrovirus Response to Cancer. RetroCancer allows the user to profile HERV expression in cancer datasets. In this study, we are analyzing Melanoma and Acute Myeloid Leukemia (AML) datasets from public databases.

We are developing RetroCancer with the goal of quantifying HERV expression in Melanoma and AML patients, and also classifying these patients based on HERV expression profile and potential response to immunotherapy.

# RetroCancer Workflow
![Logo](workflow1.png)

![Logo](retrologo.tif)

# Methods

The core of our workflow is counting how many reads in a sample's
RNA-seq profile match sequences in the ERV database. Here, we describe
how we acquired our data and how we assess which reads are ERVs.

## HERV Reference Database

Our work incorporated two different HERV reference databases. The
first is the human component of endogenous viral elements from the
gEVE database, and the second is a hand-curated database of HERVs.

### Endogenous viral elements from gEVE
We used the 33,966 human EVEs (endogenous viral elements) from the
gEVE database version 1.1 (Nakagawa & Takahashi 2016). The
database includes gag, pro, pol and env sequences; most of the pol
sequences are LINEs. We downloaded the nucleotide sequences (file
Hsap38.geve.nt_v1.fa).

### Manually created HERV reference database

We started by searching RefSeq for “human endogenous retrovirus”
and manually selected a subset of the returned results. In
addition, 25 human endogenous retroviruses were pulled from a PLoS
ONE paper (EnHerv). We queried those 25 HERV gene names against
all NCBI sequence databases, and selected a subset that appear in
the Homo sapiens genome, such as LTR2C. For each gene, we obtained
a sequence from NCBI and sent it to a FASTA file. This resulted in
a database of 135 human HERV sequences. The sequences in the
database are listed in Table 1.

## RNA-seq data from cancer and control samples

### Melanoma and AML datasets from SRA

We selected melanoma and AML RNA-seq samples, as well as normal
controls, from SRA. [ADD DESCDRIPTION OF SAMPLE SELECTION HERE]




