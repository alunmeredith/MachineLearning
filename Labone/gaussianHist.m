function [ ] = gaussianHist( n, dist )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if strcmp(dist, 'gaussian')
    x = randn(n);
elseif strcmp(dist,'uniform')
    x = rand(n,1);
elseif strmp(dist, 'exponential')
    x = exprnd(1,n,1);
else
    error('Distribution not found');
end

[xx,nn] = hist(x);
bar(xx);

end

