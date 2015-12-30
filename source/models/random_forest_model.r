rf.label.fixed <- ifelse(train$Insult == 1, 1,-1)
train.container.rf <- create_container(train.dtm,rf.label.fixed,trainSize = 1:5500,virgin = F)
rf.model <- train_model(train.container.rf,'RF',ntree = 3)
c_matrix <- edit(create_matrix) ## modify line 42 and replace 'Acronym' with 'acronym':

rf_predict <- function(txt){
  test.data <- list(txt)
  test.matrix <- c_matrix(test.data, originalMatrix=train.dtm)
  test.container <- create_container(test.matrix, labels=0, testSize=1, virgin=FALSE)
  prediction <- classify_model(test.container, rf.model)
  ifelse(as.numeric(levels(prediction$FORESTS_LABEL)) == -1,0,1)
}
# Save model:
# save(rf.model,c_matrix,rf_predict,file = 'cache/random_forest_model.Rdata')

# Measuring error:
# r <- c()
# for(i in 1:length(train$Comment)){
#	 r[i]=rf_predict(as.character(train$Comment[i]))
# }
# train1 <-cbind(train,rf =r)
# table(train1$Insult,train1$rf)
# library("caret")
# confusionMatrix(train1$Insult,train1$rf)