#!/bin/bash

#set -x # for comments

Cancer_Type="AML"
Species_Type="Homo sapiens"

Query_String="$Cancer_Type[All Fields] AND \"$Species_Type\"[orgn] AND \"biomol rna\"[Properties]"


esearch -db sra -query "$Query_String"  \
	| efetch -format runinfo  \
	| grep -v '^$' \
	| grep -v '^Run' \
	| awk -F',' '{print $25}' \
	| paste -s -d"," > Sample_ID.txt
