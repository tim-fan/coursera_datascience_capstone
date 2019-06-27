set.seed(123)

lines <- readWholeFile('.//data//final//en_US//en_US.twitter.txt')

#split train and test
lines <- sample(lines)
splitIndex <- floor(length(lines) * 0.2)

testLines <- lines[1:splitIndex]
trainLines <- lines[splitIndex+1:length(lines)]

testCorpus <- linesToCorpusDf(testLines)
trainCorpus <- linesToCorpusDf(trainLines)


minutesToRun = 10
frequencyLimit = 1000
model <- createModel(trainCorpus, minutesToRun = 2, frequencyLimit = 1000)
accuracy <- runNTests(1000, model, trainCorpus) * 100
print("")
print("Trial:")
print(paste(c("minutesToRun:"), minutesToRun))
print(paste(c("frequencyLimit:"), frequencyLimit))
print(paste(c("accuracy:"), accuracy))


minutesToRun = 20
frequencyLimit = 1000
model <- createModel(trainCorpus, minutesToRun = 2, frequencyLimit = 1000)
accuracy <- runNTests(1000, model, trainCorpus) * 100
print("")
print("Trial:")
print(paste(c("minutesToRun:"), minutesToRun))
print(paste(c("frequencyLimit:"), frequencyLimit))
print(paste(c("accuracy:"), accuracy))


minutesToRun = 40
frequencyLimit = 1000
model <- createModel(trainCorpus, minutesToRun = 2, frequencyLimit = 1000)
accuracy <- runNTests(1000, model, trainCorpus) * 100
print("")
print("Trial:")
print(paste(c("minutesToRun:"), minutesToRun))
print(paste(c("frequencyLimit:"), frequencyLimit))
print(paste(c("accuracy:"), accuracy))


minutesToRun = 20
frequencyLimit = 10
model <- createModel(trainCorpus, minutesToRun = 2, frequencyLimit = 1000)
accuracy <- runNTests(1000, model, trainCorpus) * 100
print("")
print("Trial:")
print(paste(c("minutesToRun:"), minutesToRun))
print(paste(c("frequencyLimit:"), frequencyLimit))
print(paste(c("accuracy:"), accuracy))


minutesToRun = 20
frequencyLimit = 100
model <- createModel(trainCorpus, minutesToRun = 2, frequencyLimit = 1000)
accuracy <- runNTests(1000, model, trainCorpus) * 100
print("")
print("Trial:")
print(paste(c("minutesToRun:"), minutesToRun))
print(paste(c("frequencyLimit:"), frequencyLimit))
print(paste(c("accuracy:"), accuracy))


minutesToRun = 20
frequencyLimit = 1000
model <- createModel(trainCorpus, minutesToRun = 2, frequencyLimit = 1000)
accuracy <- runNTests(1000, model, trainCorpus) * 100
print("")
print("Trial:")
print(paste(c("minutesToRun:"), minutesToRun))
print(paste(c("frequencyLimit:"), frequencyLimit))
print(paste(c("accuracy:"), accuracy))

minutesToRun = 20
frequencyLimit = 1000
model <- createModel(trainCorpus, minutesToRun = 2, frequencyLimit = 1000)
accuracy <- runNTests(1000, model, trainCorpus) * 100
print("")
print("Trial:")
print(paste(c("minutesToRun:"), minutesToRun))
print(paste(c("frequencyLimit:"), frequencyLimit))
print(paste(c("accuracy:"), accuracy))


minutesToRun = 5*60
frequencyLimit = 10
model <- createModel(trainCorpus, minutesToRun = 2, frequencyLimit = 1000)
accuracy <- runNTests(1000, model, trainCorpus) * 100
print("")
print("Trial:")
print(paste(c("minutesToRun:"), minutesToRun))
print(paste(c("frequencyLimit:"), frequencyLimit))
print(paste(c("accuracy:"), accuracy))