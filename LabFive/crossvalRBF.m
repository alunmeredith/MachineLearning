function [ RMSEtest, RMSEtrain, lambda ] = crossvalRBF( K, f, Y, ii, cvFolds, sigma, Lambda)
% Conducts RBF model predicts on the test set.
% Cross validates this returning on each of "cvFolds"
% Returns test and training set errors on each cv test set.

RMSEtest = zeros(cvFolds,1);
RMSEtrain = zeros(cvFolds,1);
for cv = 1:cvFolds
    
    % Seperates into training and test sets
    Xtest = Y(ii == cv, :);
    ytest = f(ii == cv, :);
    Xtrain = Y(ii~=cv, :);
    ytrain = f(ii~=cv, :);
    
    Ntrain = length(ytrain);
    Ntest = length(ytest);
    
    % Create clusters
    [IDX, C] = kmeans(Xtrain, K);

    % Construct design matrix
    design=zeros(Ntrain,K);
    for i=1:Ntrain
        for j=1:K
            design(i,j)= exp(-norm(Xtrain(i,:) - C(j,:))/sigma^2); 
        end
    end
    
    % Train weights 
    if strcmp(Lambda, 'train')
        lambda = design \ ytrain;
    else
        lambda = Lamba;
    end
    
    % Create predictions on the training set
    u = zeros(K,1);
    yhTrain = zeros(Ntrain,1);
    for n=1:Ntrain
        for j=1:K
            % the pdf of that datapoint for that center (Ntrain x K)
            u(j) = exp(-norm(Xtrain(n,:) - C(j,:))/sigma^2);
        end
        % predicted value of that datapoint by applying weighted sum of centers
        yhTrain(n) = lambda'*u;
    end
    
    % Create predictions on testing set
    yhTest = zeros(Ntest,1);
    u = zeros(K,1);
    for n=1:Ntest
        for j=1:K
            % the pdf of that datapoint for that center (Ntrain x K)
            u(j) = exp(-norm(Xtest(n,:) - C(j,:))/sigma^2);
        end
        % predicted value of that datapoint by applying weighted sum of centers
        yhTest(n) = lambda'*u;
    end
    
    % Calculate errors for that fold
    RMSEtest(cv) = sqrt( sum((ytest - yhTest).^2) / Ntest );
    RMSEtrain(cv) = sqrt( sum((ytrain - yhTrain).^2) / Ntrain );

    % 
    figure(2)
    plot(ytest, yhTest, 'rx', 'LineWidth', 2), grid on
    refline(1,[0, 0])
    title('RBF Prediction on Test Data', 'FontSize', 16);
    xlabel('Target', 'FontSize', 14);
    ylabel('Prediction', 'FontSize', 14);

end
end