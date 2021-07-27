#program to run all code in project

#set directory
setwd("C:/Users/ezra/Desktop/R-workspace/MRNY-OSHA-trainings")

#load packages
library(dplyr)
library(readr)
library(stringr)
library(ggplot2)

source("src/util.R", encoding = "UTF-8")

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
colnames(sblank) = c("start_date","Instructor",
                     "X1","X2","X3","X4","X5",
                     "X6","X7","X8")
sblank$start_date = factor()
sblank$Instructor = factor()
sblank$X1 = factor()
sblank$X2 = character()
sblank$X3 = factor()
sblank$X4 = character()
sblank$X5 = factor()
sblank$X6 = character()
sblank$X7 = character()
sblank$X8 = character()
sdata = data.frame(sblank)

# graph dimensions
ggw = 7
ggh = 7
ggu = "in"
ggres = 300

# ggplot defaults
theme_set(theme_light())

# run code
run = function(){
  # load data into df
  source("src/load.R", encoding = 'UTF-8')
  load.data()
  
  source("src/survey.R", encoding = 'UTF-8')
  by.instructor()
  materials()
  
  source("src/pre_post.R", encoding = 'UTF-8')
  vs.pre_post()
  
  source("src/unit.R", encoding = 'UTF-8')
  by.question()
  by.test()
  
}
run()
