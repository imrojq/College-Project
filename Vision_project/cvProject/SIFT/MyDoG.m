function [dog]= MyDoG(img)

    dog=cell(size(img,1),size(img,2)-1);
    
    for i=1:size(dog,1)
        for j=1:size(dog,2)
            dog{i,j}=(double(img{i,j})-double(img{i,j+1}));
        end
    end
     

end