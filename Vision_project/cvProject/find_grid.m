function [ grid ] =  find_grid(level) 
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    grid = cell(power(2,level),power(2,level));
    
    for i=1:power(2,level)
        grid{i,1} = [i 1];
    end
    for i=1:power(2,level)
        grid{1,i} = [1 i];
    end
    

    for i=2:size(grid,1)
        for j=2:size(grid,1)
            grid{i,j}= [i j];
        end
    end

end

