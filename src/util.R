# utility functions for all parts of program

# load packages
library(ggplot2)
library(dplyr)
library(stringr)

save.gg = function(fname, graph){
  ggsave(fname, plot = graph,
         width = ggw, height = ggh,
         units = ggu, dpi = ggres)
}