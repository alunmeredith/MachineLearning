
%% Building a neural network
net = feedforwardnet(20);
% **Consider the number of layers and nodes we want the network to have, a 2
% layer network has 1 hidden layer (and 3 layers including imput layer).
% This is the most simple so we will start with that. But we may want to
% try different variations to see which is most accurate. 
% ** Consider if there is a bias layer or not, and if this is helpful

% Set number of input layers to 1
net.numInputs = 1;

% Set the number in neurons in the input layer = dimensionality of
% the data (1 neuron for each variable) in this case 2. 
net.inputs{1}.size = 2;

% Set the total number of layers (besides input layer)
net.numLayers = 2; %number of hidden layers
net.layers{1}.size = 3;
net.layers{2}.size = 1; % 1 output value

% Connect first layer to input, second layer to output
net.inputConnect(1) = 1; 
net.outputConnect(2) = 1;
net.layerConnect(2,1) = 1; % Connects output of 1 to input of 2

% Set the transfer function of each layer
net.layers{1}.transferFcn = 'logsig';
net.layers{2}.transferFcn = 'purelin'; % Output is linear

% Add bias nodes to hidden layer
net.biasConnect = [1;0];

% Set the initialisation procedure
% Each layer uses its own initialisation routine
% In this case that is Nyguyen Widrow intialisation
net.initFcn = 'initlay';
net.layers{1}.initFcn = 'initnw';
net.layers{2}.initFcn = 'initnw';