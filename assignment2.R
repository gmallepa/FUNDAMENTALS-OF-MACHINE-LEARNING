library(class)
library(dplyr)
library(caret)
library(gmodels)


#
ubank<-read.csv("c:/Users/reliance digital/Downloads/UniversalBank.csv")

#
ubank_1<-ubank[,-1]
ubank_1<-ubank_1[,-4]
head(ubank_1)

#
is.na(ubank_1)


#
Education<-as.character(ubank_1$Education)

ubank_2<-cbind(ubank_1[,-6],Education)
head(ubank_2)

#
dummy<-dummyVars("~Education",data = ubank_2)
dummyeducation<-data.frame(predict(dummy,ubank_2))

ubank_dummy<-cbind(ubank_2[,-12],dummyeducation)
head(ubank_dummy)


#
set.seed(8)
train<-createDataPartition(ubank_dummy$Personal.Loan,p=0.6,list = FALSE)
trainingset<-ubank_dummy[train,]
validationset<-ubank_dummy[-train,]
nrow(validationset)

testingset<-data.frame(Age = 40, Experience = 10, Income = 84, Family = 2, CCAvg = 2,  Mortgage = 0, Securities.Account = 0, 
                    CD.Account = 0, Online = 1,CreditCard = 1,Education1 = 0, Education2 = 1, Education3 = 0)
summary(trainingset)
summary(validationset)
summary(testingset)

#
normalvariables<-c('Age',"Experience","Income","Family","CCAvg","Mortgage","Securities.Account","CD.Account","Online","CreditCard","Education1","Education2","Education3")

normalization_values<-preProcess(trainingset[,normalvariables],method=c('center','scale'))

trainingset.norm<-predict(normalization_values,trainingset)
validationset.norm<-predict(normalization_values,validationset)
testingset.norm<-predict(normalization_values,testingset)


#1st question
set.seed(8)
grid<-expand.grid(k=1)
model_1<-train(Personal.Loan~.,data=trainingset.norm,method='knn',tuneGrid=grid)
model_1
customer<-predict(model_1,testingset.norm)
customer


#2nd question
set.seed(8)
grid2<-expand.grid(k=seq(1:20))
model_2<-train(Personal.Loan~.,data=trainingset.norm,method='knn',tuneGrid=grid2)
model_2

plot(model_2$results$k,model_2$results$RMSE, type = 'o')

bestk<-model_2$bestTune[[1]]
bestk

#
training.label<-trainingset.norm[,7]
validation.label<-validationset.norm[,7]
testing.label<-testingset.norm[,7]

predictedvalidation.label<-knn(trainingset.norm,validationset.norm,cl=training.label,k=bestk)

CrossTable(x=validation.label,y=predictedvalidation.label,prop.chisq = FALSE)

#4th question
set.seed(8)
gridk<-expand.grid(k=bestk)
model_k<-train(Personal.Loan~.,data=trainingset.norm,method='knn',tuneGrid=gridk)
model_k
customer_k<-predict(model_k,testingset.norm)
customer_k

#5th question
set.seed(8)
train2<-createDataPartition(ubank_dummy$Personal.Loan,p=0.5,list = FALSE)
trainingset2<-ubank_dummy[train2,]
x<-ubank_dummy[-train2,]
train3<-createDataPartition(x$Personal.Loan,p=0.6,list = FALSE)
validationset2<-x[train3,]
testingset2<-x[-train3,]
nrow(trainingset2)
nrow(testingset2)
nrow(validationset2)



normalvariables<-c('Age',"Experience","Income","Family","CCAvg","Mortgage","Securities.Account","CD.Account","Online","CreditCard","Education1","Education2","Education3")

normalization_values2<-preProcess(trainingset2[,normalvariables],method=c('center','scale'))

trainingset.norm2<-predict(normalization_values2,trainingset2)
validationset.norm2<-predict(normalization_values2,validationset2)
testingset.norm2<-predict(normalization_values2,testingset2)


training.label2<-trainingset.norm2[,7]
validation.label2<-validationset.norm2[,7]
testing.label2<-testingset.norm2[,7]

predictedvalidation.label2<-knn(trainingset.norm2,validationset.norm2,cl=training.label2,k=bestk)
predictedtraining.label2<-knn(trainingset.norm2,trainingset.norm2,cl=training.label2,k=bestk)

CrossTable(x=validation.label2,y=predictedvalidation.label2,prop.chisq = FALSE)


CrossTable(x=training.label2,y=predictedtraining.label2,prop.chisq = FALSE)







