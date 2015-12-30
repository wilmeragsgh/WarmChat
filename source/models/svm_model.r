svm.label.fixed <- ifelse(train$Insult == 1, 1,-1)
train.container.svm <- create_container(train.dtm,svm.label.fixed,trainSize = 1:5500,virgin = F)
svm.model <- train_model(train.container.svm,'SVM',kernel = 'linear',cost = 1)
c_matrix <- edit(create_matrix) ## modify line 42 and replace 'Acronym' with 'acronym':

svm_predict <- function(txt){
  test.data <- list(txt)
  test.matrix <- c_matrix(test.data, originalMatrix=train.dtm)
  test.container <- create_container(test.matrix, labels=0, testSize=1, virgin=FALSE)
  prediction <- classify_model(test.container, svm.model)
  ifelse(as.numeric(levels(prediction$SVM_LABEL)) == -1,0,1)
}
# Save model:
# save(svm.model,c_matrix,svm_predict,file = 'cache/svm_model.Rdata')

# Measuring error:
# r <- c()
# for(i in 1:length(train$Comment)){
#	 r[i]=svm_predict(as.character(train$Comment[i]))
# }
# train1 <-cbind(train,svm =r)
# table(train1$Insult,train1$svm)
# library("caret")
# confusionMatrix(train1$Insult,train1$svm)