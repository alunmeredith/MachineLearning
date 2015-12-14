function [ X ] = genGaussian( N, m, C )

% Generate two bi-variate Gaussian distributions
X = randn(N,2);
% Transform covariance matrices of both to C. 
A = chol(C);
X = X*A;
% shift means of distributions by m1/m2
X = X + kron(ones(N,1), m');
end 