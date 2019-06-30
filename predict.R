
getNextWordNode <- function(parentNode, word) {
  #given a parent node, return the child node representing the given next word
  matchingNodes <- parentNode$children[Get(parentNode$children, function(node) list(word=node$word) == word)]
  numMatching <- length(matchingNodes)
  if (numMatching > 1){
    stop("Error: found multiple nodes matching given word")
  } else if(numMatching == 1) {
    node <- matchingNodes[[1]]
  } else {
    node <- NULL
  }
  node
}

predictExactSequence <- function(sequence, model) {
  #given a sequence of words (list)
  #return prediction for next word (node).
  #returns NULL if model cannot find a prediction for the given sequence
  
  #move down the tree based on provided word sequence
  node <- model    
  for (word in sequence){
    if (is.null(node)){
      break
    }
    node <- getNextWordNode(node, word)
  }
  node$children[[1]]
}


predictSequence <- function(sequence, model) {
  #given a sequence, predict the next word.
  #uses a back-off strategy:
  #if no prediction can be made for the whole squenence,
  #try again (recursively) with the first word ommitted from the sequence.
  #In the base case the prediction is made from a unigram model (no prior knowledge)
  
  nextWord <- predictExactSequence(sequence, model)
  while (is.null(nextWord)) {
    sequence <- sequence[-1]
    nextWord <- predictExactSequence(sequence, model)
  }
  list(word=nextWord$word, node=nextWord, sequence=sequence)
}

predictFromText <- function(text, model) {
  #given a string of text, make a prediction for the next word
  
  #convert text to df
  textDf <- linesToCorpusDf(list(text))
  textDf <- textDf[1:nrow(textDf)-1,]
  textDf
  predictSequence(textDf$word, model)
}
