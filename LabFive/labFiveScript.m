function [ RMSEtest, RMSEtrain, lambda ] = labFiveScript( K, f, Y, ii, cv, sig, lambda)
% Conducts radial basis function regression on data after splitting it into
% testing and training sets from the vecotr ii. 

% QUESTION 1 -----------------------------
% LOADING THE DATA COMMENTED OUT AND PUT IN THE LABFIVERERUNS SCRIPT
% Takes as arguement the number of centers K, the target vector f, the data
% matrix Y, the cross validation / train-test splitting vector ii, and the
% sigma value for the RBF and the number of CV folds used (0)

% load and nomralise the boston housing data
% loadData Loading now done in the reruns script

% % Seperate into training set and testing set, seperates it further if we
% are cross validating
% Xtrain = Y(ii ~= 1,:);
% Xtest = Y(ii == 1,:);
% ytrain = f(ii ~= 1,:);
% ytest = f(ii == 1,:);
% Ntrain = length(ytrain);
% Ntest = length(ytest);

% Seperates into training testing and CV sets
Xtest = Y(ii == 1,:);
ytest = f(ii == 1,:);
Xval = Y(ii == cv, :);
yval = f(ii == cv, :);
Xtrain = Y((ii~=1)&(ii~=cv), :);
ytrain =  f( (ii~=1)&(ii~=cv), :);
Ntrain = length(ytrain);
Ntest = length(ytest);
% QUESTION 2 -------------------------------
% Sensible scale in this case is the distance between in two random 
% datapoints.
% sig = norm( Xtrain(ceil(rand*Ntrain),:) - Xtrain(ceil(rand*Ntrain),:) );


% QUESTION 3 -------------------------------
[IDX, C] = kmeans(Xtrain, K);

% Question 4 -------------------------------
% Value of pdf of each data point w.r.t. each bias function. Columns of
% design matrix is
design=zeros(Ntrain,K);
for i=1:Ntrain
    for j=1:K
        design(i,j)= exp(-norm(Xtrain(i,:) - C(j,:))/sig^2); 
    end
end

% QUESTION 5 -------------------------------
% This produces a set of weights to assign to each cluster center.
if strcmp(lambda, 'train')
    lambda = design \ ytrain;
end
% QUESTION 6 -------------------------------
% What does the model predict at each of the training data.
u = zeros(K,1);
yhTrain = zeros(Ntrain,1);
for n=1:Ntrain
    for j=1:K
        % the pdf of that datapoint for that center (Ntrain x K)
        u(j) = exp(-norm(Xtrain(n,:) - C(j,:))/sig^2);
    end
    % predicted value of that datapoint by applying weighted sum of centers
    yhTrain(n) = lambda'*u;
end
%plot(ytrain, yhTrain, 'rx', 'LineWidth', 2), grid on
%title('RBF Prediction on Training Data', 'FontSize', 16);
%xlabel('Target', 'FontSize', 14);
%ylabel('Prediction', 'FontSize', 14);

% QUESTION 7 ---------------------------------
% Using the same weights learnt earlier from training data make predictions
% on test data.
yhTest = zeros(Ntest,1);
u = zeros(K,1);
for n=1:Ntest
    for j=1:K
        % the pdf of that datapoint for that center (Ntrain x K)
        u(j) = exp(-norm(Xtest(n,:) - C(j,:))/sig^2);
    end
    % predicted value of that datapoint by applying weighted sum of centers
    yhTest(n) = lambda'*u;
end
%figure(2)
%plot(ytest, yhTest, 'rx', 'LineWidth', 2), grid on
%title('RBF Prediction on Testing Data', 'FontSize', 16);
%xlabel('Target', 'FontSize', 14);
%ylabel('Prediction', 'FontSize', 14);

% Calculate errors, how do the training and test errors compare.
RMSEtest = sqrt( sum((ytest - yhTest).^2) / Ntest );
RMSEtrain = sqrt( sum((ytrain - yhTrain).^2) / Ntrain );

end
