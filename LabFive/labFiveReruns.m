% initial run
[RMSEtest, RMSEtrain] = labFiveScript(round(Ntrain/10));

% Collecting average of training and test errors for different values of K.
for i = 1:10
    for k = 1:10
        [RMSEtestK(i,k), RMSEtrainK(i,k)] = labFiveScript(round(Ntrain/k));
    end
end