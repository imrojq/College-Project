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
test_size=m-train_size;
train_X = X((1:train_size),:);
train_y = y((1:train_size),:);
cross_X= X((train_size+1:m),:);
cross_y= y((train_size+1:m),:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%----Training Naive Bayes----------%%%%%%
fprintf('\nTraining Naive...\n')
pC = zeros(num_labels,1);
phiC = zeros(784,num_labels);
phinC = zeros(784,num_labels);


[pC phiC phinC] = trainBayes(train_X, train_y, num_labels);


%% ================ Part 3: Predict for One-Vs-All ================
%  After ...
p = predictBayes(cross_X,pC, phiC, phinC, num_labels);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(p' == cross_y)) * 100);

save('nbdata.mat','pC','phiC','phinC');