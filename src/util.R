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

# converts bad_data matrix to readable df
convert.bad_data = function(){
  bad_data <<- bad_data %>% data.frame() %>%
    transmute(Training = t.key[Training],
              Test = Test)
}

# translates necessary words from Spanish to English
to.english = function(sp){
  dict = rbind(c("Todos", "All"),
               c("Muchos", "Most"),
               c("Algunos", "Some"),
               c("Ningunos", "None"),
               c("Excelente", "Excellent"),
               c("Muy Bueno", "Very Good"),
               c("Satisfactorio", "Satisfactory"),
               c("Suficiente", "Fair"),
               c("Bajo", "Poor")) %>%
    data.frame()
  colnames(dict) = c("Spanish", "English")
  return(dict$English[which(dict$Spanish == sp)])
}

# installs all necessary packages
instackages = function(){
  new.packages = packages[!(packages %in%
                              installed.packages()[,"Package"])]
  if(length(new.packages)){
    install.packages(new.packages)
  }
}

# uninstalls all packages installed during program
# for testing purposes only
uninstackages = function(){
  remove.packages(packages)
}

# loads all necessary packages
load.packages = function(){
  for(p in packages){
    suppressMessages(require(p, character.only = TRUE))
  }
}

# unloads all necessary packages
unload.packages = function(){
  for(p in packages) {
    detach(paste("package", p, sep = ":"),
           unload = TRUE,
           character.only = TRUE)
  }
}
