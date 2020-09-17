#packages used in this project
#install.packages("tidyverse")
#install.packages("data.table")
packrat::on()

install.packages("infotheo")
install.packages("dplyr")
install.packages("readr")
install.packages("vroom")
install.packages("tidyverse")
install.packages("igraph")
install.packages("tidygraph")
install.packages("ggraph")
#bioconductor 
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("biomaRt")

packrat::snapshot()
packrat::bundle(project = NULL, file = NULL, include.lib = TRUE, overwrite = TRUE)
