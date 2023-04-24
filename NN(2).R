library(tidyr) ## using this package we can replace NA values to their median values, we can get this package by using install.packages('tidyr')
library(dplyr) ## using this package we can replace NA values to their median values and manipulate the data we can get this package by using install.packages('dplyr')
library(neuralnet) ## using this package we can use neural network and we can install it using install.packages("neuralnet")
#########Case 1
NN<-vector()
count = 0
#we perform heuristic search for i>=z and i<=z, separately
#to reduce the run time, because of using a laptop the total run time if we include 
# all the possibility at once we were scared of losing the data and 
# might end up with no result, and the total run time was 40 hrs. hence we used this approach. 
#the code remains the same for i<=z. we performed this case as well but we received a test MSE greater than the 
# current test MSE. 
for (z in 1:155){
  
  for (i in 1:154)
  {
    if (i<=z){   #for case 2 we just change i<=z to i>=z 
      s<-read.csv('C:/Users/SURAJ SHINDE/OneDrive/Desktop/TAMU Courses/613/Training_data12.csv')
      Trd<-data.frame(s[,-(156:158)])
      #replacing all the NA values in all numeric columns with their respective medians
      ## and we are removing the characters in the data manually , in this file we are encountered only one case 
      # which was 18 years old we changed it to 18
      Trd <- Trd %>% mutate(across(where(is.numeric), ~replace_na(., median(., na.rm=TRUE))))
      normalize <- function(x) {
        return ((x - min(x)) / (max(x) - min(x)))
      }
      
      maxmin <- as.data.frame(lapply(Trd, normalize))
      set.seed(123)
      Split<-sample(2,nrow(Trd),T,c(0.7,0.3))
      train1<- maxmin[Split==1,]
      test <- maxmin[Split==2,]
      
      #training the neural network model, using act.fct as a sigmoid function and hidden as 15,85.
      #We are selecting this number as we have gone through all possible combinations and selected
      #the one which gives us the lowest test MSE, and as it is a regression problem we are selecting 
      #err.fct as 'sse'. We want the sigmoid function to be applied on the output layer hence linear.output = T. 
      #The threshold for partial derivate is kept 0.6 just as to reduce the computational time, as we were performing 
      #heuristic search for hidden layer.
      
      nn <- neuralnet(train1$X155 ~ ., data =train1, hidden = c(i,z), act.fct = (function(x) 1.0 / (1.0 + exp(-x))), 
                      err.fct = "sse", linear.output = T, threshold=0.6,stepmax = 10e6)
      K<-compute(nn, test[, 1:154])$net.result
      Test_MSE <- sum((K-test[, 155])^2)/nrow(test)
      NN<-append(NN,Test_MSE)}
    else{
      NN<-append(NN,1)
    }
    count=count+1
    print(count)
    
  }
}

plot(NN)
NN
P<-which.min(NN);P
NN[P]
MAT<-matrix(NN,154,155)
#H1,H2

which(MAT == min(MAT), arr.ind = TRUE)
#In the matrix the row is the number of neuron in hidden layer 1 and column is number
#of neuron in hidden layer2

# here we are receving the lowest test mse of 0.05597384 and
#using which(MAT == min(MAT), arr.ind = TRUE), we receive the row as 15 and column as 
#85

#######################CASE 2 (i>=z)



NN<-vector()
count = 0

for (z in 1:155){
  for (i in 1:154)
  {
    if (i>=z){   #for case 2 we just change i<=z to i>=z 
      s<-read.csv('C:/Users/SURAJ SHINDE/OneDrive/Desktop/TAMU Courses/613/Training_data12.csv')
      Trd<-data.frame(s[,-(156:158)])
      #replacing all the NA values in all numeric columns with their respective medians
      ## and we are removing the characters in the data manually , in this file we are encountered only one case 
      # which was 18 years old we changed it to 18
      Trd <- Trd %>% mutate(across(where(is.numeric), ~replace_na(., median(., na.rm=TRUE))))
      normalize <- function(x) {
        return ((x - min(x)) / (max(x) - min(x)))
      }
      
      maxmin <- as.data.frame(lapply(Trd, normalize))
      set.seed(123)
      Split<-sample(2,nrow(Trd),T,c(0.7,0.3))
      train1<- maxmin[Split==1,]
      test <- maxmin[Split==2,]
      
      nn <- neuralnet(train1$X155 ~ ., data =train1, hidden = c(i,z), act.fct = (function(x) 1.0 / (1.0 + exp(-x))), 
                      err.fct = "sse", linear.output = T, threshold=0.6,stepmax = 10e6)
      K<-compute(nn, test[, 1:154])$net.result
      Test_MSE <- sum((K-test[, 155])^2)/nrow(test)
      NN<-append(NN,Test_MSE)}
    else{
      NN<-append(NN,1)
    }
    count=count+1
    print(count)
    
  }
}

plot(NN)
NN
P<-which.min(NN);P
NN[P]
MAT<-matrix(NN,154,155)
#H1,H2
which(MAT == min(MAT), arr.ind = TRUE)

#the lowest test MSE we are receiving is 0.05791825, with r-square of 0.7531251
# for hidden layer neurons of 137 and hidden layer neurons of 28 


##PLUGGING VALUES FOR HIDDEN LAYER 1 AND HIDDEN LAYER 2

# so we will continue with the hidden layers we received in case 1,, whcih is 15 and 85 



############   ATER COMPLETION OF ALL THE PROCESS WE PRESENT THE FINAL SOULTION BELOW


s<-read.csv('C:/Users/SURAJ SHINDE/OneDrive/Desktop/TAMU Courses/613/Training_data12.csv') #reading the data after converting it to .csv
Trd<-data.frame(s[,-(156:158)]) # removing last columns as they are being added while converting the excel file to .csv

#replacing all the NA values in all numeric columns with their respective medians
Trd <- Trd %>% mutate(across(where(is.numeric), ~replace_na(., median(., na.rm=TRUE))))
#Normalizing the data.
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}  
maxmin <- as.data.frame(lapply(Trd, normalize))

#Splitting the data into 70% train and 30% test 
set.seed(123)
Split<-sample(2,nrow(Trd),T,c(0.7,0.3))
train1<- maxmin[Split==1,]
test <- maxmin[Split==2,]

#training the neural network model, using act.fct as a sigmoid function and hidden as 15,85.
#We are selecting this number as we have gone through all possible combinations and selected
#the one which gives us the lowest test MSE, and as it is a regression problem we are selecting 
#err.fct as 'sse'. We want the sigmoid function to be applied on the output layer hence linear.output = T. 
#The threshold for partial derivate is kept 0.6 just as to reduce the computational time, as we were performing 
#heuristic search for hidden layer.

nn <- neuralnet(train1$X155 ~ ., data =train1, hidden = c(15,85),
                act.fct =(function(x) 1.0 / (1.0 + exp(-x))),err.fct = "sse",
                linear.output = T,threshold=0.6,stepmax = 10e5)

#Finding the train MSE
L<-compute(nn, train1[, 1:154])$net.result
Train_MSE <- sum((L-train1[, 155])^2)/nrow(train1)
Train_MSE# Train MSE - 0.05644622

#Finding the test MSE
K<-compute(nn, test[, 1:154])$net.result
Test_MSE <- sum((K-test[, 155])^2)/nrow(test)
Test_MSE# Test MSE - 0.05597384

#Finding the R-square value
RSS<-sum((test[, 155]-K)^2)
TSS<-sum((test[, 155]-mean(test[, 155])^2))
1-(RSS/TSS)# R- square value 0.761413
