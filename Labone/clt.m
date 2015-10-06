function [  ] = clt( N )
% Demonstrates the central limit theorem for variable sample sizes (n)
%   % This function evaluates the difference in sum between two samples of 12
% uniformly distributed numbers. It takes a sample of this statistic N
% times and plots the output of the sample into a histogram.

x1 = zeros(N,1);
x2 = zeros(N,1);
for n=1:N
    x1(n,1) = sum(rand(12,1)) - sum(rand(12,1));
end;

hist(x1,40);
end

