function [X] = find_features()
    addpath('SIFT/')
    level=1;
    Path = 'Test_Images/';
    X=[];
    load('centroid1_all.mat');
    for i=1:10
        t=char(strcat(Path,num2str(i),'.jpg'));
        S =  single(imread((t)));
        [a b] = MySIFT(S);
        clusterNumber = findCluster(b,centroids);
        t = a;
        temp =[t(:,1:2) clusterNumber];
        X=[X;hist_feat(temp,level)];
        size(X)
    end
    
end