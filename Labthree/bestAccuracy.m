function [ bestAcc, bestThresh ] = bestAccuracy( p1, p2, thRange )
% compute classificaiton accuracy for the best choice of decision threshold
% as a member of thRange. Only works for N1 = N2 = N.
 
N = length(p1);
bestAcc = 0;
bestThresh = 0;
for i = 1:50
    threshold = thRange(i);
    acc = (length(find(p1 > threshold)) + length(find(p2 < threshold))) / (2*N);
    if (acc > bestAcc)
        bestAcc = acc;
        bestThresh = thRange(i);
    end
end
end

