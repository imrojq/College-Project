function [c,p] = predictLR(all_theta, X)
m = size(X, 1);
num_labels = size(all_theta, 1);
p = zeros(size(X, 1), 1);

X = [ones(m, 1) X];
     
temp=X*(all_theta)';

[c, p]=max(temp,[],2);
c=sigmoid(c);
p(p==10,:) =0;


end
