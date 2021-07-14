# program to read in all data into a single dataframe

#load packages
library(readr)
library(dplyr)
library(stringr)

load.data = function(){
  # initialize dataframe
  df = data.frame(matrix(nrow = 0, ncol = 13))
  colnames(df) = c("training","test","Nombre",
                   "X1","X2","X3","X4","X5",
                   "X6","X7","X8","X9","X10")
  df$Nombre = character()
  source("src/clean.R")
  setwd("data/raw")
  for(i in 1:length(dirs)){
    tests = list.dirs(path = dirs[i])
    for(j in 2:length(tests)){
      results = list.files(path = file.path(tests[j]),
                           pattern = "csv")
      # read in file,
      # ignore warnings about incomplete files
      temp = read.csv(file.path(tests[j],results),
                      encoding = "UTF-8") %>%
        suppressWarnings()
      
      # extract number from filename:
      n = tests[j] %>% str_sub(3) %>%
        str_split('/') %>%
        sapply(getElement, 2) %>%
        str_split("\\. ") %>%
        sapply(getElement, 1) %>%
        gsub("Copy of ", "", .) %>% as.numeric()
      
      # clean data
      if(n == 18){ # survey
        temp = temp %>% clean.survey(i)
      } else { # test
        temp = temp %>% clean.test(i,n)
      }
      
      # check for bad data and add to df
      if(nrow(temp) == 0){
        bad_data <<- bad_data %>% rbind(c(dirs[i], n))
      } else {
        df = df %>% bind_rows(temp)
      }
    }
  }
  
  # add date column
  df = df %>% mutate(start_date = t.key[training]) %>%
    select(-training)
  df = df[c(13,1:12)]
  
  setwd("../..")
  return(df)
}
