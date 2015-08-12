function normdata = normalizeData(X)
    [r,c] = size(X);
    normdata = zeros(r,c);
    for i=1:c
        if max(X(:,i))-min(X(:,i))~=0
            normdata(:,i) = (X(:,i)-min(X(:,i)))/(max(X(:,i))-min(X(:,i)));
        end
    end
end