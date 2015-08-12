function [J grad] = costFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));


m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));



X=[ones(m,1) X];
z2=X*Theta1';
a2=sigmoid(z2);
a2=[ones(m,1) a2];
z3=a2*Theta2';
a3=sigmoid(z3);

yIndex=y(1,1);
temp=zeros(1,num_labels);
temp(1,yIndex)=1;
yNew=temp;


for i=2:m
 yIndex=y(i,1);
 temp=zeros(1,num_labels);
 temp(1,yIndex)=1;
 yNew=[yNew ; temp];
end

y=yNew;
sum=0;
for j=1:m
    %for k=1:m
     sum=sum+((-y(j,:)*log(a3(j,:)'))-((ones(1,num_labels)-y(j,:))*log(ones(num_labels,1)-a3(j,:)')));
end
J=sum/m;

%J=J+(sum(sum(Theta1(2:end).^2))+sum(sum(Theta1(2:end).^2)))*(lambda/(2*m));
sumreg=0;
for i=1:size(Theta1,1)
    for j=2:size(Theta1,2)
        sumreg=sumreg+(Theta1(i,j)^2);
    end
end

for i=1:size(Theta2,1)
    for j=2:size(Theta2,2)
        sumreg=sumreg+(Theta2(i,j)^2);
    end
end

       
J=J+(sumreg*(lambda/(2*m)));




%J=J+(sum(theta(2:end).^2)*(lambda/(2*m)));

%backprop 
delTheta1=zeros(size(Theta1,1),size(Theta1,2));
delTheta2=zeros(size(Theta2,1),size(Theta2,2));
for i=1:m
    del_3=a3(i,:)'-y(i,:)';
    del_2=(Theta2'*del_3).*sigmoidGradient([1;z2(i,:)']);
    del_2=del_2(2:end);
    delTheta1=delTheta1+(del_2*X(i,:));
    delTheta2=delTheta2+(del_3*a2(i,:));
end

    Theta1_grad=delTheta1./m;
    Theta2_grad=delTheta2./m;
    

Theta1_grad(:,2:end)=Theta1_grad(:,2:end)+(lambda/(m)).*Theta1(:,2:end);
Theta2_grad(:,2:end)=Theta2_grad(:,2:end)+(lambda/(m)).*Theta2(:,2:end);



































% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
