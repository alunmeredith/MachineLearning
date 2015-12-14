function [ROC thRange] = ROCcalc( wF, X1, X2 )
%ROCcalc Generates an ROC curve from the vectorised equation of a straight
%line and the positions of observations from each of two distributions.
N = length(X1);
% histograms of the distribution of projections. 

% project data onto line: 
% Linear projection = special case matrix transform Y = X*A, where A is a vector. (n-1 dimensional plane)
p1 = X1 * wF;
p2 = X2 * wF;

% calculates range of projected data along the line. 
plo = min([p1; p2]);
phi = max([p1; p2]);
% returns position (nn) and value (xx) of hist
[nn1, xx1] = hist(p1);
[nn2, xx2] = hist(p2);
hhi = max([nn1 nn2]);
% plots histograms next to one another
figure(2), 
subplot(211), bar(xx1, nn1);
axis([plo phi 0 hhi]);
title('Distribution of Projections', 'FontSize', 16)
ylabel('Class 1', 'FontSize', 14)
subplot(212), bar(xx2, nn2);
axis([plo phi 0 hhi])
ylabel('Class 2', 'FontSize', 14)

% Question 5 ===================================================
%  Compute Reciever Operating Characteristic (ROC) curve. 

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

