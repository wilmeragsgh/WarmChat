#######################################################################################################
#
#             DETECCIÓN DE INSULTOS USANDO UN CLASIFICADOR DE MÁXIMA ENTROPÍA 
#
# Este código se divide en dos partes:
#
#     [1]: Predicción de un comentario 
#          - Se entrena el modelo usando toda la data de train.csv
#          - Se usa una función que recibe como argumento un comentario ingresado por teclado 
#          - La función devuelve la probabilidad de que el comentario sea insulto
#
#     [2]: Validación Cruzada
#          - Se entrena el modelo usando una muestra aleatoria igual a la mitad de train.csv 
#          - Se predice usando la otra mitad de la data
#          - Se calcula la precisión
#
# Observaciones: - Precisión aproximada: 0.75 ~ Sin preprocesar la data
#                - Solo considera la frecuencia de las palabras (por ahora)
#                - Información de la sesión:
#                                             R version 3.2.1 (2015-06-18)
#                                             Platform: i686-pc-linux-gnu (32-bit)
#                                             Running under: Ubuntu precise (12.04.5 LTS)
#
######################################################################################################

#library(RTextTools)  # RTextTools_1.4.0
#library(tm)          # tm_0.5-10
#library(maxent)      # maxent_1.3.3.1
#library(caret)       # caret_6.0-52

### Gets the data

# load("/data/data.Rdata")


#####---------- [1] Predicts just a comment ----------#####


### Makes corpora
# Function to predict a comment ~ it needs the dtm used to calculate the max-ent model and the max-ent model itself
maxent_predict <-function(comm){
  ### Training model
  #corpus <- Corpus(VectorSource(cleanComm(as.character(train$Comment))))
  
  ### Builds a term-document matrix
  
  #matrix <- DocumentTermMatrix(corpus)
  # 10 most frequent words
  #findFreqTerms(matrix, 10)
  
  ### Creates a MAXENT model [package: 'maxent']
  
  #sparse <- as.compressed.matrix(matrix)
  #modelMAXENT <- maxent(sparse[1:nrow(train),], as.factor(train$Insult)[1:nrow(train)])
  #save(modelMAXENT,file = "maxentFit.Rdata")
  load("maxentFit.Rdata")
  ### Predicts  
  testdata <- as.matrix(comm)
  predCorpus <- Corpus(VectorSource(testdata))
  predMatrix <- DocumentTermMatrix(predCorpus, list(dictionary = Terms(matrix)))
  predSparse <- as.compressed.matrix(predMatrix)
  
  # Predicts
  resultModel <- predict(modelMAXENT, predSparse[1:nrow(testdata),])
  result <- as.numeric(resultModel[,3])
  
  if(result > 0.65){
    return(1)
  } else {
    return(0)
  }
}

# r <- c()
# for(i in 1:length(train$Comment)){
#	 r[i]=maxent_predict(as.character(train$Comment[i]))
# }
# train1 <-cbind(train,maxent =r)
# table(train1$Insult,train1$maxent)
# library("caret")
# confusionMatrix(train1$Insult,train1$maxent)

#####---------- [2] Predicts a subset of all.traindata (cv: CROSS-VALIDATION) ----------#####


# Function that split a data frame into two subsets of the same size
#splitdf <- function(dataframe, seed=NULL) {
#  if (!is.null(seed)) set.seed(seed)
#  index <- 1:nrow(dataframe)
#  trainindex <- sample(index, trunc(length(index)/2))
#  trainset <- dataframe[trainindex,]
#  testset <- dataframe[-trainindex,]
#  list(trainset = trainset, testset = testset)
#}

# Calls the function and obtain train data and test data
#splits <- splitdf(all.traindata, seed = 666)
#traindata <- splits$trainset
#testdata <- splits$testset

### Makes corpora

#corpus.cv <- Corpus(VectorSource(traindata$Comment))

### Cleans corpora

#corpus <- tm_map(corpus, removePunctuation)                  # THIS DOESNT AFFECT THE ACCURACY !!  
#corpus <- tm_map(corpus, stripWhitespace)                    # THIS DOESNT AFFECT THE ACCURACY !!
#corpus <- tm_map(corpus, content_transformer(tolower))       # THIS DOESNT AFFECT THE ACCURACY !!
#corpus <- tm_map(corpus, removeWords, stopwords('english'))  # THIS REDUCES THE ACCURACY !! 
#corpus <- tm_map(corpus, stemDocument, lazy = TRUE)          # FUCKS THE DocumentTermMatrix !!

### Builds a term-document matrix

#matrix.cv <- DocumentTermMatrix(corpus.cv)
# 10 most frequent words
#findFreqTerms(matrix.cv, 10)

### Creates a MAXENT model [package: 'maxent']

#sparse.cv <- as.compressed.matrix(matrix.cv)
#modelMAXENT.cv <- maxent(sparse.cv[1:nrow(traindata),], as.factor(traindata$Insult)[1:nrow(traindata)])

### Predicts

# Prepares data to be predicted
#predCorpus.cv <- Corpus(VectorSource(testdata$Comment))
#predMatrix.cv <- DocumentTermMatrix(predCorpus.cv, list(dictionary = Terms(matrix.cv)))
#predSparse.cv <- as.compressed.matrix(predMatrix.cv)
  
# Predicts
#resultModel.cv <- predict(modelMAXENT.cv, predSparse.cv[1:nrow(testdata),])
#result.cv <- cbind.data.frame(Comment = testdata, Probability = as.numeric(resultModel.cv[,3]))
#result.cv$Class <- lapply(result.cv$Probability, is.insult)

### Calculates accuracy and confusion matrix

#recall_accuracy(testdata$Insult[1:nrow(testdata)], result.cv$Probability)

#confusionMatrix(testdata$Insult, unlist(result.cv$Class))

