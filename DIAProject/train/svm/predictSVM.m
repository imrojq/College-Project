function predict = predictSVM(svmModel,X)
test_size=size(X,1);
predTest     = zeros(test_size,numel(svmModel));
for k=1:numel(svmModel)
    predTest(:,k)           = svmclassify(svmModel{k}, X);
end
predict = mode(predTest,2);   % clasify as the class most fovaoured

end