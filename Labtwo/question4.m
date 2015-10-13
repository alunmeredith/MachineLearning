% PERCEPTRON LEARNING: CODE SNIPPET
% X N by 2 Matrix of data
% y classlabels -1 or +1
% include column of ones for bias
N1 = length(X1);
N2 = length(X2);
N = N1 + N2;
X = [X1, ones(N1,1); X2, ones(N2,1)]; %include bias unit
y = [ones(N2,1); (-1)*ones(N2,1)];

% Separate into training and test sets
ii = randperm(N);
Xtr = X(ii(1:N/2),:);
ytr = y(ii(1:N/2),:);
Xts = X(ii(N/2+1:N),:);
yts = y(ii(N/2+1:N),:);

% initialize weights
w = randn(3,1);

% Error correcting learning
eta = 0.001;
PercentageError = zeros(1,20);
for k = 1:5000
    for iter = 1:50
        j = ceil(rand*N/2); % random integer index of training set observation 
        if ( ytr(j)*Xtr(j,:)*w < 0 ) %if sign of prediction X*w !matches Y 
            w = w + eta*ytr(j)*Xtr(j,:)'; %shift weights by a fraction of our prediction in the direction of output.
        end
    end

    % Performance on test data
    yhts = Xts*w;
    disp([yts yhts])
    PercentageError(k) = 100*length(find(yts .* yhts <0))/length(yts); % percentage of wrongly identified data
end

x2 = (-w(3) + w(1)*5)/w(2);
x1 = (-w(3)-10*w(2))/w(1);
plot([(-5) x1], [x2 10], 'g', 'LineWidth', 1);
