% Loads either wine or housing data depending on which is commented out,
% computes both linear and RDF regression for a number of repititions and
% returns boxplots of training and testing errors. 
% ------------------------------------------------------------------------

% QUESTION 8 -------------------------------------------------------------
% Compare your results with the linear regression model of Lab 4. Does the
% use of a non-linear model improve predictions?

% Set the number of repitions and how the code is split
CV_FOLDS = 20;
CENTRES = 50;
SIGREPS = 100;

% load('news.mat'); %returns "news" matrix
load('redWine.mat');
%load -ascii housing.data; %returns "housing" matrix

[f, Y, N] = normalise(redWine); %normalise the data
%[f, Y, N] = normalise(news); %normalise the data
%[f, Y, N] = normalise(housing); %normalise the data
iiCV = cvIndices(Y, CV_FOLDS);
Ntrain = length(iiCV ~= CV_FOLDS);
Ntest = length(iiCV == CV_FOLDS);

% Do linear regression on it
[ltest, ltrain, lval] = linearRegTest(Y,f,N,CV_FOLDS);


Xtrain = Y((iiCV~=1)&(iiCV~=CV_FOLDS + 2), :);
Ntrain = length(Xtrain);
% Choose appropriate value for sigma
sig = zeros(SIGREPS,1);
for i = 1:SIGREPS
    sig(i) = norm( Xtrain(ceil(rand*Ntrain),:) - Xtrain(ceil(rand*Ntrain),:) );
end
sigma = mean(sig);

% Do radial basis function on it 
% Choose pointsPerCenter = 1.5 because yielded best error 
[rtest, rtrain] = crossvalRBF(CENTRES, f, Y, iiCV, CV_FOLDS, sigma, 'train');

%Construct boxplots
index1 = [ones(CV_FOLDS,1); 2*ones(CV_FOLDS,1)]; % 
testBoxplots = [lval;rtest]; 
trainBoxplots = [ltrain;rtrain];
index2 =  [3*ones(CV_FOLDS,1); 4*ones(CV_FOLDS,1)];

figure(1),
subplot(1,2,1),
boxplot(testBoxplots,index1,'labels', {'Linear', 'Radial'});
title('Validation set', 'FontSize', 16);
ylabel('RMSE', 'FontSize', 14);
subplot(1,2,2),
boxplot(trainBoxplots,index2, 'labels', {'Linear', 'Radial'});
title('Training set', 'FontSize', 16);
