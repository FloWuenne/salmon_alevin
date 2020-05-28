## How to run tool
# Rscript alevin_to_seurat.R --input $alevin_matrix_rds  --output $seurat_object

# Set up R error handling to go to stderr
options(show.error.messages=F, error=function(){cat(geterrmessage(),file=stderr());q("no",1,F)})

# Avoid crashing Galaxy with an UTF8 error on German LC settings
loc <- Sys.setlocale("LC_MESSAGES", "en_US.UTF-8")

suppressPackageStartupMessages({
  library("getopt")
  library("Seurat")
  library("reticulate")
})

# Import required libraries
options(stringAsfactors = FALSE, useFancyQuotes = FALSE)

# Take in trailing command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Get options using the spec as defined by the enclosed list
# Read the options from the default: commandArgs(TRUE)
option_specification = matrix(c(
  'input', 'i1', 2, 'character',
  'type', 't', 2, 'character',
  'output', 'o', 2, 'character'
), byrow=TRUE, ncol=4)

# Parse options
options = getopt(option_specification)

# Print options to stderr
# Useful for debugging
#cat("\n input file: ",options$input)
#cat("\n input file: ",options$type)
#cat("\n output file: ",options$output)

#### Check what the input type is
if(options$type=="dge_text"){
  ## DGE file in text format
  input_data <- read.table(options$input, row.names = 1)
}else if(options$type=="alevin_matrix_rds"){
	## Salmon Alevin matrix
	input_data <- readRDS(options$input)
}else if(options$type=="scanpy_h5"){
	ad <- import("anndata", convert = FALSE)
	ad_object <- ad$read_h5ad(options$input)
	seurat_object <- Convert(pbmc_ad, to = "seurat")
}


## Create Seurat object
if(options$type != "scanpy_h5"){
	seurat_object <- CreateSeuratObject(input_data)
}

# Output kmer counts
saveRDS(seurat_object, file = options$output)

cat("\n Successfully created Seurat object! \n")
