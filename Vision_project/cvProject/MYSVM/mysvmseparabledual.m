function [alpha] = mysvmseparabledual(X, Y)
    
    H= (X*X').*(Y*Y');
    size(H);
    f=-ones(length(H),1);
    A=-eye(length(H));
    a=zeros(length(H),1);

    B = [Y';zeros(length(Y')-1,length(Y'))];

    b= zeros(length(H),1);
    options =  optimoptions('quadprog','Display','off');
     
    alpha = quadprog(H+eye(length(Y))*0.001,f,A,a,B,b,[],[],[],options);

    ind=[];
    ind = find(alpha < power(10,-7));
    
     for i=1:length(ind)
         alpha(ind(i))=0;
     end

end

