function [ err ] = find_err( ip,op,w )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    err=0;
    for i=1:size(ip,1)
        if((w(1)+w(2)*ip(i,1)+w(3)*ip(i,2)>0)&&op(i)== -1 ||(w(1)+w(2)*ip(i,1)+w(3)*ip(i,2)<0)&&op(i)==1)
            err=err+1;
        end
    end

end

