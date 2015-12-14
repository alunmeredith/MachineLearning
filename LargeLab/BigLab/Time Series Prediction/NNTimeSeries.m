%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%    Time Series: NN    %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% Training Set %%%%%%%%%%%%%%%%%%%%%%%%%%%

N = sample_n;
Ttr = T((1:ceil(3*N/4)),:);
Xtr = X((1:ceil(3*N/4)),:);
Tts = T(((ceil(3*N/4)+1):N),:);
Xts = X(((ceil(3*N/4)+1):N),:);

Xtr;
Ntr = length(Xtr);
p = 20;
TrInput = ones(Ntr-(p+1),p);
%TrOutput = ones(Ntr-(p+1),1);
TrOutput(:,1) = Xtr((p+1):(Ntr-1));%,1);
w = zeros(p,Ntr-(p+1));
for i = 1:p
    TrInput(:,i) = Xtr((i):(Ntr-(p+2)+i));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%    Test Set    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[net] = feedforwardnet(20);
[net] = train(net, TrInput', TrOutput');

Nts = length(Xts);
TsInput = ones(Nts-(p+1),p);
%TsOutput = ones(Nts-(p+1),1);
TsOutput(:,1) = Xts((p+1):(Nts-1));
for i = 1:p
    TsInput(:,i) = Xts((i):(Nts-(p+2)+i));
end

%%


%%%%%%%%%%%%%%%%%%%%     Feedforward NN     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Prediction = zeros(length(TsInput),1);
for i=1:length(TsInput)
  Prediction(i) = net(TsInput(i,:)');
end

figure
plot(Ttr((p+1):(Ntr-1)),TrOutput, 'b.', 'LineWidth', 2)
hold on
plot(Tts((p+1):(Nts-1)), Prediction, 'r.', 'LineWidth', 2)
title('Time Series: NN One step prediction')
ErrorTs = sum((Prediction-TsOutput).^2)/(length(TsOutput))


%%

%%%%%%%%%%%%%%%%%%%%%%% Feeding back NN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  Prueba con una matriz de numeros naturales para predecir el siguiente
%Nts= 12;
%p=4;
%TsInput = [1 2 3 4 ; 2 3 4 5 ; 3 4 5 6 ; 4 5 6 7 ; 5 6 7 8 ; 6 7 8 9 ; 7 8 9 10];
%TsOutput=[5 6 7 8 9 10 11];
%[net] = feedforwardnet(10);
%[net] = train(net, TsInput', TsOutput);


PredictionFeedback = zeros(length(TsInput),1);
for j = 1:length(TsInput)
    % Calculate regression model in each row
    % Use this model to make prediction of that Output
    PredictionFeedback(j)  = net(TsInput(j,:)');
    % Include this prediction as point in the Input ####(por ahora siguiente fila solo)####: update Input with
    % predictions --> Unsupervised Learning!! --> w, ya que va actualizando
    for n = 1:p
        if j+n <= Nts-(p+1)
           TsInput(j+n,p+1-n) = PredictionFeedback(j);
           % Actualizacion fila por fila:
           %Input(j+1,p) = Prediction;
           %Input(j+2,p-1) = Prediction;
           %Input(j+3,p-2) = .....
        end
    end
end



figure
plot(Ttr((p+1):(Ntr-1)),TrOutput, 'b.', 'LineWidth', 2)
hold on
plot(Tts((p+1):(Nts-1)), PredictionFeedback, 'g.', 'LineWidth', 2)
title('Time Series: Feedback NN prediction')
ErrorTsFeedback = sum((PredictionFeedback-TsOutput).^2)/(length(TsOutput))





