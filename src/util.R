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
    transmute("Training Start Date:" = t.key[Training],
              "Test Number:" = Test)
}

# prints bad_data log
print.bad_data = function(){
  message = paste("The following datasets could not be processed",
                  "because the forms that generated them were empty",
                  "or incorrectly formatted:") %>%
    str_wrap(width = w)
  cat("\n", message, "\n\n", sep = "")
  print.data.frame(bad_data, right = TRUE, row.names = FALSE)
  cat("\n")
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
    detach(paste0("package:", p),
           unload = TRUE,
           character.only = TRUE)
  }
}

# opens file explorer in given directory
opendir <- function(dir = getwd()){
  if (.Platform['OS.type'] == "windows"){
    shell.exec(dir)
  } else {
    system(paste(Sys.getenv("R_BROWSER"), dir))
  }
}

# verify directory setup and create folders if necessary
dir.setup = function(){
  subdirs = list.dirs(recursive = TRUE)
  if(!("./input" %in% subdirs)){
    stop("Input folder missing!")
  }
  if(!("./output" %in% subdirs)){
    dir.create("output")
  }
  if(!("./output/ENG" %in% subdirs)){
    dir.create("output/ENG")
  }
  if(!("./output/ESP" %in% subdirs)){
    dir.create("output/ESP")
  }
}
