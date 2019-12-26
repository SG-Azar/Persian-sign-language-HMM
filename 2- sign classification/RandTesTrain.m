function [Tr_Idx, Ts_Idx] = RandTesTrain(Per)
% Selects Per% of the data as train data and gives the train-test index
P=randperm(60);
Tr_Num=ceil(.6*Per);
Tr_Idx=P(1:Tr_Num);
Ts_Idx=P(Tr_Num+1:end);
end

