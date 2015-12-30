tree.label.fixed <- ifelse(train$Insult == 1, 1,-1)
train.container.tree <- create_container(train.dtm,tree.label.fixed,trainSize = 1:5500,virgin = F)
tree.model <- train_model(train.container.tree,'TREE')
c_matrix <- edit(create_matrix) ## modify line 42 and replace 'Acronym' with 'acronym':

tree_predict <- function(txt){
  test.data <- list(txt)
  test.matrix <- c_matrix(test.data, originalMatrix=train.dtm)
  test.container <- create_container(test.matrix, labels=0, testSize=1, virgin=FALSE)
  prediction <- classify_model(test.container, tree.model)
  ifelse(as.numeric(levels(prediction$TREE_LABEL)) == -1,0,1)
}
# Save model:
# save(tree.model,c_matrix,tree_predict,file = 'cache/tree_model.Rdata')

# Measuring error:
# r <- c()
# for(i in 1:length(train$Comment)){
#	 r[i]=tree_predict(as.character(train$Comment[i]))
# }
# train1 <-cbind(train,tree =r)
# table(train1$Insult,train1$tree)
# library("caret")
# confusionMatrix(train1$Insult,train1$tree)