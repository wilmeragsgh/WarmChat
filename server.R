source("source/library.R")
source("source/load_cache.R")

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
                                                    paste0("Ha llegado:","\"", 
                                                           input$user, "\""))))
        
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
    	# important code:
      # checking check buttoms:
      predictions <- c()
      txt <- cleanComm(input$entry)
      for(i in input$which_model){
        if(i == 'svm'){
          predictions <- c(predictions,svm_predict(txt))
        }
        if(i == 'maxent'){
          predictions <- c(predictions,maxent_predict(txt))
        }
        if(i == 'tree'){
          predictions <- c(predictions,tree_predict(txt))
        }
        if(i == 'forests'){
          predictions <- c(predictions,rf_predict(txt))
        }
      }
      # any classifier say it was a flame:
      if (sum(predictions) > 0){
        res <- 'flame'
      } else {
        res <- ''
      }
    	# important code above
    	# Add the current entry to the chat log.
      if(sessionVars$username == ""){
        vars$chat <<- c(vars$chat, 
                        paste0(linePrefix(),
                               tags$span(class="username",
                                         tags$abbr(title=Sys.time(), 
                                                   "Anonymous")
                               ),
                               ": ",
                               tagList(input$entry),tags$span(class="note"," ",
                                                              res)))
      }else {
      vars$chat <<- c(vars$chat, 
                      paste0(linePrefix(),
                        tags$span(class="username",
                          tags$abbr(title=Sys.time(), sessionVars$username)
                        ),
                        ": ",
                        tagList(input$entry),tags$span(class="note"," ",res)))}
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
    saveRDS(vars$chat, "configuration/chat.Rds")
    
    # Pass the chat log through as HTML
    HTML(vars$chat)
  })
})
