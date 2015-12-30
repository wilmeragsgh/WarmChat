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
                               "Decision Trees" = "tree",
                               "Random Forest" = "forests"),inline = T)),
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
                textInput("entry", "",value = 'Please see \'About\' before...')
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
          helpText(HTML("<p>Built using R & <a href = \"http://rstudio.com/shiny
                        /\">Shiny</a>.<p>Source code available on <a href =\"
                        https://github.com/wilmeragsgh/WarmChat/tree/
                        text_mining_assignament\">GitHub</a>."))
        )
      )
    )
  )
  ),tabPanel("About",
             div(
             navlistPanel(
               tabPanel("Recommendations", 
                        div(
                        h3("Remember that:"),
                        tags$li("Every model you check vote, but it's only 
               				         necessarily that one say your flaming."),
                        tags$li("We just understand english(for now)."),
                        tags$li("We don't get the question structure so
               				         if you ment some, we get just the words that 
               				         contains(for now)."),
                        tags$li("We don't understand sarcasm."),
                        tags$li("The models we use need at least 4 different
                                words per message."),
                        tags$li("We don't recommend insulting but
               				         if going to do it, do it well(so we classify 
               				         better)."),
                        tags$li("We clean text before classify. See \'Cleaning\'
                                ."),
                        tags$li("We base on particular data for classifications.
                                See \'Training data info\'."),
                        class = 'tabsinfo'
               )),
               tabPanel("Cleaning",
                        div(
                        h3("This is what we do for cleaning text(in order):"),
                        tags$li("Remove urls."),
                        tags$li("Remove repeated characters, 
                                it means we transform: good -> god... Sorry."),
                        tags$li("Isolate . , and ? from text."),
                        tags$li("Transform numbers or signs that maybe letters, 
                                for example: h1 -> hi or & -> and."), 
                        tags$li('Tolower text.'),
                        tags$li('Remove punctuation.'),
                        tags$li('Remove numbers.'),
                        tags$li('Remove multiple spaces.'),
                        class = 'tabsinfo'
               )),
               tabPanel("Training data info",
                        div(
                        h3("Notes"),
                        tags$li("We use the dataset provided in this page: \n
                                https://www.kaggle.com/c/detecting-insults-in-
                                social-commentary for training our models."),
                        class = 'tabsinfo'
               ))
             ),class = 'tabs'
             )
))
)