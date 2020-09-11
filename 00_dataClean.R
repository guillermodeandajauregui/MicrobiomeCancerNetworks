packrat::on()
packrat::restore()

library("tidyverse")

micro_early <- vroom::vroom(file = "data_irving/Tablas/StageIandII_bac_arch.csv")
genes_early <- vroom::vroom(file = "data_irving/Tablas/StageIandII_gene.csv")

micro_late <- vroom::vroom(file = "data_irving/Tablas/StageIIIandIV_bac_arch.csv")
genes_late <- vroom::vroom(file = "data_irving/Tablas/StageIIIandIV_gene.csv")

#micro_early[1:5, 1:5]
#micro_late[1:5, 1:5]

genes_early.clean <-
  genes_early %>% 
  select(-1) 

genes_late.clean <- 
  genes_late %>% 
  select(-1) #%>% 

micro_early.clean <-
  micro_early %>% 
  rename(microorganism = ...1) #%>% 


micro_late.clean <-
  micro_late %>% 
  rename(microorganism = ...1) #%>% 

#reorder columns to match----

#reorder early ----
ids_genes_early <- colnames(genes_early.clean)[-1]
ids_micro_early <- colnames(micro_early.clean)[-1]

ids_genes_early %>% length()
ids_micro_early %>% length()

ids_early <- intersect(ids_genes_early, ids_micro_early)

genes_early.clean %>% 
  select(gene, ids_early) %>% 
  vroom::vroom_write(path = "data_irving/genes_early.tsv")

micro_early.clean %>% 
  select(microorganism, ids_early) %>% 
  vroom::vroom_write(path = "data_irving/micro_early.tsv")

#reorder late ----
ids_genes_late <- colnames(genes_late.clean)[-1]
ids_micro_late <- colnames(micro_late.clean)[-1]

ids_genes_late %>% length()
ids_micro_late %>% length()

ids_late <- intersect(ids_genes_late, ids_micro_late)

genes_late.clean %>% 
  select(gene, ids_late) %>% 
  vroom::vroom_write(path = "data_irving/genes_late.tsv")

micro_late.clean %>% 
  select(microorganism, ids_late) %>% 
  vroom::vroom_write(path = "data_irving/micro_late.tsv")

#fini ----
genes_late.clean %>% 
  select(gene, colnames(micro_late.clean)[-1]) #%>% 
#vroom::vroom_write(path = "data_irving/genes_late.tsv")



micro_late.clean %>% 
  vroom::vroom_write(path = "data_irving/micro_late.tsv")