function [ Keypoints ] =MyKeypointDetect( DOG )

    Keypoints=[];
      
    for i=1:size(DOG,1)  % octaves      
        for j=2:size(DOG,2)-1  % scalespace images
            for k=2:size(DOG{i,j},1)-1               
                for l=2:size(DOG{i,j},2)-1
                    if max(max( [DOG{i,j-1}(k-1:k+1,l-1:l+1) ; DOG{i,j+1}(k-1:k+1,l-1:l+1)])) < DOG{i,j}(k,l)
                        if max([DOG{i,j}(k-1,l-1) DOG{i,j}(k-1,l) DOG{i,j}(k-1,l+1) DOG{i,j}(k,l-1) DOG{i,j}(k,l+1) DOG{i,j}(k+1,l-1) DOG{i,j}(k+1,l) DOG{i,j}(k+1,l+1)]) < DOG{i,j}(k,l)                            
                            Keypoints = [Keypoints ; k l j i];
                        end
                    elseif min(min( [DOG{i,j-1}(k-1:k+1,l-1:l+1) ; DOG{i,j+1}(k-1:k+1,l-1:l+1)] ) ) > DOG{i,j}(k,l)
                        if min([DOG{i,j}(k-1,l-1) DOG{i,j}(k-1,l) DOG{i,j}(k-1,l+1) DOG{i,j}(k,l-1) DOG{i,j}(k,l+1) DOG{i,j}(k+1,l-1) DOG{i,j}(k+1,l) DOG{i,j}(k+1,l+1)]) > DOG{i,j}(k,l)                            
                            Keypoints = [Keypoints ; k l j i];
                        end
                    end
                end
            end             
        end        
    end

end

