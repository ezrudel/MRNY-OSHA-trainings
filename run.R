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
t.key = factor(t.key, levels = t.key)

# test data
tblank = data.frame(matrix(nrow = 0, ncol = 13))
colnames(tblank) = c("start_date","test","Nombre",
                    "X1","X2","X3","X4","X5",
                    "X6","X7","X8","X9","X10")
tblank$Nombre = character()
tblank$start_date = factor()
tdata = data.frame(tblank)

# survey data
sblank = data.frame(matrix(nrow = 0, ncol = 10))
colnames(sblank) = c("training","Instructor",
                     "X1","X2","X3","X4","X5",
                     "X6","X7","X8")
sdata = data.frame(sblank)

run = function(){
  # load data into df
  source("src/load.R")
  load.data()
  
  # View(tdata)
  # View(bad_data)
  
  source("src/survey.R")
  # analyze survey data
  
  source("src/pre_post.R")
  vs.pre_post()
  
  source("src/unit.R")
  by.question()
  by.test()
  
}
run()
