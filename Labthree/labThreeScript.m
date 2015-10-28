function [ bestAccFish, bestAccRand, bestAccMean, pCorrectNN, pCorrectEuclid, pCorrectMahal, pCorrectBayes, AUCfish, AUCrand, AUCmean ] = labThreeScript( C1, C2, m1, m2, N )

% QUESTION 1 =============================================
% Define two class pattern classification problem between 
% two gaussian, equal covariance, unequal mean distributions. 

% plot the contours
numGrid = 50;
xRange = linspace(-6.0, 6.0, numGrid); %linspeace = seq() in R
yRange = linspace(-6.0, 6.0, numGrid);

% initialising P1 and P2
P1 = zeros(numGrid, numGrid);
P2 = P1;

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
Pmax = max(max([P1 P2]));

%figure() creates window
% clf clears the current figure
figure(1), clf,
% draws contour lines from the probability density matrices for each
% probability value given. 
contour(xRange, yRange, P1, [0.1*Pmax 0.5*Pmax 0.8*Pmax], 'LineWidth', 2);
hold on
plot(m1(1), m1(2), 'b*', 'LineWidth', 4);
contour(xRange, yRange, P2, [0.1*Pmax 0.5*Pmax 0.8*Pmax], 'LineWidth', 2);
plot(m2(1), m2(2), 'r*', 'LineWidth', 4);

% QUESTION 2. ===============================================
% Generate the distributions. 
X1 = genGaussian(N,m1,C1);
X2 = genGaussian(N,m2,C2);

plot(X1(:,1),X1(:,2), 'bx', X2(:,1),X2(:,2), 'ro'); grid on

% QUESTION 3. ==============================================
% Compute Fisher Linear Discriminant direction

% computes difference in mean / difference in variance 
% = gradient of the projection line
wF = inv(C1+C2) * (m1-m2);
% plots fisher line through 0,0 (can be any inercept?)
xx = -6:0.1:6;
yy = xx * wF(2)/wF(1);
plot(xx,yy, 'r', 'LineWidth', 2);

% QUESTION 4. ==============================================
% Project the data onto the Fisher Discriminant directions and plot
% histograms of the distribution of projections. 

% project data onto line: 
% Linear projection = special case matrix transform Y = X*A, where A is a vector. (n-1 dimensional plane)
p1 = X1* wF;
p2 = X2 * wF;

% calculates range of projected data along the line. 
plo = min([p1; p2]);
phi = max([p1; p2]);
% returns position (nn) and value (xx) of hist
[nn1, xx1] = hist(p1);
[nn2, xx2] = hist(p2);
hhi = max([nn1 nn2]);
% plots histograms next to one another
figure(2), 
subplot(211), bar(xx1, nn1);
axis([plo phi 0 hhi]);
title('Distribution of Projections', 'FontSize', 16)
ylabel('Class 1', 'FontSize', 14)
subplot(212), bar(xx2, nn2);
axis([plo phi 0 hhi])
ylabel('Class 2', 'FontSize', 14)

% Question 5 ===================================================

% Calculate a range of thresholds
[nn1, xx1] = hist(p1);
[nn2, xx2] = hist(p2);
thmin = min([xx1 xx2]);
thmax = max( [xx1 xx2]);
rocResolution = 50; %number of bins when sampling ROC
thRange = linspace(thmin, thmax, rocResolution);

%  Compute Reciever Operating Characteristic (ROC) curve for fisher
%  discriminant. 

ROCfish = ROCcalc2(wF, p1, p2);

% Creates ROC curve
figure(3), clf,
axis([0 100 0 100]);
grid on, hold on
xlabel('False Positive', 'FontSize', 16)
ylabel('True Positive', 'FontSize', 16);
title('Receiver Operating Characteristic Curve', 'FontSize', 20);
% Adds null hypothesis
plot(0:100, 0:100, 'b-');
% Plots fisher discriminant
plot(ROCfish(:,1), ROCfish(:,2), 'b', 'LineWidth', 2);

% QUESTION 6 ==================
% Compute the area under the ROC curve

AUCfish = trapz(ROCfish(:,1), ROCfish(:,2))/1000;
 
% QUESTION 7 ==================
% compute classificaiton accuracy for a suitable choice of decision
% threshold
 
bestAccFish = bestAccuracy(p1,p2,thRange);
disp(['Fisher projection Best Accuracy: ' num2str(bestAccFish*100)]);

% QUESTION 8 ============================================================
% Plot Roc for random direction

% Calcualte a linear equation through the origin with random gradient
wR = [1; tan(rand(1)*(2*pi))];
% Generate x and y coordinates for random gradient
xx = -6:0.1:6;
yy = xx * wR(2);
% Project data onto line
p1 = X1*wR;
p2 = X2*wR;

