#!/usr/bin/env Rscript 

print("Converting matrixto MatrixMarket format...")

library(Matrix)
library(data.table)
## Read in salmon alevin matrix output

# save as sparse matrix
salmon_matrix <- fread("./alevin_output/alevin/quants_mat.gz")
salmon_matrix.sparse  <- Matrix(salmon_matrix , sparse = T )

writeMM(obj = salmon_matrix.sparse , file="./sparse_matrix.mtx")

print("Done converting matrix!")
