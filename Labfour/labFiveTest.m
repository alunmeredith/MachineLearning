% QUESTION 8 -------------------------------------------------------------
% Compare your results with the linear regression model of Lab 4. Does the
% use of a non-linear model improve predictions?
REPS = 10;
Ntrain = length(ltrain);

% Do linear regression on it
ltest = zeros(REPS,1);
ltrain = zeros(REPS,1);
for i = 1:REPS
    [ltest(i), ltrain(i)] = linearRegTest(Y,f,N);
end


% Do radial basis function on it
% Choose pointsPerCenter = 1.5 because yielded best error 
rtest=zeros(REPS,1);
rtrain=zeros(REPS,1);
for i = 1:REPS
    [rtest(i), rtrain(i)] = labFiveScript(round(Ntrain/1.5));
end

%Results
linTestError = mean(ltest);
linTestVar = var(ltest);
linTrainError = mean(ltrain);
linTrainVar = var(ltrain);

radTestError = mean(rtest);
radTestVar = var(rtest);
radTrainError = mean(rtrain);
radTrainVar = var(rtrain);

%Construct boxplots
figure(6),
boxplot(ltest, ltrain, rtest, radtrain)