% Generate ROC from random direction
ROCrand = ROCcalc2(wR, p1, p2);
% Add ROC to plot
figure(3);
plot(ROCrand(:,1), ROCrand(:,2), 'r', 'LineWidth', 2);
% Calculate accuracy 
bestAccRand = bestAccuracy(p1, p2, thRange);
disp(['Random projection best Accuracy: ' num2str(bestAccRand*100)]);
% AUC
AUCrand = trapz(ROCrand(:,1), ROCrand(:,2))/1000;

% Generate line between two means
wM = [m1(1) - m2(1); m1(2) - m2(2)];
yy = xx * wM(2)/wM(1);
%Project data onto that line
p1 = X1 * wM;
p2 = X2 * wM;
% Generate ROC from that
ROCmean = ROCcalc2(wM, p1, p2);
figure(3);
plot(ROCmean(:,1), ROCmean(:,2), 'g', 'LineWidth', 2);

% Calculate accuracy 
bestAccMean = bestAccuracy(p1, p2, thRange);
disp(['Mean projection best Accuracy: ' num2str(bestAccMean*100)]);
% AUC
AUCmean = trapz(ROCmean(:,1), ROCmean(:,2))/(1000);

% Question 9 ==============================================
% Implement a nearest neighbour classifier

% Initialise all the things
X = [X1; X2];
N1 = size(X1, 1);
N2 = size(X2, 1);
y = [ones(N1,1); -1*ones(N2,1)];
d = zeros(N1+N2-1,1);
nCorrect = 0;

for jtst = 1:(N1+N2)
    % Pick a point to test
    % classifier assumes no correlation between points (doesn't randomise
    % point picked)
    xtst = X(jtst, :);
    ytst = y(jtst);
    
    % All others form the training set
    jtr = setdiff(1:N1+N2, jtst);
    Xtr = X(jtr,:);
    ytr = y(jtr,1);
    
    %Compute all distance from test to training points
    for i = 1:(N1+N2-1)
        d(i) = norm(Xtr(i,:)-xtst);
    end
    
    % Which one is the closest?
    [imin] = find(d == min(d));
    
    % Does the nearest point have the same class label?
    if (ytr(imin(1)) * ytst > 0)
        nCorrect = nCorrect + 1;
    else
        %disp('Incorrect classification');
    end
end
%Percentage correct
pCorrectNN = nCorrect*100/(N1+N2);
disp(['Nearest neigbour accuracy: ' num2str(pCorrectNN)]);


% Question 10 ================================================
% Distance to mean classifier. 

% Euclidean
nCorrect = 0;
 for i = 1:(N1+N2)
     % compute euclidean distance
     % first distance
     d1 = sqrt( (X(i,1) - m1(1))^2 + (X(i,2) - m1(2))^2 );     
     d2 = sqrt( (X(i,1) - m2(1))^2 + (X(i,2) - m2(2))^2 );
     if ((d2 - d1) * y(i) > 0) 
         nCorrect = nCorrect + 1;
     end
 end
 
pCorrectEuclid = nCorrect*100/(N1+N2);
disp(['Euclidean Accuracy: ' num2str(pCorrectEuclid)]);


% Euclidean
nCorrect = 0;
 for i = 1:(N1+N2)
     % compute euclidean distance
     % first distance
     %d1 = (X(i,:) - m1') * inv(C) * (X(i,:) - m1')';   
     d1 = sqrt( (X(i,1) - m1(1))^2 + (X(i,2) - m1(2))^2 );     
     d2 = sqrt( (X(i,1) - m2(1))^2 + (X(i,2) - m2(2))^2 );
     if ((d2 - d1) * y(i) > 0) 
         nCorrect = nCorrect + 1;
     end
 end
pCorrectEuclid = nCorrect*100/(N1+N2);

%Mahalanobis Distance
nCorrect = 0;
 for i = 1:(N1+N2)
     % compute Mahalanobis distance (igoring sqrt
     d1 = sqrt((X(i,:) - m1') * inv(C1) * (X(i,:) - m1')');   
     d2 = sqrt((X(i,:) - m2') * inv(C2) * (X(i,:) - m2')');   
     if ((d2 - d1) * y(i) > 0) 
         nCorrect = nCorrect + 1;
     end
 end
pCorrectMahal = nCorrect*100/(N1+N2);
disp(['Mahalanobis Accuracy: ' num2str(pCorrectMahal)]);

% Question 11 ====================
% Multivariate guassian
figure(4);
surf(xRange, yRange, (P1./(P1+P2)));

acc = zeros(50,1);
for jThreshold = 1:50
    threshold = 1/jThreshold;
    tPos = 0;
    fPos = 0;
    for i = 1:(2*N)
        p1(i) = (mvnpdf(X(i,:)', m1, C1) / (mvnpdf(X(i,:)', m1, C1) + mvnpdf(X(i,:)', m2, C2))) > threshold;
    end
    acc(jThreshold) = sum(( ((p1 > 0.5)-0.5) .* y) > 0);
end
pCorrectBayes = max(acc)/(2*N);
disp(['Bayes Accuracy: ' num2str(pCorrectBayes*100)]);


end
