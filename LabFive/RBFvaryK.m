function [ RMSEtrainKMean, RMSEtestKMean ] = RBFvaryK( Y, f, ii, CentersVector, REPS, sigma)
%RBFvaryK runs RBF regression (labFiveSCript) for a variety of Ks. 
%   Detailed explanation goes here

% Collecting average of training and test errors for different values of K.
RMSEtestK = zeros(REPS,length(CentersVector));
RMSEtrainK = zeros(REPS,length(CentersVector));
for i = 1:REPS
    for k = 1:length(CentersVector)
        [RMSEtestK(i,k), RMSEtrainK(i,k)] = labFiveScript(CentersVector(k), f, Y,ii, 0, sigma, 'train');
    end
end

RMSEtrainKMean = mean(RMSEtrainK,1);
RMSEtrainKVar = var(RMSEtrainK,1);
RMSEtestKMean = mean(RMSEtestK,1);
RMSEtestKVar = var(RMSEtestK,1);

end

