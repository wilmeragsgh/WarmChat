cleanComm<-function(word){
	enc2utf8(word)
  ## @knitr removing_urls
  gsub("http[[:alnum:][:punct:]]*", "", word)
  ## @knitr removing_reps
  word <- gsub('([[:alpha:]])\\1+', '\\1', word)
  ## @knitr isolating_punc
  word <- gsub(","," , ",word,fixed = T)
  word <- gsub("."," . ",word,fixed = T)
  word <- gsub("?"," ? ",word,fixed = T)
  ## @knitr numstolett
  word <- gsub("1","i",word)
  word <- gsub("5","s",word)
  word <- gsub("4","for",word)
  word <- gsub("1","i",word)
  word <- gsub("&","and",word)
  word <- gsub("$","s",word)
  word <- gsub("0","o",word)
  word <- gsub('3','e',word)
  ## @knitr to_lowering
  word<- tolower(word)

  ## @knitr removing_punctuations
  word <- removePunctuation(word)
  ## @knitr removing_number
  word <- removeNumbers(word)
  ## @knitr removing_whitespaces
  word <- stripWhitespace(word)
  return(as.character(word))
}

## Definicion de una funcion encargada de generar una arreglo con las palabras pertencientes al mismo comentario
#splitting <-function(data){
#  val <- matrix()
#  j <- 1
#  for(i in data){
#    val <- unlist(strsplit(as.character(i), "[ ]"))    
#    j <- j+1
#  }
#  val
#}
## @knitr end_chunk
