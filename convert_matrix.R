library(Matrix)
library(data.table)

matrix_dir <- "results/starsolo/Solo.out/Gene/raw"
output_file <- "results/umi_counts.txt"

mat_sparse <- readMM(
  file.path(matrix_dir, "umiDedup-1MM_Directional.mtx")
)

features <- fread(
  file.path(matrix_dir, "features.tsv"),
  header = FALSE,
  data.table = FALSE
)

barcodes <- fread(
  file.path(matrix_dir, "barcodes.tsv"),
  header = FALSE,
  data.table = FALSE
)

stopifnot(nrow(mat_sparse) == nrow(features))
stopifnot(ncol(mat_sparse) == nrow(barcodes))

mat <- as.data.frame(as.matrix(mat_sparse))
colnames(mat) <- barcodes[[1]]
rownames(mat) <- features[[1]]

fwrite(
  mat,
  file = output_file,
  sep = "\t",
  quote = FALSE,
  row.names = TRUE,
  col.names = TRUE
)

message("Wrote: ", output_file)

