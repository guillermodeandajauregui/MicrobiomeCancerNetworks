#libraries 
source("libs/functions_mi.R")
library(tidyverse)

#read data 
early_mi <- vroom::vroom(file = "results/early_matrix.txt")
late_mi  <- vroom::vroom(file = "results/late_matrix.txt")

#read a dictionary
dict <- vroom::vroom(file = "results/protein_coding_dict.txt")

#remove version numbers
colnames(early_mi)  <- colnames(early_mi) %>% str_remove(pattern = "\\..*$") 
colnames(late_mi)  <- colnames(late_mi) %>% str_remove(pattern = "\\..*$") 

#get the ensembl_gene ids in the matrix

protein_codings <-
dict %>% 
  filter(ensembl_gene_id%in%colnames(early_mi)) %>% 
  pull(ensembl_gene_id) %>% 
  unique()

#keep only protein codings

early_mi.coding <- 
early_mi %>% 
  select(all_of(protein_codings))

late_mi.coding <- 
  late_mi %>% 
  select(all_of(protein_codings))

#make it as a matrix

early_mi.coding <- as.matrix(early_mi.coding)
late_mi.coding <- as.matrix(late_mi.coding)

#Look at the MI distros

early_mi.coding %>% 
  density() %>% 
  plot

late_mi.coding %>% 
  density() %>% 
  plot

# Get thresholds

th_early <- quantile(x = early_mi.coding, probs = 0.995)
th_late <- quantile(x = late_mi.coding, probs = 0.995)


# Make them bipartites

early_mi.coding.filtered <- ifelse(early_mi.coding >= th_early, 1, 0)
late_mi.coding.filtered <- ifelse(late_mi.coding >= th_late, 1, 0)

rownames(early_mi.coding.filtered) <- early_mi$`microorganism/gene`
rownames(late_mi.coding.filtered)  <- late_mi$`microorganism/gene`

library(igraph)
library(tidygraph)

b_early <- igraph::graph_from_incidence_matrix(incidence = early_mi.coding.filtered, 
                                               directed = F)

b_late <- igraph::graph_from_incidence_matrix(incidence = late_mi.coding.filtered, 
                                               directed = F)


V(b_early)$type <- igraph::bipartite.mapping(b_early)$type
V(b_late)$type <- igraph::bipartite.mapping(b_late)$type

b_early %>% 
  as_tbl_graph() %>% 
  mutate(degree = centrality_degree()) %>% 
  #get.data.frame("vertices") %>% 
  as_tibble() %>% 
  group_by(type, degree) %>% 
  tally() %>% 
  mutate(my_type = ifelse(type==T, "gene", "microorganism")) %>% 
  arrange(desc(n)) %>% 
  ggplot(mapping = aes(x=degree, y = n, colour = as.factor(my_type))) +
  geom_point() + 
  theme_minimal() + 
  scale_x_log10() + 
  scale_y_log10() + 
  ylab("P(K)") + 
  xlab("K") + 
  scale_color_manual(name = "", values = c("red", "blue"))
  
  
  
b_late %>% 
  as_tbl_graph() %>% 
  mutate(degree = centrality_degree()) %>% 
  #get.data.frame("vertices") %>% 
  as_tibble() %>% 
  group_by(type, degree) %>% 
  tally() %>% 
  mutate(my_type = ifelse(type==T, "gene", "microorganism")) %>% 
  arrange(desc(n)) %>% 
  ggplot(mapping = aes(x=degree, y = n, colour = as.factor(my_type))) +
  geom_point() + 
  theme_minimal() + 
  scale_x_log10() + 
  scale_y_log10() + 
  ylab("P(K)") + 
  xlab("K") + 
  scale_color_manual(name = "", values = c("red", "blue"))

b_early %>% 
  write_graph(file = "results/early.graphml", format = "graphml")


b_late %>% 
  write_graph(file = "results/late.graphml", format = "graphml")
