function [ features ] = hist_feat(X,level)
    features = [];    
    [m n] =  size(X);
    
    for i=1:200
        [r c] = find(X(:,n)==i);
        if ( size(r,1)==0 || size(c,1)==0 || size(r,2)==0 || size(c,2)==0 )
            temp = zeros(1,5);
            features = [ features temp];
        else
            i_features = X(r,1:n-1);
            features = [ features features_mcluster(i_features,level)];
        end
    end
    %features =features*0.25;
end


function [f] = features_mcluster(X,level)
    size(X);
    f = [];
    [r c] = size(X);
    
    % level 0
    i=1;
    f(i) = r*0.25;
    i=i+1;
    % level 1 :level
    %level =1;
    
    t(:,1) = X(:,1)/max(X(:,1));
    t(:,2) = X(:,2)/max(X(:,2));
    
    for st=1:level
        
       grid = find_grid(st); 
   
    
    X = t*power(2,level);
    X= ceil(X);
    

        for x=1:size(grid,1)
            for y=1:size(grid,2)
                    [row,col] = find(X(:,1)==grid{x,y}(1) & X(:,2)==grid{x,y}(2));
                    if(( size(row,1)==0 || size(col,1)==0 || size(row,2)==0 || size(col,2)==0 ))
                        f(i) =0;
                    else
                        f(i) = length(row)*0.25*st;
                    end
                    i=i+1;
            end
        end
     end
%     
%     [row,col] = find(X(:,1)==1 & X(:,2)==1);
%     f(i) = length(row);
%     i=i+1;
%     
%     [row,col] = find(X(:,1)==1 & X(:,2)==2);
%     f(i) = length(row);
%     i=i+1;
%     
%     [row,col] = find(X(:,1)==2 & X(:,2)==1);    
%     f(i) = length(row);
%     i=i+1;
%     
%     [row,col] = find(X(:,1)==2 & X(:,2)==2);    
%     f(i) = length(row);
%     i=i+1;

end