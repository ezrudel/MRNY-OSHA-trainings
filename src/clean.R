# program to clean output of Google Forms CSV download
# into readable dataframe


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
  #check for bad data
  if(nrow(df) == 0){
    return(sblank)
  }
  
  # select and rename columns
  df = df[, -c(1:2)]
  colnames(df) = c("Instructor",
                   "X1","X2","X3","X4","X5",
                   "X6","X7","X8")
  
  # reformat factor columns
  df$Instructor = as.factor(df$Instructor)
  df$X1 = factor(df$X1, levels = c("Bajo",
                                   "Suficiente",
                                   "Satisfactorio",
                                   "Muy Bueno",
                                   "Exelente"))
  df$X3 = factor(df$X3, levels = c("Bajo",
                                   "Suficiente",
                                   "Satisfactorio",
                                   "Muy Bueno",
                                   "Excelente"))
  
  # given a single string from column X5,
  # returns the corresponding shortened value
  interpret.X5 = function(x){
    if(x == "No aplicaré los conocimientos"){
      return("Ningunos")
    } else if(x == "Aplicaré algunos conocimientos"){
      return("Algunos")
    } else if(x == "Aplicaré la gran parte de los conocimientos"){
      return("Muchos")
    } else if(x == "Aplicaré todos los conocimientos"){
      return("Todos")
    } else {
      return(NA)
    }
  }
  df$X5 = df$X5 %>% as.character()
  df$X5 = df$X5 %>% lapply(interpret.X5) %>% unlist()
  df$X5 = df$X5 %>% factor(levels = c("Ningunos",
                                      "Algunos",
                                      "Muchos",
                                      "Todos"))
  
  # add date column
  df = data.frame(start_date = t.key[tr], df)
  
  return(df)
}
