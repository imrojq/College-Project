% num_labels              =  4;
% pairwise                = nchoosek(1:num_labels,2);            % 1-vs-1 pairwise models
% svmModel                = cell(size(pairwise,1),1);            % Store binary-classifers
%predTest                = zeros(test_size,numel(svmModel)); % Store binary predictions
addpath('MySVM\');
te_X=[];
te_Y=[];
num_labels = 4;
 [X,Y] = getfeatures(num_labels);

t_X = X(1:120,:);
t_Y = Y(1:120,:);
test_X = X(121:160,:);
test_Y = Y(121:160,:);
w_all = [];
w0_all = [];

for i =1:num_labels
    train_X = t_X;
    train_Y = t_Y;
    train_Y(train_Y ~= i) =-1;
    train_Y(train_Y == i) = 1;
    alpha = mysvmseparabledual(train_X, train_Y);
    w   = (alpha.*train_Y)'*train_X;  %% 1*2 matrix  
    ind = find(alpha>0);
    w0  = 1/train_Y(ind(1),:) - w*train_X(ind(1),:)';
    w_all = [w_all ; w];
    w0_all = [w0_all w0];
      
end

x = repmat(w0_all,size(test_Y,1),1);
result = (test_X*w_all') + x;
[~,index] = max(result');
index= index';
fprintf('\n Test Set Accuracy: %f\n', mean(double(index == test_Y)) * 100);
save('svm.mat','w_all','w0_all');

