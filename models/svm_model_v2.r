library('RTextTools')
library('tm')
train$Insult <- ifelse(train$Insult == 1, 1,-1)
container <- create_container(matrix,train$Insult,trainSize = 1:5500,virgin = F)
model <- train_model(container,'SVM',kernel = 'linear',cost = 1)
## modify line 42 and replace 'Acronym' with 'acronym':
c_matrix <- edit(create_matrix) 

svm_predict_v2 <- function(txt){
  predictionData <- list(txt)
  predMatrix <- c_matrix(predictionData,, originalMatrix=matrix)
  predictionContainer <- create_container(predMatrix, labels=0, testSize=1, virgin=FALSE)
  results <- classify_model(predictionContainer, model)
  results
  as.numeric(levels(results$SVM_LABEL))
}

?factor
svm_predict_v2('love')
