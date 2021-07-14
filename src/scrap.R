#make individual scores data
scores = df %>%
  replace(is.na(.), 0) %>%
  transmute(Nombre=Nombre,
            score = rowSums(across(where(is.numeric))),
            outOf = ncol(select_if(df,is.numeric)))
View(scores)
#make question avg data
qavg = data.frame(colSums(df[-1])) %>%
  transmute(total = colSums.df..1..) %>%
  transmute(total = total,
            avg = total / nrow(df))
View(qavg)

# args = commandArgs(trailingOnly = TRUE)
# if(length(args) != 1) {
#   stop("1 arg needed")
# }
# df = read.csv(args[1])

#program to run all code in project

#set directory
setwd("C:/Users/ezra/Desktop/R-workspace/MRNY-OSHA-trainings")

#load packages
library(dplyr)
library(readr)
library(stringr)
source("src/clean.R")

#clean files
setwd("data/raw")
# key = data.frame(Training = numeric(),
#                  Start_Date = as.Date(character()),
#                  Test = numeric(),
#                  Topic = character())
#colnames(key) = c("Training","Dates","Test","Topic")
dirs = list.dirs(recursive = FALSE)
for(d in 1:length(dirs)){
  files = list.files(path = dirs[d])
  #start_date = dirs[d] %>% str_sub(3) %>% str_split('-')[1]
  # date = sapply(str_split(str_sub(dirs[d],3),'_'),
  #                     getElement, 1)
  for(f in 1:length(files)){
    df = read.csv(file.path(dirs[d],files[f]))
    # new_row = c(d,date,f,files[f])
    # key[nrow(key)+1,] = new_row
    df = df %>% clean(d,f)
  }
}
View(df)