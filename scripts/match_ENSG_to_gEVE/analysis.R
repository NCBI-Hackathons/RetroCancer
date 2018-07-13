## retain only the EVEs and genes that have greatest overlap

library(data.table)
filename <- "hg38_ENSG_gEVE_intersection.bed"
x <- fread(filename, sep="\t")
cat("Dimension of x: \n");
print(dim(x));
print(head(x));

## Now we want to pick the best gene for each EVE.

names(x) <- c("chromG", "startG", "endG", "ENSGID", "ignore", "ignore3",
              "chromEVE", "startEVE", "endEVE", "EVEID", "ignore2", "strand", "olen")

x[,MO:=max(olen),by=EVEID]
y <- x[olen==MO]
y[,MO2:=max(olen),by=ENSGID]
z <- y[olen==MO2]
write.table(z, file="hg38_ENSG_gEVE_best_match.txt", sep="\t", quote=FALSE)
