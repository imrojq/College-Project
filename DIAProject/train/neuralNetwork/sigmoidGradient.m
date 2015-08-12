function g = sigmoidGradient(z)
g = zeros(size(z));
gs = 1.0 ./ (1.0 + exp(-z));
g=gs.*(ones(size(z,1),size(z,2))-gs);
end
