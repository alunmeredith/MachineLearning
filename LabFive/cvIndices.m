function [ fold ] = cvIndices( Y, k )
% Takes data / number of folds and computes random indices for each
% observations which can be subset later

n = length(Y);
w = floor(n/k);
fold = repmat(1:k,[w 1]);
fold = fold(:)';
ind = randperm(length(fold));
fold = fold(ind);

end

