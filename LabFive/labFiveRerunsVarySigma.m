%Loads either the the housing or wine data depending on which you comment
%out, seperates into testing and training set computes radial basis
%regression for VARYING NUMBER OF CENTERS and outputs the results as a
%graph
% ------------------------------------------------------------------------

% Initialising data here so number of basis functions can be set as a
% parameter of the length of the data.
% Set the number of repitions and how the code is split
REPS = 10;
TRAINFRAC = 0.8;
CENTERS_VECTOR = 50;
CV_FOLDS = 0;
SIG_VECTOR = (10:100)/10;
load -ascii housing.data;
load('redWine.mat');

[f, Y, N] = normalise(housing);
%[f, Y, N] = normalise(redWine);

% Seperate into training set and testing set
ii = cvIndices(Y, round(TRAINFRAC/(1-TRAINFRAC)));

Xtrain = Y(ii~=1, :);
Ntrain = length(Xtrain);

RMSEtest = zeros(length(SIG_VECTOR),1);
RMSEtrain = zeros(length(SIG_VECTOR),1);
for i = 1:length(SIG_VECTOR)
    % Run RBF regression on the vector of number of centers
    [ RMSEtest(i), RMSEtrain(i)] = labFiveScript( CENTERS_VECTOR, f, Y, ii, CV_FOLDS, SIG_VECTOR(i), 'train');
end

% Plot Results
figure(2),
subplot(3,1,1),
plot(SIG_VECTOR, RMSEtrain, 'r.', 'LineWidth', 1), grid on
title('Training Set', 'FontSize', 16);
xlabel('Variance in Basis Function', 'FontSize', 14);
ylabel('RMSE', 'FontSize', 14);

subplot(3,1,2),
plot(SIG_VECTOR, RMSEtest,'b.', 'LineWidth', 1), grid on
title('Testing Set', 'FontSize', 16);
xlabel('Variance in Basis Function', 'FontSize', 14);
ylabel('RMSE', 'FontSize', 14);

subplot(3,1,3),
plot(SIG_VECTOR, RMSEtest - RMSEtrain, 'g.', 'LineWidth', 1), grid on
title('Difference', 'FontSize', 16);
xlabel('Variance in Basis Function', 'FontSize', 14);
ylabel('RMSE', 'FontSize', 14);


