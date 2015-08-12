function [ key_descriptors ] =MyKeypointDescriptor( scale_space,key_points )
  
    key_descriptors =[];
    pad_img = cell(scale_space);
    dx=[-1 0 1;-1 0 1;-1 0 1];
    dy=dx';
    mag = cell(scale_space);
    dir = cell(scale_space);
    scale=0.6;

    
    for i=1:size(scale_space,1)
        for j=1: size(scale_space,2)
            pad_img{i,j} = pad_image(scale_space{i,j});
            grad_x = double(MyConv(pad_img{i,j}, dx));
            grad_y = double(MyConv(pad_img{i,j}, dy));
            magn    = sqrt(grad_x.^2 + grad_y.^2);  
            Mask   = MyGauss(1, 3);
            mag{i,j}    = double(MyConv(magn, Mask));
            dir{i,j}    = cal_angle(grad_x,grad_y);
                
        end
    end
    
    
    
    for i=1:size(key_points,1)

        neighbour_16_mag = neighbour(mag{key_points(i,4),key_points(i,3)},key_points(i,:));
        neighbour_16_dir = neighbour(dir{key_points(i,4),key_points(i,3)},key_points(i,:));
        key_descriptors= [key_descriptors; find_bins(neighbour_16_mag,neighbour_16_dir,key_points(i,:))];
        
        
        
    end
    
end

function [des] = find_bins(mag,dir,points)
   
    des=[];
    size(mag);
    i=1;
    
    while(i<16)
        j=1;
        while(j<16)           
           sub_mag = mag(i:i+3,j:j+3);
           sub_dir=  dir(i:i+3,j:j+3);
           bin  = zeros(1,8);
           for k = 1:4
               for l = 1:4
                   if(sub_dir(k,l)>359)
                       sub_dir(k,l)=0;
                   end
                   if(floor((sub_dir(k,l)/45)+1)>8)
                      floor((sub_dir(k,l)/45)+1);
                      %x=3;
                   end
                    bin(1,floor((sub_dir(k,l)/45)+1)) = bin(1,floor((sub_dir(k,l)/45)+1)) + sub_dir(k,l);
               end
           end 
           des=[des bin];   
           j=j+4;
        end
        i=i+4;
    end
    
end

function [n_16] = neighbour(img,point)

   % point(i,1)+8+7
    n_16 = img(point(1)+8-8:point(1)+8+7,point(2)+8-8:point(2)+8+7);

end



function [pad_array] = pad_image(img)
    pad_array = zeros(16+size(img,1),16+size(img,2));
    
    pad_array(8+1:8+size(img,1),8+1:8+size(img,2)) = img;
end



