function [J, grad] = costFunction(theta, X, y, lambda)

m = length(y);

J = 0;
grad = zeros(size(theta));


J=(((-y)'*log(sigmoid(X*theta)))-((ones(m,1)-y)'*log(ones(m,1)-sigmoid(X*theta))))/m;

grad=(X'*(sigmoid(X*theta)-y))./m;

J=J+(sum(theta(2:end).^2)*(lambda/(2*m)));

grad(2:end)=grad(2:end)+(theta(2:end).*(lambda/m));

% =============================================================

grad = grad(:);

end
