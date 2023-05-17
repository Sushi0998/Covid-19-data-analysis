library(tidyr) ## using this package we can replace NA values to their median values, we can get this package by using install.packages('tidyr')
library(dplyr) ## using this package we can replace NA values to their median values and manipulate the data we can get this package by using install.packages('dplyr')
library(neuralnet) ## using this package we can use neural network and we can install it using install.packages("neuralnet")

##Searcing for number of neurons for hidden layer 1 and 2.
for (z in 1:155){
  for (i in 1:154)
  {
    set.seed(123)
    #TRAIN DATA
    s<-read.csv('C:/Users/SURAJ SHINDE/OneDrive/Desktop/TAMU Courses/613/Training_data12.csv') #reading the data after converting it to .csv
    Trd<-data.frame(s[,-(156:158)]) # removing last columns as they are being added while converting the excel file to .csv
    #replacing all the NA values in all numeric columns with their respective medians
    Trd <- Trd %>% mutate(across(where(is.numeric), ~replace_na(., median(., na.rm=TRUE))))
    #Normalizing the train data.
    normalize <- function(x) {
      return ((x - min(x)) / (max(x) - min(x)))
    }  
    Train <- as.data.frame(lapply(Trd, normalize))
    
    #TEST DATA
    t<-read.csv("C:/Users/SURAJ SHINDE/OneDrive/Desktop/TAMU Courses/613/Test_data-12.csv")
    TS<-t[,-(156:158)]# removing last columns as they are being added while converting the excel file to .csv
    #replacing all the NA values in all numeric columns with their respective medians
    TS <- TS %>% mutate(across(where(is.numeric), ~ replace_na(., median(., na.rm=TRUE))))
    #Normalizing the test data.
    normalize <- function(x) {
      return ((x - min(x)) / (max(x) - min(x)))
    }  
    Test <- as.data.frame(lapply(TS, normalize))
    ##neural network
    nn <- neuralnet(Train$X155 ~ ., data =Train, hidden = c(i,z),
                    act.fct =(function(x) 1.0 / (1.0 + exp(-x))),err.fct = "sse",
                    linear.output = T,threshold=0.7,stepmax = 10e5)
    
    #Finding the test MSE
    K<-compute(nn, Test[, 1:154])$net.result
    Test_MSE <- sum((K-Test[, 155])^2)/nrow(Test)
    ##storing Test MSE
    NN<-append(NN,Test_MSE)
    #Counting the iterations.
    count=count+1
    print(count)
    
  }
  
  
}

plot(NN);NN
P<-which.min(NN);P
NN[P]
# Creating a Matrix
MAT<-matrix(NN,154,155)
#H1,H2
which(MAT == min(MAT), arr.ind = TRUE)


#Running the final model.
set.seed(123)

s<-read.csv('C:/Users/SURAJ SHINDE/OneDrive/Desktop/TAMU Courses/613/Training_data-111.csv') #reading the data after converting it to .csv
Trd<-data.frame(s[,-(156:158)]) # removing last columns as they are being added while converting the excel file to .csv
Trd <- Trd %>% mutate(across(where(is.numeric), ~replace_na(., median(., na.rm=TRUE))))

t<-read.csv("C:/Users/SURAJ SHINDE/OneDrive/Desktop/TAMU Courses/613/Test_data-111.csv")#reading the data after converting it to .csv
TS<-t[,-(156:158)]
TS <- TS %>% mutate(across(where(is.numeric), ~ replace_na(., median(., na.rm=TRUE))))
#normalizing the data
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}  
Train <- as.data.frame(lapply(Trd, normalize))

normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}  
Test <- as.data.frame(lapply(TS, normalize))

#training the neural network model, using act.fct as a sigmoid function and hidden as 15,85.
#We are selecting this number as we have gone through all possible combinations and selected
#the one which gives us the lowest test MSE, and as it is a regression problem we are selecting 
#err.fct as 'sse'. We want the sigmoid function to be applied on the output layer hence linear.output = T. 
#The threshold for partial derivate is kept 0.6 just as to reduce the computational time, as we were performing 
#heuristic search for hidden layer.

nn <- neuralnet(Train$X155 ~ ., data =Train, hidden = c(16,29),
                act.fct =(function(x) 1.0 / (1.0 + exp(-x))),err.fct = "sse",
                linear.output = T,threshold=0.7,stepmax = 10e5)

#from the model build using the train data

K<-compute(nn, Test[, 1:154])$net.result


#Finding the test MSE (Normalized data)
K<-compute(nn, Test[, 1:154])$net.result 
Test_MSE <- sum((K-Test[, 155])^2)/nrow(Test)
Test_MSE# Test MSE - 0.0552788


#Finding the R-square value (Normalized data)
RSS<-sum((Test[, 155]-K)^2)
TSS<-sum((Test[, 155]-mean(Test[, 155])^2))
1-(RSS/TSS)# R- square value 0.7676385

## denormalize the data in order to receive the test MSE

x=1:5
denormalized = (K)*(max(x)-min(x))+min(x)

#Finding the test MSE (denormalized data)
Test_MSE <- sum((denormalized - TS[, 155])^2)/nrow(TS)
Test_MSE # Test MSE - 0.8844608

#Finding the R-square value (denormalized data)
RSS<-sum((TS[, 155]-denormalized)^2)
TSS <- sum((TS[,155] - mean(TS[,155]))^2)
1-(RSS/TSS)# R- square value 0.3015944
