a = zeros(1,4);
r = zeros(1,7);
A = zeros(8,4);
R = zeros(8,7);
% define the parameters of the distributions
C = [2 1; 1 2];
C1 = C; 
C2 = C;
m1 = [0; 2];
m2 = [1.7; 2.5];
N = 200;

results = zeros(7, 50);
for i = 1:1
[r(i,1), r(i,2), r(i,3), r(i,4), r(i,5), r(i,6), r(i,7), a(i,1), a(i,2), a(i,3), a(i,4)] = labThreeScript(C1, C2, m1, m2, N);
end
R(1,:) = mean(r,1);
A(1,:) = mean(abs(a),1);

% non overlapping
m1 = [0; -3];
m2 = [2; 5];
for i = 1:10
[r(i,1), r(i,2), r(i,3), r(i,4), r(i,5), r(i,6), r(i,7), a(i,1), a(i,2), a(i,3), a(i,4)] = labThreeScript(C1, C2, m1, m2, N);
end
R(2,:) = mean(r,1);
A(2,:) = mean(abs(a),1);

% very close together
m1 = [-1.5;2];
m2 = [-1;2.5];
for i = 1:10
[r(i,1), r(i,2), r(i,3), r(i,4), r(i,5), r(i,6), r(i,7), a(i,1), a(i,2), a(i,3), a(i,4)] = labThreeScript(C1, C2, m1, m2, N);
end
R(3,:) = mean(r,1);
A(3,:) = mean(abs(a),1);

% isotropic (original means)
m1 = [0; 2];
m2 = [1.7; 2.5];
C = [2 0; 0 2];
C1 = C; 
C2 = C;
for i = 1:10
[r(i,1), r(i,2), r(i,3), r(i,4), r(i,5), r(i,6), r(i,7), a(i,1), a(i,2), a(i,3), a(i,4)] = labThreeScript(C1, C2, m1, m2, N);
end
R(4,:) = mean(r,1);
A(4,:) = mean(abs(a),1);

% Isotropic different covariances
C1 = 1.5 * eye(2);
C2 = 3 * eye(2);
for i = 1:10
[r(i,1), r(i,2), r(i,3), r(i,4), r(i,5), r(i,6), r(i,7), a(i,1), a(i,2), a(i,3), a(i,4)] = labThreeScript(C1, C2, m1, m2, N);
end
R(5,:) = mean(r,1);
A(5,:) = mean(abs(a),1);

% different non-isotropic covariances
C1 = 1.5 * eye(2);
C2 = [2 1; 1 2];
for i = 1:10
[r(i,1), r(i,2), r(i,3), r(i,4), r(i,5), r(i,6), r(i,7), a(i,1), a(i,2), a(i,3), a(i,4)] = labThreeScript(C1, C2, m1, m2, N);
end
R(6,:) = mean(r,1);
A(6,:) = mean(abs(a),1);

% larger number of datapoints
C = [2 1; 1 2];
C1 = C; 
C2 = C;
m1 = [0; 2];
m2 = [1.7; 2.5];
N = 1000;
for i = 1:10
[r(i,1), r(i,2), r(i,3), r(i,4), r(i,5), r(i,6), r(i,7), a(i,1), a(i,2), a(i,3), a(i,4)] = labThreeScript(C1, C2, m1, m2, N);
end
R(7,:) = mean(r,1);
A(7,:) = mean(abs(a),1);

% small number of datapoints
% larger number of datapoints
C = [2 1; 1 2];
C1 = C; 
C2 = C;
m1 = [0; 2];
m2 = [1.7; 2.5];
N = 40;
for i = 1:10
[r(i,1), r(i,2), r(i,3), r(i,4), r(i,5), r(i,6), r(i,7), a(i,1), a(i,2), a(i,3), a(i,4)] = labThreeScript(C1, C2, m1, m2, N);
end
R(8,:) = mean(r,1);
A(8,:) = mean(abs(a),1);
