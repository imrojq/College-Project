%%% ----------- Initialise--------------------%
clear ;
close all;
clc
num_labels=10;
input_layer_size  = 784;  % 28x28 Input Images of Digits
hidden_layer_size = 35;   % 28 hidden units
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%------------Loading Test Data----------%
X = loadImages('train-images.idx3-ubyte');
X=X';


y = loadLabels('train-labels.idx1-ubyte');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%----------LOad Learned Parameters------%
load('nndata.mat');
load('nbdata.mat');
load('svmdata.mat');
load('lrdata.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% --------Selecting data--------------%%%%%
numberOfex = length(y);

for i = 1 : numberOfex
    if (y(i) == 0)
        y(i)=10;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



index = floor( rand * numberOfex);
test_X=X(index,:);
y=y(index,:)
p1=predictNN(Theta1, Theta2, test_X)
p2 = predictSVM(svmModel,test_X)
p3 = predictBayes(test_X,pC, phiC, phinC, num_labels)
p4 = predictLR(all_theta, test_X)
