function [all_theta] = trainLR(X, y, num_labels, lambda)

m = size(X, 1);
n = size(X, 2);
all_theta = zeros(num_labels, n + 1);
X = [ones(m, 1) X];
initial_theta=zeros(n+1,1);
for c=1:num_labels
  [temp, cost] =  batchGradientDescent(initial_theta , X , (y==c), lambda );

all_theta(c,:)=temp';
end
  











% =========================================================================


end
