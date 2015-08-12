function [nn_params, J] = gradientDescentMulti(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambdas,num_iters)
%GRADIENTDESCENTMULTI Performs gradient descent to learn theta
%   theta = GRADIENTDESCENTMULTI(x, y, theta, alpha, num_iters) updates theta by
%   taking num_iters gradient steps with learning rate alpha

m = length(y); % number of training examples
J_history = zeros(num_iters, 1);

%j_old = J +1;
iter=0
for j=1:10
    sel = randperm(m);
    X=X(sel,:);
    y=y(sel,:);

    
for i = 1 :m
    [J grad] = costFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X(i,:), y(i,:), lambdas);
    iter = iter+1;
    nn_params = nn_params  - 0.02*grad ;


    % ===========================================================
end

    fprintf('Iteration  %d',iter)
    fprintf(' Cost  %d\n',J)
end

end
