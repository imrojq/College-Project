function [ k_corn ] = MyEliminateKeypoints(a, k )
    
    k_cont=[];
    
    c_t=0.01;
    
    for i=1:size(k,1)
        
        if(abs(a{k(i,4),k(i,3)}(k(i,1),k(i,2)))>c_t)
            k_cont=[k_cont; k(i,:)];
        end
    end

    dx = [-1 0 1;-1 0 1;-1 0 1];
    %dy = [0 -1 0;0 0 0;0 1 0];
    dy=dx';
    R  = cell(size(a,1),size(a,2));
    g = MyGauss(1, 3);
    for i=1:size(a,1)
        for j=1:size(a,2)            
           grad_x = double(MyConv(a{i,j}, dx));
           grad_y = double(MyConv(a{i,j}, dy));
           grad_x2 = grad_x.^2;
           grad_y2 = grad_y.^2;
           grad_xy = grad_x.*grad_y;
           sX = double(MyConv(grad_x2, g));
           sY = double(MyConv(grad_y2, g));
           sXY = double(MyConv(grad_xy, g));
           k = 0.04;
           R{i,j} = (sX.*sY - sXY.^2) - k*(sX + sY).^2;
            
        end
    end
    

    k_corn=[];
    for i=1:size(k_cont,1)
        if R{k_cont(i,4),k_cont(i,3)}(k_cont(i,1),k_cont(i,2))>5
             k_corn = [k_corn; k_cont(i,:)];
        end
    end
    
end


