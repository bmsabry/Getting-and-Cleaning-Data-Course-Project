library(dplyr)
library(tidyselect)
setwd("C:/Users/200019195/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test")
# setting working directory to where data is located
Xtest<-read.delim("X_test.txt", header=FALSE, sep = "", dec = ".")
ytest<-read.delim("y_test.txt", header=FALSE, sep = "", dec = ".")
subject_test<-read.delim("subject_test.txt", header=FALSE, sep = "", dec = ".")

setwd("C:/Users/200019195/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train")
Xtrain<-read.delim("X_train.txt", header=FALSE, sep = "", dec = ".")
ytrain<-read.delim("y_train.txt", header=FALSE, sep = "", dec = ".")
subject_train<-read.delim("subject_train.txt", header=FALSE, sep = "", dec = ".")

X<-rbind(Xtest,Xtrain)
Y<-rbind(ytest,ytrain)
subject<-rbind(subject_test,subject_train)

setwd("C:/Users/200019195/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
features<-read.delim("features.txt", header=FALSE, sep = "", dec = ".")
# reading the variables names from the file features
Activites<-read.delim("activity_labels.txt", header=FALSE, sep = "", dec = ".")
# reading the activites names from the source file

for (i in 1:6) {
  Y$V1 <- replace(Y$V1, Y$V1==i, as.character(Activites$V2[i]))
} 
#The for loop replaces the activites numbers in the Y vector by the meaningful names from the Activites vector

colnames(Y)<-"Activites"
#renaming the observation variable Y to Activites which is meaningful name

colnames(subject)<-"Subject"
#renaming the observation variable Y to Activites which is meaningful name

names(X)<-features$V2
#renaming X variables to meaningful names from features

mean<-grep('mean',features$V2, value=TRUE)
Mean<-grep('Mean',features$V2,value=TRUE)
std<-grep('std',features$V2,value=TRUE)
# collected the variables names of the data that include mean, Mean and std

Interest<-c(mean,Mean,std,"Activites", "Subject")
#combining three of them in one list. Must add Activites and subject as well since this is going to be important variables

featuressubset<-filter(features,V2 %in% Interest)
# making a subset of the features that are only needed based on the problem statement 

Data<-cbind(subject,X,Y)
# This is the 1,2 and 3 delivarbles required per the problem statement. See the readme file.

Datasubset<-subset(Data,select = Interest)
#now making a subset of X with only the variables of interest defined in filter. This is the required assignment deliverable 4. 
# See the read me file

names(Datasubset) <- gsub(x = names(Datasubset), pattern = "mean", replacement = "Mean")  
names(Datasubset) <- gsub(x = names(Datasubset), pattern = "Mean", replacement = "Mean")  
names(Datasubset) <- gsub(x = names(Datasubset), pattern = "std", replacement = "STD")  
names(Datasubset) <- gsub(x = names(Datasubset), pattern = "\\()", replacement = "") 
# cleaning the names to make them look good and readable

DatasubsetGroupedSummary<-Datasubset %>% group_by(Subject,Activites) %>% summarise_all(funs(mean))
# this is the required summarized data by ssubject and activites which is deliverable number 5. See the read me file.

setwd("C:/Users/200019195/Documents/Getting-and-Cleaning-Data-Course-Project")
write.csv(DatasubsetGroupedSummary,file="DatasubsetGroupedSummary.csv")
write.table(DatasubsetGroupedSummary,file="DatasubsetGroupedSummary.txt", row.name=FALSE)
