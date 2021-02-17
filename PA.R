#######################################################################
#PA.R
#Prepares tidy data about wearable devices, according to Coursera's 
#Programming Assignment for "Getting and Cleaning Data" course
#Created by Ricardo Kahn, Feb, 17 2021
#######################################################################

#References data.table library
library(data.table)

#Loads the features and activity labels into data tables
features <- fread("features.txt")
activity.labels = fread("activity_labels.txt", col.names = c("code", "activity"))

#Loads the train and test databases into data tables
train <- data.table(fread("train/Y_train.txt", col.names = c("y")), 
                    fread("train/subject_train.txt", col.names = c("subject")), 
                    fread("train/X_train.txt", col.names = features$V2))

test <- data.table(fread("test/Y_test.txt", col.names = c("y")), 
                    fread("test/subject_test.txt", col.names = c("subject")), 
                    fread("test/X_test.txt", col.names = features$V2))

#Data shaping
all.data <- cbind(train, type = "train")
all.data <- rbind(all.data, cbind(test, type = "test"))
activities <- merge(all.data[,"y"], activity.labels, by.x = "y", by.y = "code")
all.data <- cbind(all.data, activity = activities[,activity])
train=NULL; test=NULL; features=NULL; activities=NULL; activity.labels=NULL
colToKeep <- c(grep("type|activity|subject", colnames(all.data)), grep("^(.*(mean|std).*$)", colnames(all.data)))

#Creates all.data data table
all.data <- subset(all.data, select=c(colToKeep))

#Creates summarized data table for item 5:
#From the data set in step 4, creates a second, independent tidy data set with 
#the average of each variable for each activity and each subject.
item.5 <- all.data[, lapply(all.data[,4:82],mean), by=list(activity, subject)]

