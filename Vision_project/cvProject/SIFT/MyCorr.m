function [Y] = MyCorr(ImageIn,Mask)
   % ImageIn=rgb2gray(ImageIn);
    [m n p]=size(ImageIn);
    for i=1:1:p
        Y(:,:,i)=corr_lay(ImageIn(:,:,i),Mask);
    end
end



function [Y]= corr_lay(ImageIn,Mask)
    [m n]=size(Mask);
    [a b]=size(ImageIn);
  
    X=zeros(a+2*floor(m/2),b+2*floor(n/2));
    
    X(floor(m/2)+1:floor(m/2)+a,floor(n/2)+1:floor(n/2)+b)=ImageIn;
    size(X);
    Y=zeros(size(X));
    for i=floor(m/2)+1:floor(m/2)+a
        for j=floor(n/2)+1:floor(m/2)+b
            Y(i,j)=find(X,i,j,Mask);
        end
    end
    
    
    
    Y=Y(floor(m/2)+1:floor(m/2)+a,floor(n/2)+1:floor(m/2)+b);
end
function [op] =find(X,a,b,Mask)
    
    [m n]=size(Mask);
    op=0;
    for i=-floor(m/2):floor(m/2)
        for j=-floor(n/2):floor(n/2)
            op=op + X(i+a,j+b)*Mask(i+floor(m/2)+1,j+floor(n/2)+1);
        end
    end
         

end
