## This is for the Coursera Data Science Class 3 project
## Charles 06/04/2017

# Set working directory
rm(list = ls())
setwd("C:/Study/Coursera/1 Data-Science/2 RStudio/3 Class3/FinalProject")

# Load activity labels and features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract data with mean and standard deviation
featuresWanted <- grep(".*mean.*|.*std.*",features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names <- gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names <- gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('\\()', '', featuresWanted.names)

# Load DataSet
trainX <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
trainY <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects,trainY,trainX)

testX <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testY <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects,testY,testX)

# Merge dataset and label
wholeData <- rbind(train,test)
colnames(wholeData) <- c("subject","activity",featuresWanted.names)

# Turn them into factors
wholeData$activity <- factor(wholeData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
wholeData$subject <- as.factor(allData$subject)

# Get the new values and writhe the tidy dataset
library(reshape2)
wholeData.melt <- melt(wholeData, id=c("subject","activity"))
wholeData.mean <- dcast(wholeData.melt, subject + activity ~ variable, mean)

write.table(wholeData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)