function [img] = MyScaleSpace(Image)
    
   % Image=rgb2gray(Image);
   % Image=double(Image);
    k=sqrt(2);
    oct=1;
    scales=5;
    size=9;
    img = cell(oct,scales);
    sigma=0.6;
    for i=1:oct
        l_sigma=sigma;
        for j=1:scales
            Mask = MyGauss(l_sigma,size);
            img{i,j} = MyConv(Image, Mask);
            l_sigma = l_sigma*k;        
        end
        sigm=sigma*2;
        Image = Image(1:2:end, 1:2:end,:);
    end    
end