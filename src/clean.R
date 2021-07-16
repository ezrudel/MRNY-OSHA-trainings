# cleans the output from Google Forms into a dataframe with
# the names of all participants, which training they took,
# and which questions they got right

#load packages
library(dplyr)
library(stringr)

blank = data.frame(matrix(nrow = 0, ncol = 13))
colnames(blank) = c("training","test","Nombre",
                    "X1","X2","X3","X4","X5",
                    "X6","X7","X8","X9","X10")
blank$Nombre = character()

clean.test = function(df,tr,te){
  #rename "Nombre" column
  nameCol = df %>% select(contains("Nombre")) %>%
    colnames() %>% getElement(1)
  df = df %>% rename(Nombre = nameCol)
  #select name and score columns
  df = df %>% select(Nombre
                     | (starts_with("X")
                        & ends_with("Score.")))
  #simplify column names
  colnames(df) = sub("X(\\d*).*","X\\1",colnames(df))
  #reformat data
  format_col = function(var){
    as.numeric(str_sub(var,1,1)) /
      as.numeric(str_sub(var,8,8))
  }
  df = df %>% transmute(Nombre=Nombre,
                        across(starts_with("X"),
                               format_col))
  #remove duplicate and blank rows
  df = df %>% distinct(Nombre, .keep_all = TRUE)
  df = df %>% filter(df[1]!="")
  
  #check for bad data
  if(nrow(df) == 0){
    return(blank)
  }
  
  #add training_num column
  df = data.frame(test = te, df)
  df = data.frame(training = tr, df)
  return(df)
}

clean.survey = function(df,tr){
  df = df[, -c(1:2)]
  return(blank)
}
