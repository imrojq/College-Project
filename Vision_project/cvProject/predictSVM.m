function [index] = predictSVM(X)
load('svm.mat');
x = repmat(w0_all,size(X,1),1);
result = (X*w_all') + x;
[~,index] = max(result');
index= index';

end