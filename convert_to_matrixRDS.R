#!/usr/bin/env Rscript 

print("Converting to sparse matrix and saving as RDS file...")

library(Matrix)
library(data.table)
## Read in salmon alevin matrix output

# save as sparse matrix
alevin_matrix <- fread("./alevin_output/alevin/quants_mat.csv")
genes <- readLines("./alevin_output/alevin/quants_mat_cols.txt")
barcodes <- readLines("./alevin_output/alevin/quants_mat_rows.txt")

alevin_matrix <- as.matrix(alevin_matrix)
alevin_matrix <-  t(alevin_matrix[,1:ncol(alevin_matrix)-1])
alevin_matrix  <- Matrix(alevin_matrix, sparse = T )

colnames(alevin_matrix) <- barcodes
rownames(alevin_matrix) <- genes
alevin_matrix[is.na(alevin_matrix)] <- 0


## Print output and save according to seurat-script pipeline
## Copied directly from (https://github.com/ebi-gene-expression-group/r-seurat-scripts/blob/develop/seurat-read-10x.R)
# Use the default show method to print feedback

printSpMatrix2(alevin_matrix, note.dropping.colnames = FALSE, maxp = 500)

# Output to a serialized R object

saveRDS(alevin_matrix, file = "./salmon_alevin_matrix.RDS")

print("Done converting matrix!")
