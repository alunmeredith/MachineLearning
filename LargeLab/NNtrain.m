function [ net, tr ] = NNtrain( hiddenLayerSize, X1, X2, trainFunction)
%% Merge the sample data together into training data and target
% Creates a neural network "net"
X = [X1; X2]'; %include bias unit
y = [ones(length(X1),1); zeros(length(X2),1)]';
N = length(X);
% randomise ordering of data
ii = randperm(N);
x = X(:,ii);
t = y(ii);

% Choose a Training Function
% For a list of all training functions type: help nntrain
% trainFcn = 'trainlm'; % is usually fastest.
% trainFcn = 'trainbr'; % takes longer but may be better for challenging problems.
% trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.
trainFcn = trainFunction;

[net] = feedforwardnet(hiddenLayerSize, trainFcn);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y);
tind = vec2ind(t);
yind = vec2ind(y);
percentErrors = sum(tind ~= yind)/numel(tind);

% View the Network
% (net)

% Plots
% Uncomment these lines to enable various plots.
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, ploterrhist(e)
% figure, plotconfusion(t,y)
% figure, plotroc(t,y)
end