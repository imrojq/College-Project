function [X Y] = getfeatures(label)
    
    
    centroid_file = strcat('centroid1','_','all', '.mat');
    centroid = load(centroid_file);
    centroids = centroid.centroids;
    X=[];
    Y=[];
    level = 1;
    
    for i=1:label
        data1_file    = strcat('Data/','descript','_',num2str(i),'.mat');
    
        d1=load(data1_file);
    
        model_pos1 = d1.pos;
        model_des1 = d1.des;
        for m=1:40
            clusterNumber = findCluster(model_des1{m},centroids);
            t = model_pos1{m}';
            temp =[t(:,1:2) clusterNumber];
            X=[X;hist_feat(temp,level)];
            Y=[Y;i];    
        end

        
    end
        r = randperm(40*label);
        X =X(r,:);
        Y =Y(r,:);
end
    
    