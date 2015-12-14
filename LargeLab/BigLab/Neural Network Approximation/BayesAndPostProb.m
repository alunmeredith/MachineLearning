
% Bayes Classifier (different Covariance)

m1 = [0 3];
m2 = [4 0];
C1 = [2 1;1 2];
C2 = [1 0; 0 1];
% Parameters of Cuadratic Bayes
A = inv(C1)-inv(C2);
b = 2*(m2*inv(C2)-m1*inv(C1));
c = (m1*inv(C1)*m1'-m2*inv(C2)*m2')+log(det(C1)/det(C2));

figure(1)
N = 100;
X1 = mvnrnd(m1, C1, N);
X2 = mvnrnd(m2, C2, N);
plot(X1(:,1),X1(:,2),'b.', X2(:,1),X2(:,2),'rx');
grid on
hold on
g = @(x,y) [A(1,1)*x^2 + (A(1,2)+A(2,1))*x*y + A(2,2)*y^2] + [b(1)*x + b(2)*y] + c;
h = ezplot(g,figure(1));
h.Color = 'k';
h.LineWidth = 1;
title('Bayes Classifier');
ylabel('y')
xlabel('x')
axis([-6 8 -6 10])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Posterior Probability

numGrid = 50;
xRange = linspace(-4.0, 7.0, numGrid);
yRange = linspace(-4.0, 7.0, numGrid);
PostP1 = zeros(numGrid, numGrid);
%PostP2=PostP1;
for i=1:numGrid
   for j=1:numGrid;
      %Aqui habia que cambiar la funcion de la prob post, hay que tener en
      %cuenta todos los terminos que incluian C1 y C2, por lo que queda un
      %termino cuadratico dentro de la exponencial y los determinantes
      %fuera.
      PostP1(i,j) = 1/(1+((det(C1))/(det(C2))^(1/2))*exp((1/2)*(((xRange(i)^2)*A(1,1))+((A(1,2)+A(2,1))*xRange(i)*(yRange(j))')+((yRange(j)^2)*A(2,2))+(xRange(i))*b(1)+yRange(j)*b(2)+c)));
      %PostP2(i,j) = 1/(1+exp((-1/2)*((xRange(i))*w(1)+yRange(j)*w(2)+w0)));
   end
end

figure
surfc(xRange,yRange, PostP1')
ylabel('y'), xlabel('x'), zlabel('Posterior Probability Class 1 (Blue)')
%Muy importante, traspuesta de PostP1, ya que matlab recibe como matrix
%[m,n] siendo m el eje y y n el x, as contrario de lo computado!! si n se
%cambia esto, sale con orientacion perpendicular, no lo esperado
