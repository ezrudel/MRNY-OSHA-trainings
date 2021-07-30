# utility functions for all parts of program

# saves graph using global settings
save.gg = function(fname, graph){
  ggsave(remove.accents(fname), plot = graph,
         width = ggw, height = ggh,
         units = ggu, dpi = ggres)
}

# returns the given string with all accents removed
remove.accents = function(s){
  s = s %>%
    gsub("á", "a", .) %>%
    gsub("Á", "A", .) %>%
    gsub("é", "e", .) %>%
    gsub("É", "E", .) %>%
    gsub("í", "i", .) %>%
    gsub("Í", "I", .) %>%
    gsub("ó", "o", .) %>%
    gsub("Ó", "O", .) %>%
    gsub("ú", "u", .) %>%
    gsub("Ú", "U", .) %>%
    gsub("ñ", "n", .) %>%
    gsub("Ñ", "N", .) %>%
    gsub("¿", "", .) %>%
    gsub("¡", "", .)
  return(s)
}
