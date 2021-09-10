# ------------------------------------
# Project: OSHA Training Analyzer
# 
# Script: survey.R
# 
# Author: Ezra Rudel
# 
# Date Created: 2021-09-10
# 
# Copyright (c) Ezra Rudel 2021
# Email: ezra@rudel.net
# 
# ------------------------------------

# program to analyze survey data

# creates copy of sdata in English
english.copy = function(){
  sdataEN <<- data.frame(sdata)
  sdataEN$X1 <<- sdataEN$X1 %>% lapply(to.english) %>%
    factor(levels = rateLevelsEN)
  sdataEN$X3 <<- sdataEN$X3 %>% lapply(to.english) %>%
    factor(levels = rateLevelsEN)
  sdataEN$X5 <<- sdataEN$X5 %>% lapply(to.english) %>%
    factor(levels = appLevelsEN)
}

# compares instructors via the average overall
# rating of their trainings
by.instructor = function(){
  setwd("output")
  
  # ENGLISH
  # get avg ratings for each instructor
  meansEN = sdataEN %>% group_by(Instructor) %>%
    summarise(avg = mean(as.numeric(X1)))
  
  # make graph
  barn = ggplot(meansEN,
               aes(x=Instructor,y=avg)) +
    geom_col(fill = 10) +
    labs(title = "Overall Ratings by Instructor",
         subtitle = paste("from OSHA trainings",
                          t.key[1], "-",
                          t.key[length(t.key)])) +
    xlab("Instructor") +
    theme(text = element_text(size = 17),
          axis.text.x = element_text(angle = 50,
                                     hjust = 1)) +
    scale_y_continuous(name = "Average Overall Rating",
                       breaks = c(1:5),
                       labels = levels(sdataEN$X1),
                       limits = c(0,5))
  save.gg("ENG/instructor-ratings.png", barn)
  
  # SPANISH
  # get avg ratings for each instructor
  means = sdata %>% group_by(Instructor) %>%
    summarise(avg = mean(as.numeric(X1)))
  
  # make graph
  bars = ggplot(means,
                aes(x=Instructor,y=avg)) +
    geom_col(fill = 10) +
    theme(text = element_text(size = 17),
          axis.text.x = element_text(angle = 50,
                                     hjust = 1)) +
    labs(title = "Calificación general por instructor",
         subtitle = paste("de entrenamientos de OSHA",
                          t.key[1], "-",
                          t.key[length(t.key)])) +
    xlab("Instructor") +
    scale_y_continuous(name = "Calificación general promedio",
                       breaks = c(1:5),
                       labels = levels(sdata$X1),
                       limits = c(0,5))
  save.gg("ESP/calificación-instructor.png", bars)
  setwd("..")
}

# graph distribution of ratings of instruction materials
materials = function(){
  setwd("output")
  
  # make graph
  # ENGLISH
  barn = ggplot(sdataEN, aes(x=X3)) +
    geom_bar(aes(y = (..count..)/sum(..count..)),
             fill = 10) +
    theme(text = element_text(size = 17),
          axis.text.x = element_text(angle = 50,
                                     hjust = 1)) +
    scale_x_discrete(name = "How would you rate the instruction materials?",
                     drop = FALSE) +
    scale_y_continuous(name = "Percent of responses",
                       labels = scales::percent) +
    labs(title = "Instruction Materials",
         subtitle = paste("from OSHA trainings",
                          t.key[1], "-",
                          t.key[length(t.key)]))
  save.gg("ENG/materials.png", barn)
  
  # SPANISH
  bars = ggplot(sdata, aes(x=X3)) +
    geom_bar(aes(y = (..count..)/sum(..count..)),
             fill = 10) +
    theme(text = element_text(size = 17),
          axis.text.x = element_text(angle = 50,
                                     hjust = 1)) +
    labs(title = "Materiales de instrucción",
         subtitle = paste("de entrenamientos de OSHA",
                          t.key[1], "-",
                          t.key[length(t.key)])) +
    scale_y_continuous(name = "Porcentaje de respuestas",
                       labels = scales::percent) +
    scale_x_discrete(name = "¿Comó se calificará los materiales de instrucción?",
                     drop = FALSE)
  save.gg("ESP/materiales.png", bars)
  setwd("..")
}

# graph distribution of ratings of usefulness of training
application = function(){
  setwd("output")
  
  # make graph
  # ENGLISH
  barn = ggplot(sdataEN, aes(x=X5)) +
    geom_bar(aes(y = (..count..)/sum(..count..)),
             fill = 10) +
    theme(text = element_text(size = 17),
          axis.text.x = element_text(angle = 50,
                                     hjust = 1)) +
    scale_x_discrete(name = "How much of the content from this training will you apply?",
                     drop = FALSE) +
    scale_y_continuous(name = "Percent of responses",
                       labels = scales::percent) +
    labs(title = "Application of Content",
         subtitle = paste("from OSHA trainings",
                          t.key[1], "-",
                          t.key[length(t.key)]))
  save.gg("ENG/applications.png", barn)
  # SPANISH
  bars = ggplot(sdata, aes(x=X5)) +
    geom_bar(aes(y = (..count..)/sum(..count..)),
             fill = 10) +
    theme(text = element_text(size = 17),
          axis.text.x = element_text(angle = 50,
                                     hjust = 1)) +
    labs(title = "Aplicación de conocimientos",
         subtitle = paste("de entrenamientos de OSHA",
                          t.key[1], "-",
                          t.key[length(t.key)])) +
    scale_y_continuous(name = "Porcentaje de respuestas",
                       labels = scales::percent) +
    scale_x_discrete(name = "¿Cuantos conocimientos del entrenamiento aplicará usted?",
                     drop = FALSE)
  save.gg("ESP/aplicación.png", bars)
  setwd("..")
}
