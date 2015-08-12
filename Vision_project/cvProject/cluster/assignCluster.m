function clusterNumber = assignCluster(features,centroidsValue)
numPoints = size(features,1);
k = size(centroidsValue,1);
clusterNumber = size(k,numPoints);
for i = 1:numPoints
    val = repmat(features(i,:),k,1);
    sqDiff = sum((val - centroidsValue).^2,2);
    [minVal , index ] = min(sqDiff);
    clusterNumber(index,i) =1;
end