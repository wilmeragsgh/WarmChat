# Carga de los datos del problema
setwd("./data/training/")
train <- load("data.Rdata")
train <- data
setwd("..")
badwords <- read.csv(file = "badwordsL.csv",header = F)
badwords1 <- read.csv(file = "badwords.csv",header = F)
badwords1 <- as.character(badwords1$V1)
badwords <- as.character(badwords$V1)
badwords <- c(badwords,"idiot","fucker","fagged","faggod","pussy","cocksucker","sucker","toy","clawn","stupid","jerk","slut","whore","homo","jizz","bastard","bimbo","psycho","tool","weirdo","uneducated",badwords1)
badwords<- unique(badwords)
setwd("..")
rm("data")
## @knitr end_chunk