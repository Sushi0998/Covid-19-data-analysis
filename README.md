# Covid-19-data-analysis-
About Neural Network
As one of the deep learning algorithms, neural networks have demonstrated exceptional performance across a wide range of tasks by leveraging their capacity to learn complex patterns and representations from large volumes of data. By utilizing it in our analysis, we aim to capitalize on its inherent strengths and capabilities, enabling us to generate more accurate and reliable predictions.
Developing Neural Network
We first started building the neural network by keeping a sigmoid activation function, which is basically predicts/spits output in 0 to 1 range.training the neural network model, using act.fct as a sigmoid function and hidden as 16,29. We are selecting this number as we have gone through all possible combinations and selected the one which gives us the lowest test MSE, and as it is a regression problem we are selecting  err.fct as 'sse'. We want the sigmoid function to be applied on the output layer hence linear.output = T.  The threshold for partial derivate is kept 0.6 just as to reduce the computational time, as we were performing heuristic search for hidden layer.


![image](https://github.com/Sushi0998/Covid-19-data-analysis-/assets/99321988/3dbfb4d3-403c-4696-8971-1d034ef51d30)
Sigmoid Function.
Courtesy- Activation Functions in Neural Networks
#Selection of hidden layer neurons
![image](https://github.com/Sushi0998/Covid-19-data-analysis-/assets/99321988/e4d94eae-6fcf-4a0a-859c-766a2525f034)
we are looking the layers which corresponds to the lowest test MSE. using the matrix (row and column) we will receive the, number of neurons required for hidden layer 1 and 2
