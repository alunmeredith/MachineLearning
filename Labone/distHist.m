function [ x ] = distHist( n, dist )
%Function returns a histogram of different distributions and sample sizes
if strcmp(dist, 'gaussian')
    x = randn(n);
elseif strcmp(dist,'uniform')
    x = rand(n,1);
else error('Distribution not found');
end
[xx,nn] = hist(x);
bar(xx);
end

