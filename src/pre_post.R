# program to analyze pre- and post-test data

# output: graphs showing average scores and score
# distributions for pre- and post-tests for each
# training

library(dplyr)
library(ggplot2)

# create graphs comparing pre- and post-test data
vs.pre_post = function(){
  setwd("output")
  
  # calculate individual scores of pre/post-tests
  scores = tdata %>%
    filter(test == 1 | test == 19) %>%
    transmute(start_date = start_date,
              test = as.factor(test),
              Nombre = Nombre,
              score = rowSums(select(.,4:13)))
  
  # factor fuckery
  scores$test = as.character(scores$test)
  scores$test[scores$test == "1"] = "pre"
  scores$test[scores$test == "19"] = "post"
  scores$test = as.factor(scores$test) %>%
    factor(levels = c("pre","post"))
  
  # avg each test/training
  means = scores %>% group_by(start_date,test) %>%
    summarise(avg = mean(score))

  # make bar graph
  bar = ggplot(means,
               aes(x=start_date,y=avg,fill=test)) +
    geom_col(position = "dodge") +
    labs(title = "Pre- and Post-Test Results",
         subtitle = "from 2020-2021 OSHA trainings") +
    xlab("Training Start Date") +
    theme(text = element_text(size = 17),
          axis.text.x = element_text(angle = 45,
                                     hjust = 1)) +
    ylab("Average Score Out of 10") + ylim(0,10)
  bar
  ggsave("pre-post-avg.png")
  
  # make box plots
  box = ggplot(scores, aes(x=start_date, y=score,
                           fill=test)) +
    geom_boxplot(outlier.size = 1.5) +
    stat_summary(fun = mean, geom = "point",
                 shape = 18, color = "yellow",
                 size = 3,
                 position = position_dodge(
                   width = 0.75)) +
    labs(title = "Pre- and Post-Test Results",
         subtitle = "from 2020-2021 OSHA trainings") +
    xlab("Training Start Date") +
    theme(text = element_text(size = 17),
          axis.text.x = element_text(angle = 45,
                                     hjust = 1)) +
    ylab("Score Out of 10") + ylim(0,10)
  box
  ggsave("pre-post-dist.png")
  
  setwd("..")
}
