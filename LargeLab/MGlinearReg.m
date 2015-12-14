function [Pred, RMSEtrain, Dtrain, weights] = MGlinearReg(Xtrain, Ttrain, p, N)
%% Constructs a design matrix and conducts linear regression evaluating 
%training set and testing set accuracy
Ntrain = length(Xtrain);
Ntest = N - Ntrain;
%% Construct a design matrix of the last 20 datapoints
% Create a design matrix for training data
Dtrain = zeros(Ntrain - p, p);
% first row is first 20 datapoints
for minRow = 1:(Ntrain-p)
    for i = 1:p
        Dtrain(minRow,i) = Xtrain(minRow+i-1)';
    end
end

%% Build a linear predictor from the training data
% Train weights
Xtarget = Xtrain(1+p:Ntrain);
Xtarget = Xtarget(1:length(Xtarget-1));
Ttarget = Ttrain(1+p:Ntrain);
%[w, Ptrain] = linearReg(D,Xtrain(1+p:Ntrain),'train');
weights = Dtrain\Xtarget;
Pred = Dtrain*weights;
Pred = Pred(1:length(Pred-1));
RMSEtrain = sum(sqrt((Pred - Xtarget).^2)/length(Xtarget));

% Plot its 'prediction'
 figure(1),
 plot(Xtarget,Pred, 'r');
end