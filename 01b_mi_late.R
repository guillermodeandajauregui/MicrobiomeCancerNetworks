########
#testing
########

#libraries 
source("libs/functions_mi.R")

#paths
path_micro <- "data/micro_late.tsv"
path_genes <- "data/genes_late.tsv"

#read data 

micro <- vroom::vroom(path_micro)
genes <- vroom::vroom(path_genes)

#discretizing 

tempus <- proc.time()
d.micro <- par_discretizer(micro, korez = 10)
tempus <- proc.time() - tempus
print(tempus)

tempus <- proc.time()
d.genes <- par_discretizer(genes, korez = 10)
tempus <- proc.time() - tempus
print(tempus)

#mi calculating 

tempus <- proc.time()
microXgenes <- par_mi_calc(sources = d.micro, 
                           targets = d.genes, 
                           korez = 10)
tempus <- proc.time() - tempus
print(tempus)

saveRDS(microXgenes, file = "results/late.rds")

# mi_matrix <- bind_rows(!!!microXgenes, #explicit splicing
#                        .id = "micro/gene")
# 
# vroom::vroom_write(x = mi_matrix, path = "results/late.txt")
