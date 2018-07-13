library(tools)

setwd("~/RetroCancer/final_data/aml")
filenames <- Sys.glob("*.counts.txt")


# Extract the first value of the filename before the period
PrettifyFilename <- function(x) {
  ret <- strsplit(x, split=".", fixed=TRUE)[[1]][[1]]
  ret
}

names(filenames) <- lapply(filenames, PrettifyFilename) 

# Read in all the data from the filenames
filename_data <- lapply(filenames, read.table, header=FALSE, stringsAsFactors=FALSE)


# Read in counts data by only looking at certain columns
count_data <- lapply(filename_data, function(x) x[, c("id", "samplename")])
# Rename the second column of the count data to be the Pretty filename
count_data_modified <- lapply(names(filename_data), function(z) {
  colnames(filename_data[[z]])[2] <- z
  filename_data[[z]]
})

all_count_data <- Reduce(function(x, y) merge(x, y, by="id"), count_data_modified)

write.table(all_count_data, file="/tmp/all_count_data.txt",
	    row.names=FALSE, quote=FALSE)


