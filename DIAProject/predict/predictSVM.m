function [conf,predict] = predictSVM(svmModel,X)
test_size=size(X,1);
predTest     = zeros(test_size,numel(svmModel));
for k=1:numel(svmModel)
    predTest(:,k)           = svmclassify(svmModel{k}, X);
end
[predict , count] = mode(predTest,2);   % Voting: clasify as the class receiving most votes
conf = count./9;
predict(predict==10,:) =0;
end