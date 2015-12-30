library(shiny)

shinyUI( navbarPage("Text Mining Project",
  tabPanel("Chat Room",
  bootstrapPage(
    # We'll add some custom CSS styling -- totally optional
    includeCSS("configuration/shinychat.css"),
    
    # And custom JavaScript -- just to send a message when a user hits "enter"
    # and automatically scroll the chat window for us. Totally optional.
    includeScript("configuration/sendOnEnter.js"),
    
    div(
      # Setup custom Bootstrap elements here to define a new layout
      class = "container-fluid", 
      div(class = "row-fluid",
          # Set the page title
          tags$head(tags$title("WarmChat")),
          
          # Create the header
          div(class="span6",
              h1("WarmChat"), 
              h4("Friendly than IRC...")),
          div(class = 'span7',
          checkboxGroupInput("which_model", "Actives classifiers:",
                             c("SVM" = "svm",
                               "Maxent" = "maxent",
                               "Empirical bigram" = "bigram"),inline = T)),
          div(class="span6", id="play-nice",
            "Be a decent human being."
          )
          
      ),
      # The main panel
      div(
        class = "row-fluid", 
        mainPanel(
          # Create a spot for a dynamic UI containing the chat contents.
          uiOutput("chat"),
          
          # Create the bottom bar to allow users to chat.
          fluidRow(
            div(class="span10", style= 'padding-left: 2.5%;',
                textInput("entry", "")
            ),
            div(class = 'span10', style = 'margin-left:34.5%;',
                actionButton("send", "Send"))
          )
        ),
        # The right sidebar
        sidebarPanel(
          # Let the user define his/her own ID
          textInput("user", "Your username", value=""),
          tags$hr(),
          div(class="span3 center",
              actionButton("sendU", "Notify arrival")
          ),
          h5("Connected Users"),
          # Create a spot for a dynamic UI containing the list of users.
          uiOutput("userList"),
          tags$hr(),
          helpText(HTML("<p>Built using R & <a href = \"http://rstudio.com/shiny/\">Shiny</a>.<p>Source code available <a href =\"https://github.com/wilmeragsgh/Flame_Detector_Chat\">on GitHub</a>."))
        )
      )
    )
  )
  ),tabPanel("What we do", 
             navlistPanel(
               "Tasks",
               tabPanel("Cleaning",
                        h3("To-do's"),tags$li("Tolowering all words"),tags$li("Removing punctuations marks"),tags$li("Removing numbers"),tags$li("Stripping white spaces")
               ),
               tabPanel("Information Retrieval",
                        h3("To-do's"),tags$li("Definning the necessarily datasets for the")
               ),
               tabPanel("Classification",
                        h3("To-do's"),tags$li("Creating bi-grams based on seconds pronouns and negations-words")
                        
               ),"-----",
               tabPanel("Limits",
               				 h3("Some Recommendations"),tags$li("Our first(for documentations) limits is the language,so we can understand only english(for now)"),tags$li("We don't get the question structure so if you ment some, we get just the words that contains(for now)"),tags$li("Our model it's a SUPER-SARCASM_DETECTOR(not). . . So we classify only literality"),tags$li("Although we don't recommend insulting if going to do it, do it well(so we classify better)")
               				 
               )
             )
))
)