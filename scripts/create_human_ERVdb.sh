#!/bin/bash


#after downloading the fasta file subset for human 
awk '/^>Hsap38/{print;getline;print;}' geve.aa_v1.1.fa >human_gEVE.fasta

