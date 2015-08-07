# Carga de los datos del problema
setwd("./data/training/")
train <- load("data.Rdata")
train <- data
setwd("..")
badwords <- read.csv(file = "badwordsL.csv",header = F)
setwd("..")
rm("data")
## @knitr end_chunk