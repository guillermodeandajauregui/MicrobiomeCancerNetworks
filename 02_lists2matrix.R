#libraries 
source("libs/functions_mi.R")

mi_early <- read_rds(path = "results/early.rds")
mi_late <- read_rds(path = "results/late.rds")


mi_early[sapply(mi_early, is.numeric)] %>% 
  bind_rows(.id = "microorganism/gene") %>% 
  vroom::vroom_write(path = "results/early_matrix.txt")

mi_late[sapply(mi_late, is.numeric)] %>% 
  bind_rows(.id = "microorganism/gene") %>% 
  vroom::vroom_write(path = "results/late_matrix.txt")
