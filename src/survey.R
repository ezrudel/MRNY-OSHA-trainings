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
  
  # make bar graph
  bar = ggplot(means,
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
  bar
  ggsave("instructor-ratings.png")
  
  setwd("..")
}
