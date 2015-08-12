clear
clc
addpath('SIFT/');
%run('vlfeat-0.9.18/toolbox/vl_setup')
imgPath = 'LSP/store/*.jpg';
imgType = '*.jpg'; % change based on image type
images  = dir(imgPath);


 model_pos = cell(1,length(images));
 model_des = cell(1,length(images));
 

 t=strcat('LSP/store/');

 for idx = 1:41
    path=char(strcat(t,images(idx).name));
    %Seq{idx} =  imread(path);
    S =  single(imread((path)));
   
    [a b] = MySIFT(S);
    idx
    disp(idx)
    model_pos{idx} = a';
    model_des{idx} = b;
 end

 
% loading  MIT forest 
t=strcat('LSP/store/');
model_pos_store = model_pos';
model_des_store = model_des;
save('descript_store.mat','model_pos_store','model_des_store');
 
