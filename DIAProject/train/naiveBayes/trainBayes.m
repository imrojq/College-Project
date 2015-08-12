function [pC phiC phinC] = bayes(X, y, num_labels)

pC = zeros(num_labels,1);
phiC = zeros(784,num_labels);
phinC = zeros(784,num_labels);
for c=1:num_labels 
    Y=(y==c);
    Yn = (y ~= c);
    %fprintf('\nFor c =: %d\n', c);
    pC(c) = sum (Y)/size(Y,1);    % all rows with Y = 1 
    phiC(:,c) = X' * Y / sum(Y) ; % p(x_i|Y)
    phinC(:,c) = X' * Yn / sum(Yn);
end