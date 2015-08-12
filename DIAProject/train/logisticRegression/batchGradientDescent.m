function [theta, J] = batchgradientDescent(initial_theta , X , y, lambda )

m = length(y); % number of training examples
iter=0;
for j=1:200

    [J grad] = (costfunction(initial_theta,X,y,lambda));
    iter = iter+1;
    initial_theta = initial_theta  - grad ;


end
theta = initial_theta;

end
