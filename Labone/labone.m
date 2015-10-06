%--- QUESTION 1 ---------- 

% First we compare the shapes of different population distributions. Here 1000
% samples were taken from uniform and gaussian distributions
% and bucketed into a histogram. 
distHist(1000, 'uniform');
distHist(1000, 'gaussian');

% The difference of 12 samples of the uniform distribution
% Sampled 1000 times and plotted as a histogram. 
clt(1000);

% The histogram above shows an approximately gaussian curve, this process
% is explained by the central limit theorem:

% The distribution of a statistic taken from a sample of population 
% distribution itself has an approximately Gaussian distribution. 

% This approximation limits to the Gaussian distribution for large number
% of samples n, although different population distributions can limit at
% different rates. The mean of this sample distribution is approximates the 
% mean of the population distribution. And the variance of the sample
% distribution limits to sigma^2 / N.

% INSERT EQUATION FROM LECTURE NOTES

% We can see this by re-evaluating the above loop for different sample 
% sizes. Note for larger n it closer resembles a gaussian and gets narrower.
clt(10);
clt(100);
clt(1000000);


% QUESTION 2 -----------------------------------

% We can manufacture multi-dimensional normally distributed datasets with
% desired shapes as long as we know the desired covariance matrix. 

% e.g. using the following covariance matrix: 
C = [2,1;1,2];
% as a geometric transform this matrix represents a stretch along the 45
% degree vector. So we expect to produce a dataset that is loosely
% correlated along the 45 degree angle. 

% To produced the desired distribution we first factorise the covariance
% matrix. INSERT A'A = C equation, checking this is true with the isequal function.  
A = chol(C);    
equal = isequal(C, round(A'*A))    %returns true (1) if C and A'A are equal

% Create a standard 2 - dimensional normal distribution and multiply it by
% the factorised covariance matrix to apply a geometric transform to it. 
X = randn(1000,2);
Y = X*A;
plot(X(:,1),X(:,2), 'c.', Y(:,1),Y(:,2),'mx');

% As we can see the resultant distribution has more spread than the original 
% and a loose y = x correlation. Using the cov() function to examine the
% covariances of both shows we have achieved producing the desired distribution.
cov(X)
cov(Y)


% QUESTION 2 B -----------------------------

% In order to dimensionally reduce this datawe want to project it along the 
% vector which retains the most data. This vector is the line which the
% data is most closely distributed across. As shown in figure BLAH this is
% intuitively the line which has the highest variance (keeps the most data)

% The vector u = [sin(theta); cos(theta)] is a circle for values 0 - 2pi
% (an arc for range less than this)
% By multiplying our data by this vector (. product) we project the data
% along this vector. As the projection vector rotates ina circle we can see
% how well fitted the different lines are to our data. When the datapoints
% are close to u the variance is high, when they are far from u the
% variance is low.

N = 50;
plotArray = zeros(N,1);
thRange = linspace(0,2*pi,N);   %generates N theta values [0, 2pi]
for n = 1:N
    theta = thRange(n);
    u = [sin(theta); cos(theta)];
    plotArray(n) = var(Y*u);
end
plot((thRange*180)/pi, plotArray);

% We can see from the plot that the projection which has maximum variance
% (closest the the natural projection of the data) is slightly below 50
% degrees. By maximising the variance of the projection we can maximise the
% information retained from a dimensionality reduction. 

[V,D] = eig(C);
V

% The first eigenvector (-sqrt(2)/2, sqrt(2)/2) shows a line at 45 degrees
% to the horizontal. 
% The second eigenvector, perpendicular to this shows an angle of - 45
% degrees = 135 degrees (because direction of vector doesn't matter) 

% We can see that the eigenvectors of a covariance matrix describe this
% vector of maximum variance (principle component). If the covariance
% matrix is symmetric this is a general result INSERT REFERENCE.

% Using C = [2, -1; -1, 2] represents a 90 degree rotation (reflection 
% around x = 0) in addition to the stretching applied by the previous 
% covariance matrix. We expect the eigenvectors to be the same but the
% oposite order from before. This is what we see. 
