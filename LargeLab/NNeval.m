function NN = NNeval(net, numGrid)    
    % Evaluate neural net for each poitn on the grid
    NN = zeros(numGrid);
    xRange = linspace(-4.0, 7.0, numGrid); %linspeace = seq() in R
    yRange = linspace(-4.0, 7.0, numGrid);
    for i = 1:numGrid
        for j = 1:numGrid
            %loops through x,y coordinates (square numGrid x numGrid matrix)
            x = [yRange(j) xRange(i)]';
            % mvnpdf = multivariate normal probability density function
            % takes arguments, X,mu,sigma.
            % Records probability density value at each point
            NN(i,j) = net(x);
        end
    end
end