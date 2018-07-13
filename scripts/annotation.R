#!bin/env/R


#read final merged data 
all_counts<-read.delim("merged_counts.txt")
anno<-read.delim("/home/ubuntu/users/kishore/gEVE/Hsap38.txt")
colnames(anno)[1]<-"id"
annotated.data <- merge(all_counts, anno, by="id")
write.table(annotated.data,"annotated_data.txt",sep="\t")





#
#A function to read counts in a format
#read_sample <- function(sample.name) {
#        file.name <- paste(sample.name, sep="")
#        result <- read.delim(file.name, col.names=c("id", "counts"), sep="\t")
#}


