bigram_predict <- function(comm){
	you_var <-c("you","your","ur","u","youre")
	no_var <- c("not","no","dont","arent")

	comm <- cleanComm(comm)
	comm <- splitting(comm)
	
	if(sum(comm %in% no_var)>0){
		no_pos <- min(which(comm %in% no_var))
		comm[no_pos]<-"not"
		for(i in (no_pos+1):length(comm)){
			comm[i] <- paste(comm[no_pos],comm[i],sep="-")
		}
	}
	insult <- 0
	you_badword<- paste("you",badwords,sep= "-")
	
	if(sum(comm %in% you_var)>0){
		you_pos <- min(which(comm %in% you_var))
		comm[you_pos]<-"you"
		for(i in (you_pos+1):length(comm)){
			comm[i] <- paste(comm[you_pos],comm[i],sep="-")
		}
		if(sum(comm %in% you_badword)>0){
			insult <- insult + 1
		}
	}
	
	if(sum(comm %in% badwords)>0){
		insult <- insult + 1
	}
	
	if(insult>0){
		note <- 1
	}else{
		note <- 0
	}
	
	note
}
# save(bigram_predict,file = "models/ngramFit.Rdata")
r <- c()
for(i in 1:length(train$Comment)){
  r[i]=bigram_predict(train$Comment[i])
}
train1 <-cbind(train,bigram =r)
table(train1$Insult,train1$bigram)
library("caret")
confusionMatrix(train1$Insult,train1$maxent)