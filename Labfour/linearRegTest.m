function [ RMSEtest, RMSEtrain, RMSEval, wMean ] = linearRegTest(Y,f,N,CV_FOLDS)
% Performs linear regression on the UCI data, if k is set to a value other
    % than one also performs cross validation

    % % load the data and normalise its mean/variance
    % load('redWine.mat');
    % [f, Y, N] = normalise(redWine);
    % 
    % % split into training / testing sets
    % % set aside 20% for testing set later
     ii = cvIndices(Y,CV_FOLDS);
     Ytest = Y(ii == 1, :);
     ftest = f(ii == 1, :);
     Ytrain = Y(ii ~= 1, :);
     ftrain = f(ii ~= 1, :);

    % basic linear Regression
    % linearReg(Y,f,'train');

    % consider cross val ind function
    iiCV = cvIndices(Ytrain, CV_FOLDS);
    RMSEtrain = zeros(CV_FOLDS,1);
    RMSEval = zeros(CV_FOLDS,1);
    for fold = 1:CV_FOLDS
        Ytr = Y(iiCV==fold, :);
        ftr = f(iiCV==fold, :);
        Yval = Y(iiCV~=fold, :);
        fval = f(iiCV~=fold, :);

        % Estimate regression model (w) on the training set
        [w, fhtr] = linearReg(Ytr, ftr, 'train');

        % Errors on training set
        RMSEtrain(fold) = sqrt( sum((fhtr - ftr).^2) / length(ftr) );

        % Errors on validation set set
        [wtsm, fhts] = linearReg(Yval, fval, w);
        RMSEval(fold) = sqrt( sum((fhts - fval).^2) / length(fval) );
        wCV(:,fold) = wtsm;
    end

    % Errors on test set
    wMean = mean(wCV, 2);
    [wMean, fhtest] = linearReg(Ytest, ftest, wMean);
    RMSEtest = sqrt( sum((fhtest - ftest).^2) / (N * 0.2) );
end
% SSEts is the error on the training data for each fold. If we assume it is
% normally distributed via the central limit theorem we can calculate a
% confidence interval for it.