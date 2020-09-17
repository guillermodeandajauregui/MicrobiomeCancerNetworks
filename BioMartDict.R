packrat::on()
library(biomaRt)
library(tidyverse)

test_genes_early <- colnames(early_mi)[-1]
test_genes_late <- colnames(late_mi)[-1]
identical(x = test_genes_early, y = test_genes_late) #so we can use any

test_genes_early %>% head
test_genes <- test_genes_early %>% str_remove(pattern = "\\..*$") 

my_mart <- biomaRt::useMart(biomart = "ensembl", dataset = "hsapiens_gene_ensembl")

listFilters(my_mart) %>% 
  dplyr::filter(grepl(pattern = "ensembl", x = name))

safely_getBM <- (safely(getBM))

my_dict <- safely_getBM(attributes = c("hgnc_symbol", 
                                          "gene_biotype", 
                                          "ensembl_gene_id" 
                                          ),
                           filters = "ensembl_gene_id", 
                           values = test_genes, 
                           mart = my_mart)
my_dict$result %>%
  as_tibble() %>% 
  dplyr::filter(gene_biotype=="protein_coding") %>% 
  vroom::vroom_write(path = "results/protein_coding_dict.txt")
