library(dplyr)
library(read.table)
#loading in data
filename <- "smartphones.csv"


if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  


if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#1) Merging
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
table <- cbind(Subject, Y, X)

#2
table_clean <- df %>% select(subject, code, contains("mean"), contains("std"))

#3
table_clean$code <- activities[table_clean$code, 2]

#4
names(table_clean)[2] = "activity"
names(table_clean)<-gsub("Acc", "Accelerometer", names(table_clean))
names(table_clean)<-gsub("Gyro", "Gyroscope", names(table_clean))
names(table_clean)<-gsub("BodyBody", "Body", names(table_clean))
names(table_clean)<-gsub("Mag", "Magnitude", names(table_clean))
names(table_clean)<-gsub("^t", "Time", names(table_clean))
names(table_clean)<-gsub("^f", "Frequency", names(table_clean))
names(table_clean)<-gsub("tBody", "TimeBody", names(table_clean))
names(table_clean)<-gsub("-mean()", "Mean", names(table_clean), ignore.case = TRUE)
names(table_clean)<-gsub("-std()", "STD", names(table_clean), ignore.case = TRUE)
names(table_clean)<-gsub("-freq()", "Frequency", names(table_clean), ignore.case = TRUE)
names(table_clean)<-gsub("angle", "Angle", names(table_clean))
names(table_clean)<-gsub("gravity", "Gravity", names(table_clean))

#5

Final_table <- table_clean %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(Final_table, "final_table.txt", row.name=FALSE)