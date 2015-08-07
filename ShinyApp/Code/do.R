# Ejecucion del proyecto

source("libs.R")
source("load.R")
source("func.R")
source("clean.R")

## Usar createDataPartition(y = raw_data$class,p = .80,list = FALSE) para entrenar segun porcentaje p de la data YYY Sumar sata que consegui en web :)
## y usar confusionMatrix(arbol1$predictions,test$class) *buscar como

## @knitr creating_doctermmatrix
dtm <- TermDocumentMatrix(as.txtcomplete)

## @knitr removing_sparse_terms
dtm2 <- removeSparseTerms(dtm, 0.94)

## @knitr finding_freqterms
freq <- findFreqTerms(dtm2,10)

inspect(myCorpus[1])
myCorpus <- Corpus(VectorSource(as.data.frame(as.character(train$Comment[train$Insult == 1]))))
myCorpus <- tm_map(myCorpus, tolower)
myCorpus <- tm_map(myCorpus, removePunctuation)
# remove numbers
myCorpus <- tm_map(myCorpus, removeNumbers)
# remove URLs
removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
myCorpus <- tm_map(myCorpus, removeURL)
# add two extra stop words: "available" and "via"
myStopwords <- stopwords("english")
# remove "r" and "big" from stopwords
myStopwords <- setdiff(myStopwords, c("r", "big"))
# remove stopwords from corpus
myCorpus <- tm_map(myCorpus, removeWords, myStopwords)
myCorpusCopy <- myCorpus
# stem words
myCorpus <- tm_map(myCorpus, stemDocument)
myCorpus <- tm_map(myCorpus, stemCompletion, dictionary=myCorpusCopy)
inspect(myCorpus[1])
myCorpus <- tm_map(myCorpus, PlainTextDocument)
myTdm <- TermDocumentMatrix(myCorpus, control=list(wordLengths=c(1,Inf)))
myTdm
findFreqTerms(myTdm, lowfreq=50)
termFrequency <- rowSums(as.matrix(myTdm))
termFrequency <- subset(termFrequency, termFrequency>=50)
barplot(termFrequency, las=2)
findAssocs(myTdm, "like", 0)
save.image("06072015.Rdata")
#####################
prueba2 <- lapply(prueba,removePunctuation)
prueba2
raw_data[2,3]
input <- as.character(raw_data$Comment)

text = raw_data$Comment[raw_data$Insult == 1]
text = as.character(text)
out = list()
rmr.options(backend = "local")
out = from.dfs(wordcount(to.dfs(keyval(NULL, text)), pattern = " +"))
?table
save(out,file ="outMapReduce.Rdata")  
head(out$key)
load("objects/outMapReduce.Rdata")
out$key[out$val > 20]
tab1 <- table(out$key, out$val)

barplot(table(out$key, out$val), main="incidence", xlab="Words")
