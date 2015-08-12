function clusterLabel = findCluster(features,centroidsValue)
numPoints = size(features,1);
k = size(centroidsValue,1);
% clusterNumber = size(k,numPoints);
clusterLabel = size(numPoints,1);
for i = 1:numPoints
    val = repmat(features(i,:),k,1);
    sqDiff = sum((val - centroidsValue).^2,2);
    [minVal , index ] = min(sqDiff);
%     clusterNumber(index,i) =1;
     clusterLabel(i,1) = index;
end