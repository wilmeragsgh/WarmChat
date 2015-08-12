# Incompatibilidades entre los paquetes RTextTools arrojarán alguno de los siguientes errores:
#     a. Error in if (attr(weighting, "Acronym") == ...
#     b. Error in x$nrow : $ operator is invalid for atomic vectors
#
# El primer error se soluciona modificando el código fuente de la función create_matrix
# tal como indican acá: https://groups.google.com/forum/#!topic/rtexttools-help/Drqr3Z897Mk
#
# Luego se genera el segundo error. Se intentó solucionar siguiendo los pasos planteados
# en: http://crimsoncoffee.blogspot.com/2015/07/dealing-with-package-incompatibilities.html
# Pero el error persiste. 
#
# Versión R.2.0

svm_predict <- function(testdata){
  # Create the document term matrix
  #matrix <- create_matrix(as.character(train$Comment))
  
  # Configure the training data
  #container <- create_container(matrix, train$Insult, trainSize = 1:2799, virgin = FALSE)
  #Error in x$nrow : $ operator is invalid for atomic vectors
  
  # Train a SVM Model
  # modelSVM <- train_model(container, "SVM", kernel = "linear", cost = 1)
  # Create a prediction document term matrix
  createMatrix <- function (textColumns, language = "english", minDocFreq = 1, 
                            maxDocFreq = Inf, minWordLength = 3, maxWordLength = Inf, 
                            ngramLength = 1, originalMatrix = NULL, removeNumbers = FALSE, 
                            removePunctuation = TRUE, removeSparseTerms = 0, removeStopwords = TRUE, 
                            stemWords = FALSE, stripWhitespace = TRUE, toLower = TRUE, 
                            weighting = weightTf) 
  {
    stem_words <- function(x) {
      split <- strsplit(x, " ")
      return(wordStem(unlist(split), language = language))
    }
    tokenize_ngrams <- function(x, n = ngramLength) return(rownames(as.data.frame(unclass(textcnt(x, 
                                                                                                  method = "string", n = n)))))
    control <- list(bounds = list(local = c(minDocFreq, maxDocFreq)), 
                    language = language, tolower = toLower, removeNumbers = removeNumbers, 
                    removePunctuation = removePunctuation, stopwords = removeStopwords, 
                    stripWhitespace = stripWhitespace, wordLengths = c(minWordLength, 
                                                                       maxWordLength), weighting = weighting)
    if (ngramLength > 1) {
      control <- append(control, list(tokenize = tokenize_ngrams), 
                        after = 7)
    }
    else {
      control <- append(control, list(tokenize = scan_tokenizer), 
                        after = 4)
    }
    if (stemWords == TRUE && ngramLength == 1) 
      control <- append(control, list(stemming = stem_words), 
                        after = 7)
    trainingColumn <- apply(as.matrix(textColumns), 1, paste, 
                            collapse = " ")
    trainingColumn <- sapply(as.vector(trainingColumn, mode = "character"), 
                             iconv, to = "UTF8", sub = "byte")
    corpus <- Corpus(VectorSource(trainingColumn), readerControl = list(language = language))
    matrix <- DocumentTermMatrix(corpus, control = control)
    if (removeSparseTerms > 0) 
      matrix <- removeSparseTerms(matrix, removeSparseTerms)
    if (!is.null(originalMatrix)) {
      terms <- colnames(originalMatrix[, which(!colnames(originalMatrix) %in% 
                                                 colnames(matrix))])
      weight <- 0
      if (attr(weighting, "acronym") == "tf-idf") 
        weight <- 1e-09
      amat <- matrix(weight, nrow = nrow(matrix), ncol = length(terms))
      colnames(amat) <- terms
      rownames(amat) <- rownames(matrix)
      fixed <- as.DocumentTermMatrix(cbind(matrix[, which(colnames(matrix) %in% 
                                                            colnames(originalMatrix))], amat), weighting = weighting)
      matrix <- fixed
    }
    matrix <- matrix[, sort(colnames(matrix))]
    gc()
    return(matrix)
  }
  save(modelSVM,matrix,createMatrix,file = "svmFit.Rdata")
  load("/models/svmFit.Rdata")
  
  predMatrix <- createMatrix(c(as.character(train$Comment),testdata), originalMatrix = matrix, weighting = tm::weightTfIdf)
  
  # Create the corresponding container
  predContainer <- create_container(predMatrix,trainSize = 1:7681,testSize = 7682)
  
  # Predict
  results <- classify_model(predContainer, modelSVM)
  results
}
# r <- c()
# for(i in 1:length(train$Comment)){
#	 r[i]=svm_predict(as.character(train$Comment[i]))
# }
# train1 <-cbind(train,svm =r)
# table(train1$Insult,train1$svm)
# library("caret")
# confusionMatrix(train1$Insult,train1$svm)