
function [ang] = cal_angle(grad_x,grad_y)
            ang=zeros(size(grad_x));
            for k=1:size(grad_x,1)
                for l=1:size(grad_x,2)
                    if(grad_x(k,l)>0 && grad_y(k,l)>0)
                         ang(k,l)=atand(grad_y(k,l)/grad_x(k,l));
                    elseif(grad_x(k,l)<0 && grad_y(k,l)>0)
                         ang(k,l)=atand(grad_y(k,l)/(grad_x(k,l))) + 180 ;
                    elseif(grad_x(k,l)<0 && grad_y(k,l)<0)
                         ang(k,l)=atand(abs(grad_y(k,l))/abs(grad_x(k,l))) + 180;
                    elseif(grad_x(k,l)>0 && grad_y(k,l)<0)
                         ang(k,l)=atand((grad_y(k,l))/(grad_x(k,l))) + 360;
                    end
                end
            end

end
