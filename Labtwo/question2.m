% Generate two bi-variate Gaussian distributions
N = 100;
X1 = randn(N,2);
X2 = randn(N,2);

% Transform covariance matrices of both to C. 
C = [2 1; 1 2];
A = chol(C);
X1 = X1*A;
X2 = X2*A;

% shift means of distributions by m1/m2
m1 = [0 2];
m2 = [1.5 0];
X1 = X1 + kron(ones(N,1), m1);
X2 = X2 + kron(ones(N,1), m2);

% plot the two distributions
plot(X1(:,1),X1(:,2), 'b+', X2(:,1),X2(:,2),'rX');
