function [ RMSEtrainKMean, RMSEtestKMean ] = RBFvaryK( Y, f, ii, cvFolds, CentersVector, sigma)
%RBFvaryK runs RBF regression (labFiveSCript) for a variety of Ks. 
%   Detailed explanation goes here

% Collecting average of training and test errors for different values of K.
RMSEtestK = zeros(cvFolds,length(CentersVector));
RMSEtrainK = zeros(cvFolds,length(CentersVector));
for k = 1:length(CentersVector)
    [RMSEtestK(:,k), RMSEtrainK(:,k)] = crossvalRBF( CentersVector(k), f, Y, ii, cvFolds, sigma, 'train');
end


RMSEtrainKMean = mean(RMSEtrainK,1);
RMSEtrainKVar = var(RMSEtrainK,1);
RMSEtestKMean = mean(RMSEtestK,1);
RMSEtestKVar = var(RMSEtestK,1);

end

