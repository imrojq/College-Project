

%%% ----------- Initialise--------------------%
clear ;
close all;
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%------------Loading Training Data----------%
X = loadImages('train-images.idx3-ubyte');
X=X';

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
num_labels=10;
X= X((1:m),:);
y= y((1:m),:);

train_size=floor((2*m)/3);
train_X = X((1:train_size),:);
train_y = y((1:train_size),:);
cross_X= X((train_size+1:m),:);
cross_y= y((train_size+1:m),:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%-----Training ---------------------%%%%%
fprintf('\nTraining Logistic Regression \n')

lambda = 1;
[all_theta] = trainLR(train_X, train_y, num_labels, lambda);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%--------CrossValidation-------------%%%%%%%
pred = predictLR(all_theta, cross_X);
fprintf('\nCross Validation Set Accuracy: for lambda %f  : %f\n',lambda, mean(double(pred == cross_y)) * 100);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save('lrdata.mat','all_theta');
