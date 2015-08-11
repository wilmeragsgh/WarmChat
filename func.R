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

