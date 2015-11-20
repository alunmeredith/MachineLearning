%Loads either the the housing or wine data depending on which you comment
%out, seperates into testing and training set computes radial basis
%regression for VARYING NUMBER OF CENTERS and outputs the results as a
%graph
% ------------------------------------------------------------------------

% Initialising data here so number of basis functions can be set as a
% parameter of the length of the data.
% Set the number of repitions and how the code is split
REPS = 2;
TRAINFRAC = 0.8;
CENTERS_VECTOR = 1:50;

load -ascii housing.data;
load('redWine.mat');

[f, Y, N] = normalise(housing);
%[f, Y, N] = normalise(redWine);

% Seperate into training set and testing set
ii = cvIndices(Y, round(TRAINFRAC / (1-TRAINFRAC)));
% Run RBF regression on the vector of number of centers
[RMSEtrainKMean, RMSEtestKMean] = RBFvaryK(Y, f, ii, CENTERS_VECTOR, REPS);

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


