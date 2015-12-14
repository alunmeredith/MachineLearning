% Load Boston Housing Data from UCI ML Repository
%
load -ascii housing.data;
% Normalize the data, zero mean, unit standard deviation
%
[N, p1] = size(housing); 
p = p1-1; % 1 - number of variables
Y = [housing(:,1:p)]; % Y: housing with final variable all ones
% ones(N,1)]; Removed the bias unit because not doing linear reg
for j=1:p  % normalised each value of y 
Y(:,j)=Y(:,j)-mean(Y(:,j));
Y(:,j)=Y(:,j)/std(Y(:,j));
end
f = housing(:,p1); % f is final variabe of housing
f = f - mean(f); % normalise f.
f = f/std(f);
