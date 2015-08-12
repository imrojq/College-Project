function [ Mask ] = MyGauss( sigma,size )
    
   Mask=zeros(size,size);
   
   for i=1:size
       for j=1:size
           Mask(i,j)= exp(-1*(power((i-floor(size/2)-1),2)+power((j-floor(size/2)-1),2))/(2*power(sigma,2)));        
       end
   end
   Mask=Mask./sum(Mask(:));
    
end

