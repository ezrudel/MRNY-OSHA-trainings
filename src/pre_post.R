# program to analyze pre- and post-test data

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
    summarise(avg = mean(score)) %>%
    suppressMessages()

  # make bar graph
  # ENGLISH
  barn = ggplot(means,
               aes(x=start_date,y=avg,fill=test)) +
    geom_col(position = "dodge") +
    ylim(0,10) +
    theme(text = element_text(size = 17),
          axis.text.x = element_text(angle = 45,
                                     hjust = 1)) +
    labs(title = "Pre- and Post-Test Results",
         subtitle = "from 2020-2021 OSHA trainings") +
    xlab("Training Start Date") +
    ylab("Average Score Out of 10")
  save.gg("ENG/pre-post-avg.png", barn)
  # SPANISH
  bars = barn +
    labs(title = "Resultados de pre- y post-evaluaciones",
         subtitle = "de entrenamientos de OSHA 2020-2021") +
    xlab("Fecha de inicio del entrenamiento") +
    ylab("Puntaje promedio de 10")
  save.gg("ESP/pre-post-promedio.png", bars)
  
  # make box plots
  # ENGLISH
  boxn = ggplot(scores, aes(x=start_date, y=score,
                           fill=test)) +
    geom_boxplot(outlier.size = 1.5) +
    ylim(0,10) +
    stat_summary(fun = mean, geom = "point",
                 shape = 18, color = "yellow",
                 size = 3,
                 position = position_dodge(
                   width = 0.75)) +
    theme(text = element_text(size = 17),
          axis.text.x = element_text(angle = 45,
                                     hjust = 1)) +
    labs(title = "Pre- and Post-Test Results",
         subtitle = "from 2020-2021 OSHA trainings") +
    xlab("Training Start Date") +
    ylab("Score Out of 10")
  save.gg("ENG/pre-post-distribution.png", boxn)
  #SPANISH
  boxs = boxn +
    labs(title = "Resultados de pre- y post-evaluaciones",
         subtitle = "de entrenamientos de OSHA 2020-2021") +
    xlab("Fecha de inicio del entrenamiento") +
    ylab("Puntaje de 10")
  save.gg("ESP/pre-post-distribucion.png", boxs)
  
  setwd("..")
}
