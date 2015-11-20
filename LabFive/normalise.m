function [ f, Y, N ] = normalise( Data )
% Seperates the variables (S) from the target (y) and normalises them

[N, p1] = size(Data); 
p = p1-1; % 1 - number of variables
Y = [Data(:,1:p)]; % Y: housing without bias layer
% ones(N,1)]; Removed the bias unit because not doing linear reg
for j=1:p  % normalised each value of y 
Y(:,j)=Y(:,j)-mean(Y(:,j));
Y(:,j)=Y(:,j)/std(Y(:,j));
end
f = Data(:,p1); % f is final variabe of housing
f = f - mean(f); % normalise f.
f = f/std(f);


end