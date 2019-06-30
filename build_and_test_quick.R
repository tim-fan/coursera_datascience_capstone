source('file_reading.R')
source('build_model.R')
source('model_testing.R')

set.seed(123)

# lines <- load10kRandomTweets()
lines <- readWholeFile('.//data//final//en_US//en_US.twitter.txt')

#split train and test
lines <- sample(lines)
splitIndex <- floor(length(lines) * 0.2)

testLines <- lines[1:splitIndex]
trainLines <- lines[(splitIndex+1):length(lines)]

testCorpus <- linesToCorpusDf(testLines)
trainCorpus <- linesToCorpusDf(trainLines)

rm(lines)
rm(trainLines)
rm(testLines)

minutesToRun = 30
frequencyLimit = 1000
print('building model')
model <- createModel(trainCorpus, minutesToRun = minutesToRun, frequencyLimit = frequencyLimit)
print('testing model')
accuracy <- runNTests(100, model, trainCorpus) * 100
print("")
print("Trial:")
print(paste(c("minutesToRun:"), minutesToRun))
print(paste(c("frequencyLimit:"), frequencyLimit))
print(paste(c("accuracy:"), accuracy))
