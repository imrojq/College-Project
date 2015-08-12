function J = findCost(features,clusterNumber,centroidsValue)
    featureCentroids  = clusterNumber' * centroidsValue;
    J = sum(sum((features - featureCentroids).^2,2).^0.5);
end