# program to read in all data into a single dataframe

#load packages
library(readr)
library(dplyr)
library(stringr)

load.data = function(){
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
      } else if(n == 18){ # survey
        sdata <<- sdata %>% bind_rows(temp)
      } else { # test
        tdata <<- tdata %>% bind_rows(temp)
      }
    }
  }
  
  # # add date column
  # tdata = tdata %>%
  #   mutate(start_date = t.key[training]) %>%
  #   select(-training)
  # tdata = tdata[c(13,1:12)]
  
  setwd("../..")
  return(tdata)
}
