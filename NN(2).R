library(dplyr)
library(tidyr)
library(neuralnet)
##whem no. Hidden layer 1 neurons is greater than No. hidden layer 2 neurons
##Selecting the best model, Using 
NN<-vector()
count = 0
for (i in 1:154)
{
  if (i<=z){
    s<-read.csv('C:/Users/SURAJ SHINDE/OneDrive/Desktop/TAMU Courses/613/Training_data12.csv')
    Tr_d<-data.frame(s[,-(156:158)])
    #replacing all the NA values in all numeric columns with their respective medians
    Tr_d <- Tr_d %>% mutate(across(where(is.numeric), ~replace_na(., median(., na.rm=TRUE))))
    normalize <- function(x) {
      return ((x - min(x)) / (max(x) - min(x)))
    }
    
    maxmindf <- as.data.frame(lapply(Tr_d, normalize))
    set.seed(123)
    Split<-sample(2,nrow(Tr_d),T,c(0.7,0.3))
    train<- maxmindf[Split==1,]
    val_test <- maxmindf[Split==2,]
    
    nn <- neuralnet(train$X155 ~ ., data =train, hidden = c(i), act.fct = (function(x) 1.0 / (1.0 + exp(-x))), 
                    err.fct = "sse", linear.output = T, threshold=0.6,stepmax = 10e6)
    K<-compute(nn, val_test[, 1:154])$net.result
    NN1_Test_MSE <- sum((K-val_test[, 155])^2)/nrow(val_test)
    NN<-append(NN,NN1_Test_MSE)}
  
  else{
    NN<-append(NN,1)
  }
  count=count+1
  print(count)
}

min(NN)
which.min(NN)
plot(NN)
MAT<-matrix(NN,154,155)
#H1,H2
which(MAT == min(MAT), arr.ind = TRUE)

##whem no. Hidden layer 1 neurons is less than No. hidden layer 2 neurons
##Selecting the best model

library(dplyr)
library(tidyr)
library(neuralnet)
NN<-vector()
count = 0
for (i in 1:154)
{
  if (i>=z){
    s<-read.csv('C:/Users/SURAJ SHINDE/OneDrive/Desktop/TAMU Courses/613/Training_data12.csv')
    Tr_d<-data.frame(s[,-(156:158)])
    #replacing all the NA values in all numeric columns with their respective medians
    Tr_d <- Tr_d %>% mutate(across(where(is.numeric), ~replace_na(., median(., na.rm=TRUE))))
    normalize <- function(x) {
      return ((x - min(x)) / (max(x) - min(x)))
    }
    
    maxmindf <- as.data.frame(lapply(Tr_d, normalize))
    set.seed(123)
    Split<-sample(2,nrow(Tr_d),T,c(0.7,0.3))
    train<- maxmindf[Split==1,]
    val_test <- maxmindf[Split==2,]
    
    nn <- neuralnet(train$X155 ~ ., data =train, hidden = c(i), act.fct = (function(x) 1.0 / (1.0 + exp(-x))), 
                    err.fct = "sse", linear.output = T, threshold=0.6,stepmax = 10e6)
    K<-compute(nn, val_test[, 1:154])$net.result
    NN1_Test_MSE <- sum((K-val_test[, 155])^2)/nrow(val_test)
    NN<-append(NN,NN1_Test_MSE)}
  
  else{
    NN<-append(NN,1)
  }
  count=count+1
  print(count)
}

min(NN)
which.min(NN)
plot(NN)
MAT<-matrix(NN,154,155)
#H1,H2
which(MAT == min(MAT), arr.ind = TRUE)


## receiving the lowest test mean square error using 15b neurons in hidden layer 1 and 
## 85 neurons in hidden layer 2
s<-read.csv('C:/Users/SURAJ SHINDE/OneDrive/Desktop/TAMU Courses/613/Training_data12.csv')
Tr_d<-data.frame(s[,-(156:158)])
#replacing all the NA values in all numeric columns with their respective medians
Tr_d <- Tr_d %>% mutate(across(where(is.numeric), ~replace_na(., median(., na.rm=TRUE))))
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}  
maxmindf <- as.data.frame(lapply(Tr_d, normalize))
set.seed(123)

Split<-sample(2,nrow(Tr_d),T,c(0.7,0.3))
train<- maxmindf[Split==1,]
val_test <- maxmindf[Split==2,]

nn <- neuralnet(train$X155 ~ ., data =train, hidden = c(15,85),
act.fct =(function(x) 1.0 / (1.0 + exp(-x))),err.fct = "sse",
linear.output = T,threshold=0.6,stepmax = 10e5)

K<-compute(nn, val_test[, 1:154])$net.result
NN1_Test_MSE <- sum((K-val_test[, 155])^2)/nrow(val_test)
NN1_Test_MSE# Test MSE - 0.05597384
RSS<-sum((val_test[, 155]-K)^2)
TSS<-sum((val_test[, 155]-mean(val_test[, 155])^2))
1-(RSS/TSS)# R- square value 0.761413
plot(nn)
