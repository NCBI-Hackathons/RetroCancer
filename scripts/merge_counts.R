library(tools)

#FIXME: Make arguments settable via the command line

#setwd("/home/ubuntu/users/fred/RetroCancer/data/melanoma/results/counts")
#setwd("/home/ubuntu/users/sameer/RetroCancer/data/AML/results/counts")
#setwd("/home/ubuntu/users/fred/RetroCancer/data/successful_nml_Skin/counts")
#filenames <- Sys.glob("*.counts.txt")
#filesep="\t"
#id_col = "V1"
#count_col = "V2"

#setwd("/home/ubuntu/users/laitanawe/RetroCancer/data/counts/aml")
#setwd("/home/ubuntu/users/laitanawe/RetroCancer/data/counts/successful_nml_blood")
#setwd("/home/ubuntu/users/laitanawe/RetroCancer/data/counts/successful_nml_Skin")
#id_col = "V2"
#count_col = "V1"
#filenames <- Sys.glob("*.hervcount.txt")
#filesep=""

PrettifyFilename <- function(x) {
  ret <- basename(x)
  # Keep only the part of the string before the period
  ret <- strsplit(x, split=".", fixed=TRUE)[[1]][[1]]
  # If there is an underscore keep only the first part
  ret <- strsplit(x, split="_")[[1]][[1]]
  return(ret)
}

names(filenames) <- lapply(filenames, PrettifyFilename) 

# Read in all the data from the filenames
filename_data <- lapply(filenames, read.table, header=FALSE, 
			stringsAsFactors=FALSE, sep=filesep)


# Read in counts data by only looking at certain columns
count_data <- lapply(filename_data, function(x) x[, c(id_col, count_col)])

# Rename the second column of the count data to be the Pretty filename
count_data_modified <- lapply(names(count_data), function(z) {
  colnames(count_data[[z]]) <- c(id_col, z)
  count_data[[z]]
})

all_count_data <- Reduce(function(x, y) merge(x, y, by=id_col, all=TRUE), 
			 count_data_modified)
write.table(all_count_data, file="all_count_data.tsv",
	    row.names=FALSE, quote=FALSE, sep="\t")


