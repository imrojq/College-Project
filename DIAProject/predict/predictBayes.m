function [c,p] = predictBayes(X,pC, phiC, phinC, num_labels)

num_cases=size(X,1);
result = ones(num_labels,num_cases);
X=X';

for c = 1 : num_labels
    tphiC=phiC(:,c) * ones(1,num_cases);
    tphinC = phinC(:,c) * ones(1,num_cases);
    pxgy=prod(tphiC.^X.*(1-tphiC).^(1-X));
    pxgny=prod(tphinC.^X.*(1-tphinC).^(1-X));
    pCgx = pxgy * pC(c) ./ ( pxgy + pxgny );
    result(c,:) =pCgx  ;
end

[c, p ] = max ( result , [] , 1);
p(p==10,:) =0;


end
