# cleans the output from Google Forms into a dataframe
# with the names of all participants, which training
# they took, and which questions they got right

#load packages
library(dplyr)
library(stringr)

clean.test = function(df,tr,te){
  # check for bad data
  if(nrow(df) == 0){
    return(tblank)
  }
  # select columns
  df = df[,-c(1,2)]
  df = data.frame(df[1],
                  select(df,
                         (ends_with("Score.") &
                            !starts_with("Nombre") &
                            !starts_with("Fecha") &
                            !starts_with("Entrenador"))))
  
  # simplify column names
  if(te == 1 | te == 19){ # pre-/post-test
    colnames(df) = c("Nombre",
                     "X1","X2","X3","X4","X5",
                     "X6","X7","X8","X9","X10")
  } else { # unit test
    colnames(df) = c("Nombre",
                     "X1","X2","X3","X4","X5")
  }
  
  #reformat data
  format_col = function(var){
    as.numeric(str_sub(var,1,1)) /
      as.numeric(str_sub(var,8,8))
  }
  df = df %>% transmute(Nombre=Nombre,
                        across(starts_with("X"),
                               format_col))
  
  #remove duplicate and blank rows
  df = df %>% distinct(tolower(Nombre), .keep_all = TRUE)
  df = df %>% select(-"tolower(Nombre)")
  df = df %>% filter(df[1]!="")
  
  #check again for bad data
  if(nrow(df) == 0){
    return(tblank)
  }
  
  #add test and date columns
  df = data.frame(test = te, df)
  df = data.frame(start_date = t.key[tr], df)
  
  return(df)
}

clean.survey = function(df,tr){
  df = df[, -c(1:2)]
  colnames(df) = c("Instructor",
                   "X1","X2","X3","X4","X5",
                   "X6","X7","X8")
  
  #check for bad data
  if(nrow(df) == 0){
    return(sblank)
  }
  
  return(df)
}
