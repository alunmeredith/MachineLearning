function [ RMSEtest, RMSEtrain ] = labFiveScript( K )

% QUESTION 1 -----------------------------
% load and nomralise the boston housing data
loadData
% Seperate into training set and testing set
ii = cvIndices(Y, 4);
Xtrain = Y(ii ~= 1,:);
Xtest = Y(ii == 1,:);
ytrain = f(ii ~= 1,:);
ytest = f(ii == 1,:);

% QUESTION 2 -------------------------------
% Set the widths of the basis functions to a sensible scale
% Sensible scale in this case is the distance between in two random 
% datapoints.
Ntrain = length(ytrain);
Ntest = length(ytest);
sig = norm( Xtrain(ceil(rand*Ntrain),:) - Xtrain(ceil(rand*Ntrain),:) );

% QUESTION 3 -------------------------------
% Perform K-means clustering to find centres for the basis functions.
[IDX, C] = kmeans(Xtrain, K);

% Question 4 -------------------------------
% Construct the design matrix A
% Value of pdf of each data point w.r.t. each bias function. Columns of
% design matrix is
for i=1:Ntrain
    for j=1:K
        design(i,j)= exp(-norm(Xtrain(i,:) - C(j,:))/sig^2); 
    end
end

% QUESTION 5 -------------------------------
% solve for the weights.
% This produces a set of weights to assign to each cluster center.
lambda = design \ ytrain;

% QUESTION 6 -------------------------------
% What does the model predict at each of the training data.
yh = zeros(Ntrain,1);
u = zeros(K,1);
for n=1:Ntrain
    for j=1:K
        % the pdf of that datapoint for that center (Ntrain x K)
        u(j) = exp(-norm(Xtrain(n,:) - C(j,:))/sig^2);
    end
    % predicted value of that datapoint by applying weighted sum of centers
    yhTrain(n) = lambda'*u;
end
plot(ytrain, yhTrain, 'rx', 'LineWidth', 2), grid on
title('RBF Prediction on Training Data', 'FontSize', 16);
xlabel('Target', 'FontSize', 14);
ylabel('Prediction', 'FontSize', 14);

% QUESTION 7 ---------------------------------
% Adapt the above to calculate what the model predicts at the unseen (test
% data) and draw a similar scatter plot. How do the training and test
% errors compare? Compute the difference between the  training and test
% errors at different values of the number of basis functions, K. Briefly
% comment on any observation you make.

% Using the same weights learnt earlier from training data make predictions
% on test data.
yh = zeros(Ntest,1);
u = zeros(K,1);
for n=1:Ntest
    for j=1:K
        % the pdf of that datapoint for that center (Ntrain x K)
        u(j) = exp(-norm(Xtest(n,:) - C(j,:))/sig^2);
    end
    % predicted value of that datapoint by applying weighted sum of centers
    yhTest(n) = lambda'*u;
end
figure(2)
plot(ytest, yhTest, 'rx', 'LineWidth', 2), grid on
title('RBF Prediction on Testing Data', 'FontSize', 16);
xlabel('Target', 'FontSize', 14);
ylabel('Prediction', 'FontSize', 14);

% Calculate errors, how do the training and test errors compare.
RMSEtest = sqrt( sum((ytest - yhTest').^2) / Ntest );
RMSEtrain = sqrt( sum((ytrain - yhTrain').^2) / Ntrain );

end
