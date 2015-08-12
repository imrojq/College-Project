

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




%%%---Training SVM-------------%%%%%%%%%%%%
options = svmsmoset( 'MaxIter', 500000);

pairwise                = nchoosek(1:num_labels,2);            % 1-vs-1 pairwise models
svmModel                = cell(size(pairwise,1),1);            % Store binary-classifers
predTest                = zeros(test_size,numel(svmModel)); % Store binary predictions

%# classify using one-against-one approach, SVM with 3rd degree poly kernel
for k=1:numel(svmModel)
    %# get only training instances belonging to this pair
    idx                     = any( bsxfun(@eq, train_y, pairwise(k,:)) , 2 );
    pairwise(k,:);
    %# train
    svmModel{k}             = svmtrain(train_X(idx,:), train_y(idx),'BoxConstraint',2e-1, 'Kernel_Function','polynomial', 'Polyorder',2);

end
pred = predictSVM(svmModel,cross_X);   % Voting: clasify as the class most favoured


fprintf('\n CrossValidation Set Accuracy: %f\n', mean(double(pred == cross_y)) * 100);

