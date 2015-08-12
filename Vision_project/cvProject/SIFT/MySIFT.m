function [Keypoints, Descriptors] = MySIFT(ImageIn)
   
    [m n d] = size(ImageIn);
    if(d>1)

        ImageIn = rgb2gray(ImageIn);
        ImageIn = double(ImageIn);
    
        
    end
    scalespace = MyScalespace(ImageIn);
    DOG = MyDoG(scalespace);
    
    Keypoints  =MyKeypointDetect( DOG );
    Eliminated_keypoints = MyEliminateKeypoints(DOG, Keypoints );
    keypoints_orien  = MyAssignOrientation( scalespace, Eliminated_keypoints);
    Descriptors  =MyKeypointDescriptor( scalespace,keypoints_orien);
    Keypoints=[];
    k=sqrt(2);
%     for i=1:size(keypoints_orien,1)
%        Keypoints = [Keypoints;keypoints_orien(i,:) 0.6*power(k,keypoints_orien(i,4)-1)*power(power(2,0.5),keypoints_orien(i,3))];
%     end
    
    Keypoints=keypoints_orien;
    Keypoints(:,4)=[];
    Keypoints(:,4)=[];
    
    %imshow((DOG{1,2}));hold on; plot(keypoints_orien(:,2),keypoints_orien(:,1),'r*');
end

