function centroidValue = findCentroid(features,clusterNumber)
centroidValue = (clusterNumber*features)/sum(clusterNumber,2); 
end