# Declaracion de funciones requeridas en el proyecto

## @knitr pre-proc
##Definición de una funcion encargada de la limpieza de los comentarios segun los siguientes criterios: -Caracteres de espaciado -Nombres de usuarios -Urls.
cleaning <-function(data, patterns, fix = F){
  patterns <- matrix(patterns,ncol=2, byrow = T) 
  npatt<- dim(patterns)[1]
  for(i in 1:npatt){
    data <- gsub(pattern = patterns[i,1],replacement = patterns[i,2],x = data,fixed = fix)
  }
  data
}
## @knitr end_chunk

## @knitr sep_pal
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

