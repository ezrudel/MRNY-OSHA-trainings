#program to run all code in project

#set directory
setwd("C:/Users/ezra/Desktop/R-workspace/MRNY-OSHA-trainings")

#load packages
library(dplyr)
library(readr)
library(stringr)

# set up global variables:
# question abbreviation key
q.key = read.csv("data/question-key.csv",
                 encoding="UTF-8")
colnames(q.key)[1] = "Test"
q.key$Topic = factor(q.key$Topic, levels = q.key$Topic)

# bad data log
bad_data = matrix(nrow = 0, ncol = 2)
colnames(bad_data) = c("training", "test")

# directory list
setwd("data/raw")
dirs = list.dirs(recursive = FALSE)
setwd("../..")

# training key
t.key = dirs %>% str_sub(3,12) %>%
  as.Date(format = "%Y_%m_%d") %>% format("%b %d")
t.key = factor(t.key, t.key)

run = function(){
  # load data into df
  source("src/load.R")
  df = load.data()
  
  # View(df)
  # View(bad_data)
  
  source("src/survey.R")
  surveys = df %>% filter(test == 18)
  # analyze survey data
  
  source("src/pre_post.R")
  pre_post = df %>% filter(test == 1 | test == 19)
  vs.pre_post(pre_post)
  
  source("src/unit.R")
  unit_tests = df %>% filter(test > 1,
                             test < 18)
  by.question(unit_tests)
  by.test(unit_tests)
  
}
run()
