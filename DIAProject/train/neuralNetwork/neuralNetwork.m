

%%% ----------- Initialise--------------------%
clear ;
close all;
clc
num_labels=10;
input_layer_size  = 16;  % 28x28 Input Images of Digits
hidden_layer_size = 35;   % 28 hidden units
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%------------Loading Training Data----------%
X = loadImages('train-images.idx3-ubyte');
X=X';

size(X)
y = loadLabels('train-labels.idx1-ubyte');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% --------Selecting data--------------%%%%%
numberOfex = length(y);

for i = 1 : numberOfex
    if (y(i) == 0)
        y(i)=10;
    end
end
    
rand_indices = randperm(numberOfex);
X=X(rand_indices,:);
y=y(rand_indices,:);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%---Selecting Training and CrossValidation part--%%%
m=10000;
X= X((1:m),:);
y= y((1:m),:);

train_size=floor((2*m)/3);
train_X = X((1:train_size),:);
train_y = y((1:train_size),:);
cross_X= X((train_size+1:m),:);
cross_y= y((train_size+1:m),:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%--------Initialisation PArameters-------%%%%

initial_Theta1 = initialiseWeights(input_layer_size, hidden_layer_size);
initial_Theta2 = initialiseWeights(hidden_layer_size, num_labels);

% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%-----------Training-NN--------------------%%%
fprintf('\nTraining Neural Network... \n')

%  You should also try different values of lambda

lambda = 0;
num_iters=100;
[nn_params, cost] =  gradientDescentMulti(initial_nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   train_X, train_y, lambda,num_iters);   

% Obtain Theta1 and Theta2 back from nn_params
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%----------Prediction-----------------%%%%%%
pred = predictNN(Theta1, Theta2, cross_X);

fprintf('\nCrossValidation Set Accuracy: %f\n', mean(double(pred == cross_y)) * 100);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save('nndata.mat','Theta1','Theta2');