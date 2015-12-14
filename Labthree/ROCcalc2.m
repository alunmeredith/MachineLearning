function [ ROC ] = ROCcalc2( wF, p1, p2 )
%ROCcalc Generates an ROC curve from the vectorised equation of a straight
%line and the positions of observations from each of two distributions.

% Question 5 ===================================================
%  Compute Reciever Operating Characteristic (ROC) curve. 
% returns position (nn) and value (xx) of hist of probabilities
N = length(p1);

[nn1, xx1] = hist(p1);
[nn2, xx2] = hist(p2);

thmin = min([xx1 xx2]);
thmax = max( [xx1 xx2]);

rocResolution = 50; %number of bins when sampling ROC
thRange = linspace(thmin, thmax, rocResolution);
ROC = zeros(rocResolution, 2);
for jThreshold = 1:rocResolution %loop over each bin
    % Classify all values > threshold == class 1
    threshold = thRange(jThreshold);
    % True positive rate = % of dist1 values higher than threshold
    tPos = length(find(p1 > threshold))*100 / N;
    % False positive rate = % of dist2 values higher than threshold
    fPos = length(find(p2 > threshold))*100 / N;
    ROC(jThreshold,:) = [fPos tPos];
end


end

