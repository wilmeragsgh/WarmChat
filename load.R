# Carga de los datos del problema
load("data/data.Rdata")
load("models/maxentFit.Rdata")
load("models/svmFit.Rdata")
load("models/ngramFit.Rdata")
#badwords <- read.csv(file = "badwordsL.csv",header = F)
#badwords1 <- read.csv(file = "badwords.csv",header = F)
#badwords1 <- as.character(badwords1$V1)
#badwords <- as.character(badwords$V1)
#badwords <- c(badwords,"idiot","fucker","fagged","faggod","pussy","cocksucker","sucker","toy","clawn","stupid","jerk","slut","whore","homo","jizz","bastard","bimbo","psycho","tool","weirdo","uneducated",badwords1)
#badwords<- unique(badwords)
## @knitr end_chunk