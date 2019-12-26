%%%% HMM-PSL 
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
% edit this line:
addpath(genpath('D:/HMM_KM/HMMall')); % add KevinMurphy toolbox's path

%% Initialize:
M = 3; % number of Gaussians
Q = 12; % number of states

%% Training HMMs for each sign:
Num_sgns=8; % number of signs
Per=20;      % percent of the data used for training
Train_Ind=[]; 
Test_Ind=[];
% cells for saving the trained models:
prior=cell(Num_sgns,1);
transmat=cell(Num_sgns,1);
mu=cell(Num_sgns,1);
Sigma=cell(Num_sgns,1);
mixmat=cell(Num_sgns,1);

for i=1:Num_sgns % train HMM for each sign
    % load data:
    filename=sprintf('NormSign%d.mat',i);
    load(filename);
    data=norm_data(1:5,:,:);  %  
    
    % get Train data:
    [Tr_Idx, Ts_Idx] = RandTesTrain(Per); % select train and test indices
    Train_Ind=[Train_Ind;Tr_Idx]; % stack the train indices of all signs
    Test_Ind=[Test_Ind;Ts_Idx];   % stack the test indices of all signs
    
    data_train=data(:,:,Tr_Idx);  
    O=size(data_train,1);      % dimension of the observation
    T=size(data_train,2);      % length of the sequences
    nex=size(data_train,3);      % number of train data
    
    % HMM initial guess:
    prior0 = normalise(rand(Q,1));        % pi : Qx1
    transmat0 = mk_stochastic(rand(Q,Q)); % A  : QxQ

    [mu0, Sigma0] = mixgauss_init(Q*M, reshape(data_train, [O T*nex]),'diag','kmeans'); %'full', 'diag' or 'spherical'
    mu0 = reshape(mu0, [O Q M]);
    
    % Train HMMs :  
    Sigma0 = reshape(Sigma0, [O O Q M]);
    mixmat0 = mk_stochastic(rand(Q,M));

    [LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
    mhmm_em(data, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 20);
    
    % saving the models for testing
    prior{i}=prior1;
    transmat{i}=transmat1;
    mu{i}=mu1;
    Sigma{i}=Sigma1;
    mixmat{i}=mixmat1;
end

%% Test HMM
num_test=size(Test_Ind,2);  % number of test data for each sign
MinLogLik=zeros(Num_sgns,num_test);
for i=1:Num_sgns 
    % load data:
    filename=sprintf('NormSign%d.mat',i);
    load(filename);
    data=norm_data(1:5,:,:);  % 
    % tets data for sign i
    data_test=data(:,:,Test_Ind(i,:));
    
    LogLik=zeros(Num_sgns,num_test);
    for j=1:num_test % test for j'th test data of sign i
         for k=1:Num_sgns
             LogLik(k,j)= mhmm_logprob(data_test(:,:,j),prior{k},transmat{k},mu{k},Sigma{k},mixmat{k});
         end
    end
    
    [~,MinLogLik(i,:)]=max(LogLik);
 
end

%% Confusion matrix:

[confmat, acc, acc_O, acc_A] = Conf_Mat(MinLogLik);




