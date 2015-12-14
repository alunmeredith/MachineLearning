%Loads either the the housing or wine data depending on which you comment
%out, seperates into testing and training set computes radial basis
%regression for VARYING NUMBER OF CENTERS and outputs the results as a
%graph
% ------------------------------------------------------------------------

% Initialising data here so number of basis functions can be set as a
% parameter of the length of the data.
% Set the number of repitions and how the code is split
CENTERS_VECTOR = 1:150;
CV_FOLDS = 10;
SIGREPS = 1000;

load -ascii housing.data;
load('redWine.mat');

%[f, Y, N] = normalise(housing);
[f, Y, N] = normalise(redWine);

% Seperate into training set and testing set
ii = cvIndices(Y, CV_FOLDS);

Xtrain = Y(ii~=1, :);
Ntrain = length(Xtrain);

sig = zeros(SIGREPS,1);
for i = 1:SIGREPS
    sig(i) = norm( Xtrain(ceil(rand*Ntrain),:) - Xtrain(ceil(rand*Ntrain),:) );
end
sigma = mean(sig);

% Run RBF regression on the vector of number of centers
[RMSEtrainKMean, RMSEtestKMean] = RBFvaryK(Y, f, iiCV, CV_FOLDS, CENTERS_VECTOR, sigma);

% Plot Results
figure(2),
subplot(3,1,1),
plot(CENTERS_VECTOR, RMSEtrainKMean, 'r.', 'LineWidth', 1), grid on
title('Training Set', 'FontSize', 16);
xlabel('Number of Basis Functions', 'FontSize', 14);
ylabel('RMSE', 'FontSize', 14);

subplot(3,1,2),
plot(CENTERS_VECTOR, RMSEtestKMean,'b.', 'LineWidth', 1), grid on
title('Testing Set', 'FontSize', 16);
xlabel('Number of Basis Functions', 'FontSize', 14);
ylabel('RMSE', 'FontSize', 14);

subplot(3,1,3),
plot(CENTERS_VECTOR, RMSEtestKMean - RMSEtrainKMean, 'g.', 'LineWidth', 1), grid on
title('Test - Training set RMSE', 'FontSize', 16);
xlabel('Number of Basis Functions', 'FontSize', 14);
ylabel('RMSE', 'FontSize', 14);


