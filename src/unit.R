# program to analyze unit test data

# output: a graph for each unit test, showing the
# percent of participants across all trainings that
# got each question right

library(dplyr)
library(ggplot2)

# create graph comparing unit tests
by.test = function(){
  setwd("output")
  
  # calculate individual scores for unit tests
  scores = tdata[1:8] %>%
    filter(test > 1 & test < 17) %>%
    transmute(start_date = start_date,
              test = as.factor(test),
              Nombre = Nombre,
              score = rowSums(select(.,4:8)))
  
  # add test names
  scores = scores %>% mutate(
    topic = q.key[test,2]) %>%
    select(-test)
  scores = scores[c(4,1:3)]

  # avg each test
  means = scores %>% group_by(topic) %>%
    summarise(avg = mean(score))

  # make graph
  # ENGLISH
  barn = ggplot(means,
               aes(x=topic,y=avg)) +
    geom_col(fill = 10) +
    theme(text = element_text(size = 17),
          axis.text.x = element_text(angle = 50,
                                     hjust = 1)) +
    ylim(0,5) +
    labs(title = "Unit Test Results",
         subtitle = paste("from OSHA trainings",
                          t.key[1], "-",
                          t.key[length(t.key)])) +
    xlab("Topic") +
    ylab("Average Score Out of 5")
  save.gg("ENG/unit-test-avg.png", barn)
  # SPANISH
  bars = barn +
    labs(title = "Resultados de evaluaciones de la unidad",
         subtitle = paste("de entrenamientos de OSHA",
                          t.key[1], "-",
                          t.key[length(t.key)])) +
    xlab("Tema") +
    ylab("Puntaje promedio de 5")
  save.gg("ESP/unidad-promedio.png", bars)

  setwd("..")
}

# create graphs comparing questions on each unit test
by.question = function(){
  setwd("output")
  
  # iterate thru each test
  for(t in 2:17){
    current = tdata[1:8] %>% filter(test == t) %>% #t
      select(-start_date, -test, -Nombre) %>%
      t() %>% as.data.frame()
    c.key = q.key[1:7] %>% filter(Test == t) #t
    ctopic = c.key[1,2]
    qnames = c.key %>% select(-Test, -Topic) %>%
      as.character() %>% str_wrap(width = 22,
                                  indent = 3)
    # print(qnames)
    qnames = factor(qnames, qnames)
    
    # calculate % correct for each ?
    current = current %>%
      transmute(correct = round((rowMeans(.) * 100),
                                digits = 1),
                question = qnames)

    # make graph
    # ENGLISH
    barn = ggplot(current, aes(x = question,
                              y = correct)) +
      geom_col(fill = 10) +
      theme(text = element_text(size = 17),
            axis.text.x = element_text(angle = 40,
                                       hjust = 1,
                                       size = 14)) +
      ylim(0,100) +
      labs(title = "Unit Test Results by Question",
           subtitle = paste("Topic:", ctopic,
                            "   Date Range:",
                            t.key[1], "-",
                            t.key[length(t.key)])) +
      xlab("Question") +
      ylab("Percent with Correct Answer")
    fname = paste("ENG/unit-test", t, ctopic, ".png")
    save.gg(fname, barn)
    # SPANISH
    bars = barn +
      labs(title = "Evaluaciones de la unidad por pregunta",
           subtitle = paste("Tema:", ctopic,
                            "   Fechas:",
                            t.key[1], "-",
                            t.key[length(t.key)])) +
      xlab("Pregunta") +
      ylab("Porcentaje con la respuesta correcta")
    fname = paste("ESP/preguntas-unidad", t, ctopic, ".png")
    save.gg(fname, bars)
  }
  
  setwd("..")
}