# llamada de las dependencias del proyecto

source("Code/libs.R")
source("Code/load.R")
source("Code/func.R")
source("Code/clean.R")


#dtm <- cleanSet(as.character(train$Comment[train$Insult==1]))

## @knitr removing_sparse_terms
#dtm2 <- removeSparseTerms(dtm, 0.85)

## @knitr finding_freqterms
#freq <- findFreqTerms(dtm,20)

