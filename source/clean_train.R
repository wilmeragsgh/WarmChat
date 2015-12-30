# arreglando la codificacion de los caracteres, con alguno de los siguientes

train$Comment <- iconv(enc2utf8(train$Comment),sub="byte")
#stri_encode(train$text, "", "UTF-8") # need stringi
#iconv(train$text,'ASCII','UTF-8')

# construir un corpus y especificar que se trata de un vector de caracteres
myCorpus <- Corpus(VectorSource(train$Comment))

# convertir a minúsculas
myCorpus <- tm_map(myCorpus, content_transformer(tolower))

# remover URLs
removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeURL))

# remover todo menos letras o espacios
removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeNumPunct))

# definiendo lista de stopwords
myStopwords <- stopwords('english')

# remover stopwords del corpus
myCorpus <- tm_map(myCorpus,removeWords, myStopwords)

# remover extra espacios
myCorpus <- tm_map(myCorpus, content_transformer(stripWhitespace))

# podar las palabras
myCorpus <- tm_map(myCorpus, content_transformer(stemDocument))

# creacion de matrices correspondientes
train.dtm <- DocumentTermMatrix(myCorpus)

# eliminacion de terminos con poca frecuencia
train.dtm <- removeSparseTerms(train.dtm,0.998)

# almacenamiento de nuevo docterm
save(train.dtm,train,file = 'cache/train.Rdata')
