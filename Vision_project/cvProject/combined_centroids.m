
addpath('cluster/');

des=[];
count=0;

for label=1:4
     file1 = strcat('Data/','descript','_',num2str(label), '.mat');
     d1=load(file1);

       model_des1 = d1.des;
        
       for i=1:40
            des = [des;model_des1{i}];
            count=count + size(model_des1{i},1);
       end

        
end
count;
size(des,1);

        des = normalizeData(des);
        [e,centroids] = kMeans(double(des),200);
        file = strcat('centroid1','_', 'all', '.mat');
         save(file,'centroids');



