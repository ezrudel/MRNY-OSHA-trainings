# program to analyze survey data

# import packages
library(dplyr)
library(ggplot2)
library(stringr)

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
  barn
  ggsave("ENG/instructor-ratings.png",
         width = ggw, height = ggh,
         units = ggu, dpi = ggres)
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
  bars
  ggsave("ESP/calificación-instructor.png",
         width = ggw, height = ggh,
         units = ggu, dpi = ggres)
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
    scale_y_continuous(name = "Percent of responses",
                       labels = scales::percent) +
    scale_x_discrete(name = "", drop = FALSE) +
    labs(title = "Quality of Instruction Materials",
         subtitle = paste("from OSHA trainings",
                          t.key[1], "-",
                          t.key[length(t.key)]))
  barn
  ggsave("ENG/materials.png",
         width = ggw, height = ggh,
         units = ggu, dpi = ggres)
  # SPANISH
  bars = barn +
    labs(title = "Calidad de los materiales de instrucción",
         subtitle = paste("de entrenamientos de OSHA",
                          t.key[1], "-",
                          t.key[length(t.key)])) +
    scale_y_continuous(name = "Porcentaje de respuestas",
                       labels = scales::percent)
  bars
  ggsave("ESP/materiales.png",
         width = ggw, height = ggh,
         units = ggu, dpi = ggres)
  setwd("..")
}
