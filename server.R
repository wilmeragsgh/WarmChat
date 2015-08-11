source("libs.R")
source("load.R")
source("func.R")
source("clean.R")

# Globally define a place where all users can share some reactive data.
vars <- reactiveValues(chat=NULL, users=NULL)

#' Get the prefix for the line to be added to the chat window. Usually a newline
#' character unless it's the first line.
linePrefix <- function(){
  if (is.null(isolate(vars$chat))){
    return()
  }
  return("<br />")
}


shinyServer(function(input, output, session) {
  # Create a spot for reactive variables specific to this particular session
  sessionVars <- reactiveValues(username = "")
  
  # When a session is ended, remove the user and note that they left the room. 
  session$onSessionEnded(function() {
    isolate({
      vars$users <- vars$users[vars$users != sessionVars$username]
      vars$chat <- c(vars$chat, paste0(linePrefix(),
                     tags$span(class="user-exit",
                       sessionVars$username,
                       "left the room.")))
    })
  })
  
  # Observer to handle changes to the username
  observe({
    if(input$sendU < 1){
      # The code must be initializing, b/c the button hasn't been clicked yet.
      return()
    }

      # A previous username was already given
      isolate({
        if (input$user == sessionVars$username || input$user == ""){
          # No change. Just return.
          return()
        }
    
        # Updating username      
        # First, remove the old one
        vars$users <- vars$users[vars$users != sessionVars$username]
        
        # Note the change in the chat log
        vars$chat <<- c(vars$chat, paste0(linePrefix(),
                                          tags$span(class="user-change",
                                                    paste0("Ha llegado:","\"", input$user, "\""))))
        
        # Now update with the new one
        sessionVars$username <- input$user
      })
    # Add this user to the global list of users
    isolate(vars$users <- c(vars$users, sessionVars$username))
  })
  
  # Keep the username updated with whatever sanitized/assigned username we have
  observe({
    updateTextInput(session, "user", 
                    value=sessionVars$username)    
  })
  
  # Keep the list of connected users updated
  output$userList <- renderUI({
    tagList(tags$ul( lapply(vars$users, function(user){
      return(tags$li(user))
    })))
  })
  
  # Listen for input$send changes (i.e. when the button is clicked)
  observe({
    if(input$send < 1){
      # The code must be initializing, b/c the button hasn't been clicked yet.
      return()
    }
    isolate({
    	# important code
    	you_var <-c("you","your","ur","u","youre")
    	no_var <- c("not","no","dont","arent")
    	
    	comm <- input$entry
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
    		note <- "flame"
    	}else{
    		note <- ""
    	}
    	# important code above
    	# Add the current entry to the chat log.
      if(sessionVars$username == ""){
        vars$chat <<- c(vars$chat, 
                        paste0(linePrefix(),
                               tags$span(class="username",
                                         tags$abbr(title=Sys.time(), "Anonymous")
                               ),
                               ": ",
                               tagList(input$entry),tags$span(class="note"," ",note)))
      }else {
      vars$chat <<- c(vars$chat, 
                      paste0(linePrefix(),
                        tags$span(class="username",
                          tags$abbr(title=Sys.time(), sessionVars$username)
                        ),
                        ": ",
                        tagList(input$entry),tags$span(class="note"," ",note)))}
    })
    # Clear out the text entry field.
    updateTextInput(session, "entry", value="")
  })
  
  # Dynamically create the UI for the chat window.
  output$chat <- renderUI({
    if (length(vars$chat) > 500){
      # Too long, use only the most recent 500 lines
      vars$chat <- vars$chat[(length(vars$chat)-500):(length(vars$chat))]
    }
    # Save the chat object so we can restore it later if needed.
    saveRDS(vars$chat, "app/chat.Rds")
    
    # Pass the chat log through as HTML
    HTML(vars$chat)
  })
})
