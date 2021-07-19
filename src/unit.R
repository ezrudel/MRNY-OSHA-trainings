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

  # make bar graph
  bar = ggplot(means,
               aes(x=topic,y=avg)) +
    geom_col(fill = 10) +
    labs(title = "Unit Test Results",
         subtitle = paste("from OSHA trainings",
                          t.key[1], "-",
                          t.key[length(t.key)])) +
    xlab("Topic") +
    theme(text = element_text(size = 17),
          axis.text.x = element_text(angle = 50,
                                     hjust = 1)) +
    ylab("Average Score Out of 5") + ylim(0,5)
  bar
  ggsave("unit-avg.png")

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
    c.key = q.key %>% filter(Test == t) #t
    ctopic = c.key[1,2]
    qnames = c.key %>% select(-Test, -Topic) %>%
      as.character() %>% str_wrap(width = 22,
                                  indent = 3)
    qnames = factor(qnames, qnames)
    
    # calculate % correct for each ?
    current = current %>%
      transmute(correct = round((rowMeans(.) * 100),
                                digits = 1),
                question = qnames)

    # make graph
    bar = ggplot(current, aes(x = question,
                              y = correct)) +
      geom_col(fill = 10) +
      labs(title = "Unit Test Results by Question",
           subtitle = paste("Topic:", ctopic,
                            "   Date Range:",
                            t.key[1], "-",
                            t.key[length(t.key)])) +
      xlab("Question") +
      theme(text = element_text(size = 17),
            axis.text.x = element_text(angle = 40,
                                       hjust = 1,
                                       size = 14)) +
      ylab("Percent with Correct Answer") +
      ylim(0,100)
    fname = paste("unit-test", t, ctopic, ".png")
    bar
    ggsave(fname)
  }
  
  setwd("..")
}