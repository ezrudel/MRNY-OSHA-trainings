# ------------------------------------
# Project: OSHA Training Analyzer
# 
# Script: load.R
# 
# Author: Ezra Rudel
# 
# Date Created: 2021-09-10
# 
# Copyright (c) Ezra Rudel 2021
# Email: ezra@rudel.net
# 
# ------------------------------------

# program to read in all data into a single dataframe

load.data = function(){
  source("src/clean.R", encoding = 'UTF-8')
  setwd("input")
  for(i in 1:length(dirs)){
    tests = list.dirs(path = dirs[i])
    for(j in 2:length(tests)){
      results = list.files(path = file.path(tests[j]),
                           pattern = "csv")
      # read in file,
      # ignore warnings about incomplete files
      if (.Platform['OS.type'] == "windows"){
        temp = read.csv(file.path(tests[j],results),
                        encoding = "UTF-8") %>%
          suppressWarnings()
      } else {
        temp = read.csv(file.path(tests[j],results),
                        encoding = "UTF-8",
                        fileEncoding = "UTF-8") %>%
          suppressWarnings()
      }
      
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
        bad_data <<- bad_data %>% rbind(c(t.key[i], n))
      } else if(n == 18){ # survey
        sdata <<- sdata %>% bind_rows(temp)
      } else { # test
        tdata <<- tdata %>% bind_rows(temp)
      }
    }
  }
  
  setwd("..")
  return(tdata)
}

# write suggestion data into a CSV
suggestions.out = function(){
  sugs = sdata %>%
    transmute(start_date = start_date,
              instructor = Instructor,
              suggestion = X7)
  write_csv(sugs, "output/suggestions.csv")
}
