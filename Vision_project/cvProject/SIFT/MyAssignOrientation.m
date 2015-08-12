function [ keypoints_orien ] = MyAssignOrientation( scale_img, key_points) 
    w_size=3;
    keypoints_orien=[];
    
    mag = cell(size(scale_img,1),size(scale_img,2));
    dir = cell(size(scale_img,1),size(scale_img,2));
    dx=[-1 0 1;-1 0 1;-1 0 1];
    dy=dx';
    scale=1.5*0.6;
    k=sqrt(2);
    for i=1:size(scale_img,1)
        for j=1:size(scale_img,2)
            grad_x = double(MyConv(scale_img{i,j}, dx));
            grad_y = double(MyConv(scale_img{i,j}, dy));
            mag{i,j} = sqrt(grad_x.^2 + grad_y.^2);  
            Mask = MyGauss(scale*power(k,i-1)*power(power(2,0.5),j), w_size);
            mag{i,j} = double(MyConv(mag{i,j}, Mask));
            size(grad_x);
            size(grad_y);
            size(scale_img{i,j});
            dir{i,j}=cal_angle(grad_x,grad_y);
        end
    end
    %size(mag{1,1})
    %size(mag{1,2})
    for i=1:size(key_points,1)
      %     if( (key_points(i,1)-floor(w_size/2) >0)&& (key_points(i,2)-floor(w_size/2) >0)&&(key_points(i,1)+floor(w_size/2) < size(mag{key_points(i,4),1}))&& (key_points(i,2)+floor(w_size/2) < size(mag{key_points(i,4),2}) ) )
           mag_Window = mag{key_points(i,4),key_points(i,3)}(key_points(i,1)-floor(w_size/2):key_points(i,1)+floor(w_size/2),key_points(i,2)-floor(w_size/2):key_points(i,2)+floor(w_size/2));
           dir_Window=  dir{key_points(i,4),key_points(i,3)}(key_points(i,1)-floor(w_size/2):key_points(i,1)+floor(w_size/2),key_points(i,2)-floor(w_size/2):key_points(i,2)+floor(w_size/2));
           bin  = zeros(1,36);
           for j = 1:w_size
               for k = 1:w_size
                    bin(1,floor((dir_Window(j,k)/10)+1)) = bin(1,floor((dir_Window(j,k)/10)+1)) + mag_Window(j,k);
               end
           end
    
    [max_Val max_Ind] = max(bin);
    bin(max_Ind)=min(bin);
    [max_Val2 max_Ind2] = max(bin);
    if(max_Val2/max_Val >=0.8)
      keypoints_orien = [keypoints_orien;key_points(i,:) max_Ind2 scale*key_points(i,4)*power(power(2,0.5),key_points(i,3))];
    
    end
    keypoints_orien = [keypoints_orien;key_points(i,:) max_Ind scale*key_points(i,4)*power(power(2,0.5),key_points(i,3))];
    
        end
           
   % end
end


% function [ang] = cal_angle(grad_x,grad_y)
%             ang=zeros(size(grad_x));
%             for k=1:size(grad_x,1)
%                 for l=1:size(grad_x,2)
%                     if(grad_x(k,l)>0 && grad_y(k,l)>0)
%                          ang(k,l)=atand(grad_y(k,l)/grad_x(k,l));
%                     elseif(grad_x(k,l)<0 && grad_y(k,l)>0)
%                          ang(k,l)=atand(grad_y(k,l)/(grad_x(k,l))) + 180 ;
%                     elseif(grad_x(k,l)<0 && grad_y(k,l)<0)
%                          ang(k,l)=atand(abs(grad_y(k,l))/abs(grad_x(k,l))) + 180;
%                     elseif(grad_x(k,l)>0 && grad_y(k,l)<0)
%                          ang(k,l)=atand((grad_y(k,l))/(grad_x(k,l))) + 360;
%                     end
%                 end
%             end
% 
% end

