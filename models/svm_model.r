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

library(RTextTools)
library(tm)

data <- read.csv('/home/obama/Desktop/MD/train.csv', row.names = NULL, stringsAsFactors = FALSE)
data <- data[-2]

# Create the document term matrix
matrix <- create_matrix(data$Comment)

# Configure the training data
container <- create_container(matrix, data$Insult, trainSize = 1:2799, virgin = FALSE)
#Error in x$nrow : $ operator is invalid for atomic vectors

# Train a SVM Model
modelSVM <- train_model(container, "SVM", kernel = "linear", cost = 1)

# Test data
testdata <- list("You are a fucking bitch", "Hellow World")

# Create a prediction document term matrix
predMatrix <- create_matrix(testdata, originalMatrix = matrix, weighting = tm::weightTfIdf)

# Create the corresponding container
predSize = length(testdata)
predContainer <- create_container(predMatrix, labels = rep(0,predSize), testSize = 1:predSize, virgin = FALSE)

# Predict
results <- classify_model(predContainer, modelSVM)
results


####################
#library(utils)
#remove.packages('RTextTools')
#install.packages('/home/obama/R/i686-pc-linux-gnu-library/3.2/RTextTools_1.4.0.tar.gz', repos = NULL, type="source")

#library(utils)
#remove.packages('tm')
#install.packages('/home/obama/R/i686-pc-linux-gnu-library/3.2/tm_0.5-10.tar.gz', repos = NULL, type="source")
