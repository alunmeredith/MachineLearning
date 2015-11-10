function [ RMSEtest, RMSEtrain, RMSEval, wMean ] = linearRegTest( )
% load the data and normalise its mean/variance
loadData

% split into training / testing sets
% set aside 20% for testing set later
ii = cvIndices(Y,5);
Ytest = Y(ii == 1, :);
ftest = f(ii == 1, :);
Ytrain = Y(ii ~= 1, :);
ftrain = f(ii ~= 1, :);

% basic linear Regression
linearReg(Y,f,'train');


% consider cross val ind function
k = 1;
fold = cvIndices(Ytrain, k);
for i = 1:k

Ytr = Y(fold == i, :);
ftr = f(fold == i, :);
Yts = Y(fold ~= i, :);
fts = f(fold ~= i, :);


% Estimate regression model (w) on the training set
[w, fhtr] = linearReg(Ytr, ftr, 'train');

% Errors on training set
RMSEtrain(i) = sqrt( sum((fhtr - ftr).^2) / (N * 0.8 * 0.9) );

% Errors on validation set set
[wtsm fhts] = linearReg(Yts, fts, w);
RMSEval(i) = sqrt( sum((fhts - fts).^2) / (N * 0.8 * 0.1) );
wCV(:,i) = wtsm;

end

% Errors on test set
wMean = mean(wCV, 2);
[wMean fhtest] = linearReg(Ytest, ftest, wMean);
RMSEtest = sqrt( sum((fhtest - ftest).^2) / (N * 0.2) );
% Errors on test set

end
% SSEts is the error on the training data for each fold. If we assume it is
% normally distributed via the central limit theorem we can calculate a
% confidence interval for it.