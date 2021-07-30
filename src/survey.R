# program to analyze survey data

# compares instructors via the average overall
# rating of their trainings
by.instructor = function(){
  setwd("output")
  
  # get avg ratings for each instructor
  means = sdata %>% group_by(Instructor) %>%
    summarise(avg = mean(as.numeric(X1)))
  
  # make graph
  # ENGLISH
  barn = ggplot(means,
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
                       labels = levels(sdata$X1),
                       limits = c(0,5))
  save.gg("ENG/instructor-ratings.png", barn)
  # SPANISH
  bars = barn +
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

materials = function(){
  setwd("output")
  
  # make graph
  # ENGLISH
  barn = ggplot(sdata, aes(x=X3)) +
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
  bars = barn +
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

application = function(){
  setwd("output")
  
  # make graph
  # ENGLISH
  barn = ggplot(sdata, aes(x=X5)) +
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
  bars = barn +
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
