% Neural Network for Bayes Classifier
% Training/Test variables
X = [X1; X2];
y = [ones(length(X1(:,1)),1); -ones(length(X2(:,1)),1)];

% Training Fucntions (or layers???)
[net] = feedforwardnet(20);
% Training the net with input X and output y (Class: 1=Class1; -1=Class2)
[net] = train(net, X', y');

% Calculate the output of the neural network for different positions (or
% points) in the grid. The output of net(@input) is a number -> we need the
% loop like calculating Posterior Probability directly. 
numGrid = 50;
xRange = linspace(-4.0, 7.0, numGrid);
yRange = linspace(-4.0, 7.0, numGrid);
PostProbNN = zeros(numGrid, numGrid);
for i=1:numGrid
   for j=1:numGrid;
      PostProbNN(i,j) = net([xRange(i); yRange(j)]);
   end
end
%figure
%N = 100;
%X1 = mvnrnd(m1, C1, N);
%X2 = mvnrnd(m2, C2, N);
%plot(X1(:,1),X1(:,2),'b.', X2(:,1),X2(:,2),'rx');
%grid on
figure
contour(xRange, yRange, PostProbNN', [0.5 0.5], 'LineWidth', 2);
grid on
title('Neural Network "Bayes Classifier"', 'FontSize', 14)
figure
surfc(xRange,yRange, PostProbNN')
ylabel('y')
xlabel('x')
title('Neural Network Classification', 'FontSize', 14)

% --Probar con mas puntos: seguramente ajuste mejor al tener mas puntos para
% entrenar la red.
% --Probar tambien con mas funciones/layers, sobreajustará y hara cosas
% raras

% Comentar todas estas movidas