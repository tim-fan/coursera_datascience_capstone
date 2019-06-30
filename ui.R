#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("cerulean"),
    
    #capture key codes
    tags$script(' $(document).on("keydown", function (e) {
                                                  Shiny.onInputChange("lastkeypresscode", e.keyCode);
                                                  });
                                                  '),

    # Application title
    titlePanel("Next-Word Predictor"),

    # Show a plot of the generated distribution
    mainPanel(
        p("Type a word or phrase and hit <enter> to get a prediction for the next word"),
        h4("Text input:"),
        textInput(
            "text_in", NULL, value = "", width = NULL,
                  placeholder = NULL
        ),
        h4("Prediction for next word:"),
        verbatimTextOutput("predicted_word"),
        
        h4("Prediction details:"),
        p("Matched sequence:"),
        verbatimTextOutput("matched_sequence"),
        p("Common following sequences:"),
        verbatimTextOutput("prediction_tree")
    )
))
