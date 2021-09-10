# ------------------------------------
# Project: OSHA Training Analyzer
# 
# Script: run.R
# 
# Author: Ezra Rudel
# 
# Date Created: 2021-09-10
# 
# Copyright (c) Ezra Rudel 2021
# Email: ezra@rudel.net
# 
# ------------------------------------

# program to run all code in project

# set working directory
arg = commandArgs(trailingOnly = TRUE)
if(length(arg) == 0) {
  stop("Please supply arguments: working directory")
} else {
  setwd(arg[1])
}

# for testing
# setwd("C:/Users/ezra/Desktop/R-workspace/MRNY-OSHA-trainings")

source("src/util.R", encoding = "UTF-8")

# necessary packages:
packages = c("ggplot2", "dplyr", "readr", "installr", "stringr")

instackages()

load.packages()

cat("\n")
updateR(fast = TRUE)

# set up directories
dir.setup()

# set up global variables:

# width for text output wrapping
w = 60

# welcome text
welcome = paste("\nWelcome to the OSHA Trainings Analyzer!",
                "This program was designed for Make the Road NY by",
                "Ezra Rudel. If you experience any problems with the",
                "software, please contact me at ezra@rudel.net.\n") %>%
  str_wrap(width = w)

# question abbreviation key
if (.Platform['OS.type'] == "windows"){
  q.key = read.csv("keys/questions.csv",
                   encoding = "UTF-8")
} else {
  q.key = read.csv("keys/questions.csv",
                   encoding = "macintosh")
}
colnames(q.key)[1] = "Test"
q.key$Topic = factor(q.key$Topic, levels = q.key$Topic)

# bad data log
bad_data = matrix(nrow = 0, ncol = 2)
colnames(bad_data) = c("Training",
                       "Test")

# directory list
setwd("input")
dirs = list.dirs(recursive = FALSE)
setwd("..")

# training key
t.key = dirs %>% str_sub(3,12) %>%
  as.Date(format = "%Y_%m_%d") %>% format("%b %d %Y")
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

# factor levels for surveys
rateLevels = c("Bajo",
               "Suficiente",
               "Satisfactorio",
               "Muy Bueno",
               "Excelente")
rateLevelsEN = rateLevels %>%
  lapply(to.english) %>% unlist()
appLevels = c("Ningunos",
              "Algunos",
              "Muchos",
              "Todos")
appLevelsEN = appLevels %>%
  lapply(to.english) %>% unlist()

# run code
run = function(){
  # intro
  cat("\n", welcome, "\n", sep = "")
  cat("\nYou have set the working directory to:\n",
      getwd(), "\n", sep = "")
  
  # load data into df
  source("src/load.R", encoding = 'UTF-8')
  load.data()
  suggestions.out()
  
  convert.bad_data()
  
  source("src/survey.R", encoding = 'UTF-8')
  english.copy()
  by.instructor()
  materials()
  application()
  
  source("src/pre_post.R", encoding = 'UTF-8')
  vs.pre_post()
  
  source("src/unit.R", encoding = 'UTF-8')
  by.question()
  by.test()
  
  print.bad_data()
  
  opendir(dir = "output")
  
}
run()

unload.packages()
