
library(caret)
library(ISLR)
library(reshape2)
library(e1071)

ubank<-read.csv("c:/Users/reliance digital/Downloads/UniversalBank.csv")

#converting varibles to factors
ubank$Personal.Loan=factor(ubank$Personal.Loan)
ubank$Online=factor(ubank$Online)
ubank$CreditCard=factor(ubank$CreditCard)
set.seed(8)

#Splitting of data
set.seed(8)
Train_index=createDataPartition(ubank$Personal.Loan,p=0.6,list=FALSE)
Train.df=ubank[Train_index,]
validation.df=ubank[-Train_index,]
nrow(validation.df)

#taskA
table= xtabs(~CreditCard+Personal.Loan+Online,data=Train.df)
ftable(table)

#task b
#the proability that the person will accept the loan (with online= 1, cc= 1)
50/(50+460)

#task c
table(Personal.Loan=Train.df$Personal.Loan,CreditCard=Train.df$CreditCard)
table(Personal.Loan=Train.df$Personal.Loan,Online=Train.df$Online)
table(Personal.Loan=Train.df$Personal.Loan)

#task d- finding the probabilities
#1 p(cc/l)
p1=90/(90+198)

#2 p(online/l)
p2=178/(178+110)

#3 p(l)
p3=288/(288+2712)

#4 p(cc=1/l=0)
p4=779/(779+1933)

#5 p(onine=1/l=0)
p5=1606/(1606+1106)

#6 p(l=0)
p6=2712/(2712+288)

#task E
(p1*p2*p3)/((p1*p2*p3)+(p4*p5*p6))

#task f
#Probability from Pivot table is 0.09803922 and probablity from naive bayes 
#is0.1076053 probablity from pivot table is more accurate than naive bayes. 
#This is because in naive bayes we make an assumption that in attributes 
#are independent of each other
 
#task g
model=naiveBayes(Personal.Loan~CreditCard+Online,data=Train.df)
test.set=data.frame(CreditCard=1,Online=1)
predict(model,test.set,type = "raw")

