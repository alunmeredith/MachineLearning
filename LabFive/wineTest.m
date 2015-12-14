% Loads either wine or housing data depending on which is commented out,
% computes both linear and RDF regression for a number of repititions and
% returns boxplots of training and testing errors. 
% ------------------------------------------------------------------------

% QUESTION 8 -------------------------------------------------------------
% Compare your results with the linear regression model of Lab 4. Does the
% use of a non-linear model improve predictions?

% Set the number of repitions and how the code is split
<<<<<<< HEAD
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
=======
REPS = 20;
TRAINFRAC = 0.8;
CV_FOLDS = 5;
SIGREPS = 10;

load('redWine.mat'); %returns "redWine" matrix
load -ascii housing.data; %returns "housing" matrix

%[f, Y, N] = normalise(redWine); %normalise the data
[f, Y, N] = normalise(housing); %normalise the data
Ntrain = TRAINFRAC*N;
Ntest = (1-TRAINFRAC)*N;
iiCV = cvIndices(Y, round(TRAINFRAC / (1-TRAINFRAC)));

% Do linear regression on it
ltest = zeros(REPS,1); % Initialise variables
ltrain = zeros(REPS,1);
for i = 1:REPS
    [ltest(i), ltrain(i)] = linearRegTest(Y,f,N);
end
>>>>>>> ba3add8147de0f04dbc2bab201cc0314ca2ae952


Xtrain = Y((iiCV~=1)&(iiCV~=CV_FOLDS + 2), :);
Ntrain = length(Xtrain);
<<<<<<< HEAD
% Choose appropriate value for sigma
=======
>>>>>>> ba3add8147de0f04dbc2bab201cc0314ca2ae952
sig = zeros(SIGREPS,1);
for i = 1:SIGREPS
    sig(i) = norm( Xtrain(ceil(rand*Ntrain),:) - Xtrain(ceil(rand*Ntrain),:) );
end
sigma = mean(sig);

% Do radial basis function on it 
% Choose pointsPerCenter = 1.5 because yielded best error 
<<<<<<< HEAD
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
=======
rtest=zeros(REPS,1);
rtrain=zeros(REPS,1);
for i = 1:REPS
    [rtest(i), rtrain(i)] = labFiveScript(round(Ntrain/1.5), f, Y, ii, 0, sigma, 'train');
end

%Results
linTestError = mean(mean(ltest));
linTestVar = mean(var(ltest));
linTrainError = mean(mean(ltrain));
linTrainVar = mean(var(ltrain));

radTestError = mean(mean(rtest));
radTestVar = mean(var(rtest));
radTrainError = mean(mean(rtrain));
radTrainVar = mean(var(rtrain));

%Construct boxplots

index1 = [ones(REPS,1); 2*ones(REPS,1)]; % 
linBoxplots = [ltest;rtest]; 
RDFboxplots = [ltrain;rtrain];
index2 =  [3*ones(REPS,1); 4*ones(REPS,1)];
figure(1),
subplot(1,2,1),
boxplot(linBoxplots,index1,'labels', {'Linear-Test', 'Radial-Test'});
subplot(1,2,2),
boxplot(RDFboxplots,index2, 'labels', {'Linear-Train', 'Radial-Train'});
>>>>>>> ba3add8147de0f04dbc2bab201cc0314ca2ae952
