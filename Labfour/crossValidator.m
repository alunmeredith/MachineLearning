% %   Takes input the target f and data Y, splits the data into testing and
% %   training sets, then runs a cross validation on it.

% Initialising data here so number of basis functions can be set as a
% parameter of the length of the data.
% Set the number of repitions and how the code is split
K = 12;
REPS = 2;
TRAINFRAC = 0.8;
CENTERS_VECTOR = 1:50;
cvFolds = 4;
SIGREPS = 20;

load -ascii housing.data;
load('redWine.mat');


[f, Y, N] = normalise(housing);
%[f, Y, N] = normalise(redWine);
% Creates a different training / test set index ii (splits into
% training,test AND cv indices. Then runs labFiveScript on each of the
% indicies related to cv training. 
% OVERRIDES TRAINFRAC

iiCV = cvIndices(Y, cvFolds + 2);

% Estimate sigma as the average distance between points in a sample 
Xtrain = Y((iiCV~=1)&(iiCV~=cvFolds + 2), :);
Ntrain = length(Xtrain);
sig = zeros(SIGREPS,1);
for i = 1:SIGREPS
    sig(i) = norm( Xtrain(ceil(rand*Ntrain),:) - Xtrain(ceil(rand*Ntrain),:) );
end
sigma = mean(sig);

% Then vary the estimate, computing changes in the CVerror for each
RMSEval = zeros(cvFolds,1);
RMSEtrain = zeros(cvFolds,1);
lambda = zeros(cvFolds,K);
for cv = 1:cvFolds
   [RMSEval(cv), RMSEtrain(cv), lambda(cv,:)] = labFiveScript( K, f, Y, iiCV, cv, sigma, 'train'); 
end


% Run RBF regression on the vector of number of centers
[RMSEtrainKMean, RMSEtestKMean] = RBFvaryK(Y, f, iiCV, CENTERS_VECTOR, REPS, sigma);

% Plot Results
figure(2),
subplot(3,1,1),
plot(CENTERS_VECTOR, RMSEtrainKMean, 'r.', 'LineWidth', 1), grid on
title('Variation in training RMSE with #centers', 'FontSize', 16);
xlabel('Number of Basis Functions', 'FontSize', 14);
ylabel('RMSE', 'FontSize', 14);

subplot(3,1,2),
plot(CENTERS_VECTOR, RMSEtestKMean,'b.', 'LineWidth', 1), grid on
title('Variation in testing RMSE with #centers', 'FontSize', 16);
xlabel('Number of Basis Functions', 'FontSize', 14);
ylabel('RMSE', 'FontSize', 14);

subplot(3,1,3),
plot(CENTERS_VECTOR, RMSEtestKMean - RMSEtrainKMean, 'g.', 'LineWidth', 1), grid on
title('Difference between training and testing RMSE', 'FontSize', 16);
xlabel('Number of Basis Functions', 'FontSize', 14);
ylabel('RMSE', 'FontSize', 14);

