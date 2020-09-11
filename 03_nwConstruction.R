#libraries 
source("libs/functions_mi.R")

early_mi <- vroom::vroom(file = "results/early_matrix.txt")
late_mi  <- vroom::vroom(file = "results/late_matrix.txt")
