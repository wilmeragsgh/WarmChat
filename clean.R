cleanComm<-function(word){
  
	enc2utf8(word)
  
  ## @knitr removing_reps
  gsub("[:alnum:]{2,}","\\1",word)
  
  ## @knitr isolating_punc
  gsub(","," , ",word)
  gsub("."," . ",word)
  gsub("?"," ? ",word)
  
  ## @knitr numstolett
  gsub("1","i",word)
  gsub("5","s",word)
  gsub("4","for",word)
  gsub("1","i",word)
  gsub("&","and",word)
  gsub("$","s",word)
  gsub("0","o",word)
  
    
  ## @knitr to_lowering
  word<- tolower(word)

  ## @knitr removing_punctuations
  punctuseless<- c("!"," \"", "#", "$", "\%" ,"\&","\'","(", ")","*","+","-", "/",":",";","<","=", ">", "@" ,"[" ,"\\" ,"]", "^","_", "`" ,"{" ,"|" ,"}","~")
  for(i in punctuseless){
    gsub(i,"",word)
  }
  
  ## @knitr removing_number
  word <- removeNumbers(word)

  ## @knitr removing_whitespaces
  wordn <- stripWhitespace(word)

  return(as.character(wordn))
}

# Preprocesamiento de los datos 
#cleanSet<- function(word){
  
  ## @knitr encoding_input
#  enc2utf8(word)
  
  ## @knitr removing_html
#  gsub("<.*?>", "", word)
  
  ## @knitr removing_urls
#  gsub("http[[:alnum:][:punct:]]*", "", word)
  
  ## @knir removing_rep
#  word <- paste(rle(strsplit(word, "")[[1]])$values, collapse="")
  
  ## @knitr to_lowering
#  word<- tolower(word)
  
  ## @knitr removing_punctuations
#  word<- removePunctuation(word)
  
  ## @knitr removing_number
#  word <- removeNumbers(word)
  
  ## @knitr removing_whitespaces
#  wordn <- stripWhitespace(word)
  
#  return(as.character(wordn))
#}

## Definicion de una funcion encargada de generar una arreglo con las palabras pertencientes al mismo comentario
splitting <-function(data){
  val <- matrix()
  j <- 1
  for(i in data){
    val <- unlist(strsplit(as.character(i), "[ ]"))    
    j <- j+1
  }
  val
}
## @knitr end_chunk
