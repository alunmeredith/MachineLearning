function [ ] = uniformHist( n )
%Uniform distribution
%   randomly generates 1000 random  uniform numbers
%   bins and then plots a bar chart (fake histogram)

x = rand(n,1);
[xx, nn] = hist(x);
bar(xx);
end

