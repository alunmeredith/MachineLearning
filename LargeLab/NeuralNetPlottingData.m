%% Defining characteristics of data
m1 = [0,3]';
m2 = [4,0]';
C1 = [2,1;1,2];
C2 = [1,0;0,1];
N = 250;
N1 = N;
N2 = N1;

%% Plot Sample data
% Generate sample distributions
X1 = genGaussian(N1,m1,C1);
X2 = genGaussian(N2,m2,C2);
% Plot generated sample
figure(1), clf
plot(X1(:,1),X1(:,2), 'bx', X2(:,1),X2(:,2), 'rx'); grid on

%% Plot data and contours
% plot the contours
numGrid = 50;
xRange = linspace(-4.0, 7.0, numGrid); %linspeace = seq() in R
yRange = linspace(-4.0, 7.0, numGrid);

% initialising P1 and P2
P1 = zeros(numGrid, numGrid);
P2 = P1;

% Evaluate pdf for each poitn on the grid
for i = 1:numGrid
    for j = 1:numGrid
        %loops through x,y coordinates (square numGrid x numGrid matrix)
        x = [yRange(j) xRange(i)]';
        % mvnpdf = multivariate normal probability density function
        % takes arguments, X,mu,sigma.
        % Records probability density value at each point
        P1(i,j) = mvnpdf(x', m1', C1);
        P2(i,j) = mvnpdf(x', m2', C2);
    end
end

% records maximum probability value
P1max = max(max(P1));
P2max = max(max(P2));

figure(1),hold on
% draws contour lines from the probability density matrices for each
% probability value given. 
contour(xRange, yRange, P1, [0.1*P1max 0.5*P1max 0.8*P1max], 'LineWidth', 2);
plot(m1(1), m1(2), 'b*', 'LineWidth', 4);
contour(xRange, yRange, P2, [0.1*P2max 0.5*P2max 0.8*P2max], 'LineWidth', 2);
plot(m2(1), m2(2), 'r*', 'LineWidth', 4);

%% Drawing posterior probability of distributions

figure(2)
subplot(2,2,1),
contourf(xRange, yRange, (P1./(P1+P2)));
title('Posterior probability of distribution 1');

%% Train a neural network
figure(2),
net = NNtrain(3, X1, X2, 'trainbr');
NNsmall = NNeval(net, 50);
subplot(2,2,2), 
contourf(xRange, yRange, NNsmall);
title('Few Node Neural Network');

net = NNtrain(10, X1, X2, 'trainbr');
NNmedium = NNeval(net, 50);
figure(2),
subplot(2,2,3), 
contourf(xRange, yRange, NNmedium);
title('Medium Node Neural Network');

net = NNtrain(50, X1, X2, 'trainbr');
NNlarge = NNeval(net, 50);
subplot(2,2,4), 
contourf(xRange, yRange, NNlarge);
title('Many Node Neural Network');
%% Neural Net contour plot
figure(1),
contour(xRange, yRange, (P1./(P1+P2)), [0.5 0.5], 'b', 'LineWidth', 2);
contour(xRange, yRange, NNsmall, [0.5 0.5], 'r', 'LineWidth', 2);
contour(xRange, yRange, NNmedium, [0.5 0.5], 'm', 'LineWidth', 2);
contour(xRange, yRange, NNlarge, [0.5 0.5], 'g', 'LineWidth', 2);
title('Neural Network classifier');
xlabel('X coordinate');
ylabel('Y coordinate');
zlim([-0.5,2]);

%% Neural Net training function variation
figure(4),
net = NNtrain(50, X1, X2, 'trainlm');
NNlarge = NNeval(net, 50);
subplot(1,3,1), 
contourf(xRange, yRange, NNlarge);
title('Levenverg-Marquardt');

figure(4),
net = NNtrain(50, X1, X2, 'trainbr');
NNlarge = NNeval(net, 50);
subplot(1,3,2), 
contourf(xRange, yRange, NNlarge);
title('Baysean Regularisation');

figure(4),
net = NNtrain(50, X1, X2, 'trainbfg');
NNlarge = NNeval(net, 50);
subplot(1,3,3), 
contourf(xRange, yRange, NNlarge);
title('BFGS Quasi-Newton');
%% Test variance in training and test set accuracy for increasing number of nodes in neural net
len = 100;
terr = zeros(len,1);
err = zeros(len,1);
for i = 1:len
   [net, tr] =NNtrain(i, X1, X2, 'trainlm');
   terr(i) = tr.perf(end);
   err(i) = tr.tperf(end);
end
figure(12), hold on
plot(1:len, terr);
plot(1:len, err);
