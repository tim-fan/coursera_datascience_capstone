


readNRandomLines <- function(filepath, nLines) {
  #Return nLines randomly selected from given file
  set.seed(123) #for repeatable sampling
  
  countLines <- function(filepath) {
    lineCount = 0
    con = file(filepath, "r")
    while ( TRUE ) {
      line = readLines(con, n = 1)
      if ( length(line) == 0 ) {
        break
      }
      lineCount = lineCount + 1
    }
    
    close(con)
    lineCount
  }
  
  nLinesInFile = countLines(filepath)
  linesToKeep = sample(nLinesInFile, nLines, replace=F)
  keptLines = list()
  con = file(filepath, "r")
  
  for (iLine in 1:nLinesInFile)  {
    line = readLines(con, n = 1)
    if (iLine %in% linesToKeep) {
      keptLines = c(keptLines, line)
    }
  }
  close(con)
  keptLines
}

readWholeFile <- function(filepath) {
  con = file(filepath, "r")
  lines <- readLines(con)
  close(con)
  lines
}

load1kRandomTweets <- function() {
  readRDS(file='./data/subsets/enUsTwitter1kSubset.rds')
}