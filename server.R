#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("predict.R")
source("build_model.R")

# model <- loadModel("model_30min_1000freq.RData")
# model <- loadModel("model_800tweets_f5.RData")
model <- loadModelCsv("model_30min_1000freq.csv")

noMatchPredictionTree <- prettyFormat(model)
print("loaded")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  observe({
      if(!is.null(input$lastkeypresscode)) {
          if(input$lastkeypresscode == 13){
              prediction <- predictFromText(isolate(input$text_in), model)
              output$predicted_word <- renderText({prediction$word})

              if (length(prediction$sequence) == 0) {
                matchedSequence <- "No Match"
                predictionTree <- noMatchPredictionTree
              }
              else {
                matchedSequence <- prediction$sequence
                predictionTree <- prettyFormat(prediction$node$parent)
              }
              print(matchedSequence)
              output$matched_sequence <- renderText(matchedSequence)
              output$prediction_tree <- renderText(predictionTree)
              
      }}
  })
})
