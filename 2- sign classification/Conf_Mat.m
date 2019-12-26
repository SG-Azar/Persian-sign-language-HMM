function [confmat, acc, acc_O, acc_A] = Conf_Mat(result)
% Compute the results
[num_sgn,num_test]=size(result);
num_all=num_sgn*num_test;
confmat=zeros(num_sgn,num_sgn);
acc = zeros(num_sgn,1);
for i=1:num_sgn
    for j=1:num_sgn
    counter=find(result(i,:)==j);
    confmat(i,j)=numel(counter);
    end
end
for i=1:num_sgn
    acc(i) = confmat(i,i)/num_test;
end
acc_O = sum(diag(confmat))/num_all;
accO=acc_O*100;
acc_A = mean(acc);
fprintf('The overall accuracy is: %d',accO);
end

