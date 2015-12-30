sparse.train.dtm <- as.compressed.matrix(train.dtm)
maxent.model <- maxent(sparse.train.dtm, train$Insult)
c_matrix <- edit(create_matrix) ## modify line 42 and replace 'Acronym' with 'acronym':

maxent_predict <- function(txt){
  test.data <- list(txt)
  test.matrix <- c_matrix(test.data, originalMatrix=train.dtm)
  sparse.test.matrix <- as.compressed.matrix(test.matrix)
  # Predicts
  resultModel <- predict(maxent.model, sparse.test.matrix)
  as.numeric(resultModel[,1])
}
# Save model:
# save(maxent.model,c_matrix,maxent_predict,file = 'cache/maxent_model.Rdata')

# Measuring error:
#r <- c()
#for(i in 1:length(train$Comment)){
#  r[i]=maxent_predict(train$Comment[i])
#}
#train1 <-cbind(train,maxent =r)
#table(train1$Insult,train1$maxent)
#library("caret")
#confusionMatrix(train1$Insult,train1$maxent)
