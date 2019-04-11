library(Matrix)
## Read in salmon alevin matrix output

# save as sparse matrix
salmon_matrix.sparse  <- Matrix(salmon_matrix , sparse = T )

writeMM(obj = salmon_matrix.sparse , file="sparse_matrix.mtx")
