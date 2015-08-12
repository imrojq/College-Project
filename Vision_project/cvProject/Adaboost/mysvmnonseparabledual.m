function [ alpha ] = mysvmnonseparabledual( X,Y,Kernel_fun,C ,p)

    H=(Kernel_fun(X,X).*(Y*Y'));
    
    f=-ones(size(X,1),1);
   
    A=-eye(size(X,1));
    a=zeros(size(X,1),1);
    m = size(Y,1);
    B = [Y';zeros(m-1,m)];
    n = size(X,1);
    b  = zeros(n,1);
    lb = zeros(n,1);
    up = ones(n,1).*p.*C; 
    options =  optimoptions('quadprog','Display','off');
    alpha = quadprog(H+eye(size(Y,1))*0.001,f,A,a,B,b,lb,up,[],options);
    
    ind=[];
    ind = find(alpha < power(10,-9));
    
     for i=1:length(ind)
         alpha(ind(i))=0;
     end

    
end

