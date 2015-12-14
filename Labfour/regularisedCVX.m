function [ iNzero ] = regularisedCVX( gamma)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

cvx_begin quiet
variable w1( p+1 );
minimize norm( Y*w1 - f )
cvx_end
fh1 = Y*w1;
%Check if the two methods produce the same results.
%figure(2), clf,
%plot(w, w1, 'mx', 'LineWidth', 2);

% Regularisation
cvx_begin quiet
variable w2( p+1 );
minimize( norm(Y*w2-f) + gamma*norm(w2,1) );
cvx_end
fh2 = Y*w2;
plot(f, fh1, 'co', 'LineWidth', 2),
legend('Regression', 'Sparse Regression');
%You can find the non-zero coefficients that are not switched off by the regularizer:
[iNzero] = find(abs(w2) > 1e-5);
disp('Relevant variables');
disp(iNzero);


end

