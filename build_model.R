library(dplyr)
library(tidytext)
library(data.tree)
library(stringr)

sosToken <- 'start-of-sequence' #'root' token, representing start of a sequence
eolToken <- 'eol' #token to capture end of line

linesToCorpusDf <- function(lines) {
  #Given list of lines (one tweet, blog post, etc per line)
  #return a dataframe of words represnting the whole corpus
  #(one word per line, with an index of where that word occurred in the corpus)
  text <- unlist(lines)
  
  text_df <- tibble(line = 1:length(text), text = text)
  text_df <- mutate(text_df, text = paste(text, eolToken))
  
  corpus <- text_df %>%
    unnest_tokens(word, text) %>%
    select(word)
  
  corpus$index <- 1:nrow(corpus)
  
  corpus
}

getToyCorpus <- function(){
  #return a toy example corpus which can be used to quickly check 
  #functionality of downstream proccessing
  tibble(
    word = c('a', 'b', 'c', 'a', 'b', 'c', 'a', 'c', 'a', 'c', eolToken),
    index = 1:11
  )
}

# word prediction model will be a tree structure, with each node
#representing a word in a sequence, and the path through nodes in the tree
#representing the sequence as a whole
# node properties:
#   word - the word that this node represents in the sequence defined by the tree structure
#   occurrences - indices of the occurrences of this word/sequence in the defining corpus
#   nOccurrences - the number of occurrences of this word/sequence
#   sequence - the full sequence of words that this node represents

makeRootNode <- function(corpus){
  #given a dataframe of words, return a root node
  #representing the start of all word sequences in that dataframe
  rootNode <- Node$new(UUIDgenerate())
  rootNode$word <- sosToken
  rootNode$occurrences <- 0:(nrow(corpus)-1)
  rootNode$nOccurrences <- length(rootNode$occurrences)
  rootNode$sequence <- ''
  rootNode
}

printModel <- function(node){
  #print given node and decendents
  print(
    ToDataFrameTree(node, 'word', 'nOccurrences', 'sequence', 'level')
  )
}

prettyFormat <- function(node){
  #return a text representation of the node
  treeDf <- ToDataFrameTree(node, 'levelName', 'word', 'name') %>%
    transmute(prettyPath = str_replace(levelName, name, word)) %>% head()
  
  paste(treeDf$prettyPath, collapse = "\n")
}

expandNode <- function(node, corpus, frequencyLimit) {
  # for a given node (representing a word/sequence)
  # determine which words come next in the corpus
  
  newNodes <- list()
  
  getOccurrences <- function(node, corpus) {
    #return a list of indices indicating where the sequence represented by given node occurs in the corpus
    if (!is.null(node$occurrences)){
      #if already stored in the node, just return the value
      occurrences <- node$occurrences
    }
    else {
      #otherwise, lookup based on parent occurences
      parentOccurences <- getOccurrences(node$parent)
      nextWords <- corpus[parentOccurences+1,]
      occurrences <- filter(nextWords, word==node$word)$index
      node$occurrences <- occurrences
    }
    occurrences
  }
  
  nextWordIndices <- getOccurrences(node, corpus) + 1
  nextWords <- corpus[nextWordIndices,]
  
  #parentPath <- node$absPath
  parentSequence <- node$sequence
  wordCounts <- nextWords %>%
    count(word) %>%
    rename(nOccurrences=n) %>%
    arrange(desc(nOccurrences))
  
  wordCounts <- filter(wordCounts, nOccurrences >= frequencyLimit)
  wordCounts <- filter(wordCounts, word != eolToken)
  
  #create dataframe representing new nodes
  if (nrow(wordCounts) > 0)
  {
    newNodes <- as.Node(
      wordCounts %>%
        mutate(name = replicate(nrow(wordCounts), UUIDgenerate())) %>%
        # mutate(name=as.character(row_number() + 1)) %>% 
        mutate(pathString = paste0('./', name)) %>% 
        mutate(sequence = paste(parentSequence, word, sep=' '))
    )$children
    
    for (newNode in newNodes){
      node$AddChildNode(newNode)
    }
  }
  else
  {
    newNodes = list()
  }
  
  newNodes
}

# in the process of building the model (tree), a frontier is maintained, representing a priority queue of nodes to expand next
# The frontier is a tibble, with each row containing a node, and the number of occurences for that node
makeInitialFrontier <- function(rootNode){
  tibble(
    node = c(rootNode), 
    nOccurrences=rootNode$nOccurrences
  )
}

expandFrontier <- function(frontier, corpus, frequencyLimit) {
  #expand next node:
  # take the next most common sequence in the frontier..                  
  nodeToExpand <- frontier$node[[1]]
  
  # remove it from the frontier...
  frontier <- frontier[-1,]
  
  # expand it..
  newNodes <- expandNode(nodeToExpand, corpus, frequencyLimit)
  
  # add new nodes to frontier
  if (length(newNodes) > 0) {
    frontier <- bind_rows(frontier, tibble(node = newNodes, nOccurrences = sapply(newNodes, function(n) n$nOccurrences)))
    
    #keep frontier sorted by number of occurences
    frontier <- arrange(frontier, desc(nOccurrences))        
  }
  
  frontier
}

createFullyExpandedModel <- function(corpus) {
  rootNode <- makeRootNode(corpus)
  frontier <- makeInitialFrontier(rootNode)
  while (nrow(frontier) > 0) {
    frontier <- expandFrontier(frontier, corpus, frequencyLimit = 0)
  }
  rootNode
}

createModel <- function(corpus, minutesToRun, frequencyLimit) {
  #expand model for specified amount of time using specified frequency limit
  #returns the model (root node) and a record of expansion history 
  startTime <- Sys.time()
  rootNode <- makeRootNode(corpus)
  frontier <- makeInitialFrontier(rootNode)
  expansionHistory <- tibble(iteration=0, elapsedSeconds=0, frontierSize=1)
  
  while ((nrow(frontier) > 0) && ( as.double(Sys.time() - startTime, units="mins") < minutesToRun)){
    frontier <- expandFrontier(frontier, corpus, frequencyLimit)
    print(nrow(frontier))
  }
  rootNode
}

saveModel <- function(model, filename){
  #save model in the given file
  save(model, file=filename)
}

loadModel <- function(filename){
  load(filename)
  model
}

saveModelCsv <- function(model, filename){
  df <- ToDataFrameTree(model, 'pathString', 'word')
  write.csv2(df, file=filename)
}

loadModelCsv <- function(filename){
  df <- read.csv2(filename, stringsAsFactors = FALSE)
  as.Node(df)
}