# excess code I might need later

df[,1] = factor(df[,1],
                levels = c("William Bonilla",
                           "Christina Fox",
                           "Holman Llanos",
                           "Fredy LLanos",
                           "Oswaldo Mendoza",
                           "Nestor Morales"))
df[,2] = factor(df[,2],
                levels = c("Bajo",
                           "Suficiente",
                           "Satisfactorio",
                           "Muy Bueno",
                           "Exelente"))
df[,4] = factor(df[,4],
                levels = c("Bajo",
                           "Suficiente",
                           "Satisfactorio",
                           "Muy Bueno",
                           "Excelente"))
df[,6] =
  factor(df[,6],
         levels =
           c("No aplicaré los conocimientos",
             "Aplicaré algunos conocimientos",
             "Aplicaré la gran parte de los conocimientos",
             "Aplicaré todos los conocimientos"))


x = x %>% str_split(" ") %>% getElement(1)
x = x[-1]
x = x[-length(x)]
if(length(x) > 1){
  x = x[-length(x)]
}
if(length(x) > 1){
  x = x[-length(x)]
}
return(x)