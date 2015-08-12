function [ alpha ] = mysvmnonseparabledual( X,Y,Kernel_fun,C )

    H=(Kernel_fun(X,X).*(Y*Y'));
    
    f=-ones(length(X),1);
   
    A=-eye(length(X));
    a=zeros(length(X),1);

    B = [Y';zeros(length(Y')-1,length(Y'))];

    b  = zeros(length(X),1);
    lb = zeros(length(X),1);
    up = ones(length(X),1); 
    options =  optimoptions('quadprog','Display','off');
    alpha = quadprog(H+eye(length(Y))*0.001,f,A,a,B,b,lb,up*C,[],options);
    
    ind=[];
    ind = find(alpha < power(10,-7))
    
     for i=1:length(ind)
         alpha(ind(i))=0;
     end

    
end

