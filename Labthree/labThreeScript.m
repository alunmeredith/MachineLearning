% QUESTION 1 =============================================
% Define two class pattern classification problem between 
% two gaussian, equal covariance, unequal mean distributions. 

% define the parameters of the distributions
C = [2 1; 1 2];
C1 = C; C2 = C;
m1 = [0;2];
m2 = [1.7;2.5];
N = 200;

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
%  Compute Reciever Operating Characteristic (ROC) curve. 

thmin = min([xx1 xx2]);
thmax = max( [xx1 xx2]);

rocResolution = 50; %number of bins when sampling ROC
thRange = linspace(thmin, thmax, rocResolution);
ROC = zeros(rocResolution, 2);
for jThreshold = 1:rocResolution %loop over each bin
    % Classify all values > threshold == class 1
    threshold = thRange(jThreshold);
    % True positive rate = % of dist1 values higher than threshold
    tPos = length(find(p1 > threshold))*100 / N;
    % False positive rate = % of dist2 values higher than threshold
    fPos = length(find(p2 > threshold))*100 / N;
    ROC(jThreshold,:) = [fPos tPos];
end

% plots values of true positive rate vs false positive rate
figure(3), clf,
plot(ROC(:,1), ROC(:,2), 'b', 'LineWidth', 2);
axis([0 100 0 100]);
grid on, hold on
% plot the null hypothesis (random guessing = 50%)
plot(0:100, 0:100, 'b-');
xlabel('False Positive', 'FontSize', 16)
ylabel('True Positive', 'FontSize', 16);
title('Receiver Operating Characteristic Curve', 'FontSize', 20);