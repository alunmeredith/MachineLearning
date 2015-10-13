% compute bayes' optimal class boundary. 
% Distinc Means; Common covariance matrix (but not isotropic)
% w = 2C^-1 (m2 - m1)
w = 2 * inv(C) * (m2 - m1)';
% b = (m1'm1 - m2'm2) - log(P[w1]/P[w2])
% Prior term is 0 because we have just as many observations of each
% distribution. I.e. prior knowledge doesn't give us equal likelihood of
% each distribution.
b = (m1*m1' - m2*m2') - log(0.5/0.5);

% when x1 = -5: w(1)*-5 + w(2)*x2 + b = 0
x2 = (-b + w(1)*5)/w(2);
% when x2 = 10
x1 = (-b-10*w(2))/w(1);

hold on
plot([(-5) x1], [x2 10], 'b', 'LineWidth', 1);
