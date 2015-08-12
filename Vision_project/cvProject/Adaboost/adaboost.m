function [op] = adaboost(X,Y)

	t = 500;

	alpha = zeros(t,1);
	x = X;
	y = Y;
	
    alpha = zeros(t,1);
    iterations = 0;
    model = cell(t,1);
    flag = ones(t,1);

    tr_Idx = x;
    te_Idx = y;
    tr_ip=x;
    tr_op=y;
    
    d = zeros(length(tr_ip),1);
    d = d+(1/length(d));    
    
    otp = zeros(length(tr_op),1);
    for i=1:t

        iterations = iterations + 1;
        model{i} = svmtrain(tr_ip,tr_op, 'kernel_function', 'linear', 'boxconstraint', n*d);
        op = svmclassify(model{i}, tr_ip);
        err = tr_op-op;
        err(err~=0) = 1;
        err = err.*d;
        err = sum(err);

        if err == 0.5
            iterations = iterations - 1;
            break;
        end

        if err > 0.5
            err = 1-err;
            flag(i) = -1;
        end
        alpha(i) = 0.5*log( (1-err)/err );

        temp = tr_op.*op.*flag(i);
        temp = temp * alpha(i);
        temp = -temp;
        d = d.*exp(temp);

        z = sum(d);
        d = d/z;
        
        temp = svmclassify(model{i}, tr_ip);
        otp = otp + temp*alpha(i)*flag(i);
        
        op = sign(otp);
        err = op-tr_op;
        err(err~=0) = 1;
        err = sum(err)/length(tr_op);
        
        trainacc(i,fold) = 1-err;

    end
    
    op = zeros(length(tr_op),1);
    for i=1:iterations
        temp = svmclassify(model{i}, te_ip);
        op = op + temp*alpha(i)*flag(i);
    end

end    
