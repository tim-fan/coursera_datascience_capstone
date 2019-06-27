getRandomTest <- function(corpus) {
  #return a random sequence (test input) and a next word (correct output) from the given corpus
  nextWord <- corpus[sample(nrow(corpus)-1, 1),]
  
  #throw out cases where nextWord = EOL
  while (nextWord$word == eolToken){
    nextWord <- corpus[sample(nrow(corpus)-1, 1),]
  }
  
  #seek back in the corpus to the previous eol token
  sequenceStartIndex <- nextWord$index
  while ((sequenceStartIndex > 1) & (corpus$word[sequenceStartIndex] != eolToken)) {
    sequenceStartIndex <- sequenceStartIndex-1
  }
  
  sequence <- corpus$word[
    (sequenceStartIndex+1):(nextWord$index-1)
  ]
  list(nextWord=nextWord, sequence=sequence)
}

runRandomTest <- function(model, corpus) {
  test <- getRandomTest(corpus)
  correct <- predictSequence(test$sequence, model)$word == test$nextWord$word  
  correct
}

runNTests <- function(n, model, corpus){
  set.seed(123)
  #run a given number of tests on the given model, 
  #where tests are extracted at random from the given corpus
  testResults <- sapply(1:n, function(i) {runRandomTest(model, corpus)})
  mean(testResults)
}