%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Time Series Regression %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%% One Step Prediction %%%%%%%%%%%%%%%%%%%


%             Training Sample

N = sample_n;
Ttr = T((1:ceil(3*N/4)),:);
Xtr = X((1:ceil(3*N/4)),:);
Tts = T(((ceil(3*N/4)+1):N),:);
Xts = X(((ceil(3*N/4)+1):N),:);

Xtr;%=(1:20);
Ntr = length(Xtr);
% Number of points used to predict the next one
p = 20;

TrInput = ones(Ntr-(p+1),p);
%TrOutput = ones(Ntr-(p+1),1);
TrOutput(:,1) = Xtr((p+1):(Ntr-1));%,1);
% filling one column each time
for i = 1:p
    TrInput(:,i) = Xtr((i):(Ntr-(p+2)+i));
end
% filling rows
%for i = 1:(Ntr-(p+1))
%    TrInput(i,:) = Xtr((i):(p-1+i))';
%end


w = TrInput\TrOutput;
PredOutput = TrInput*w;

figure
plot(Ttr((p+1):(Ntr-1)),TrOutput, 'b.', 'LineWidth', 4)
hold on
plot(Ttr((p+1):(Ntr-1)), PredOutput, 'g.', 'LineWidth', 1)
title('Time Series: Regression One step prediction (Training Set)')
xlabel('Time (s)')
ylabel('X(t)')
ErrorTr =  sum((PredOutput-TrOutput).^2)/(length(TrOutput))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%           Test Sample

Nts = length(Xts);
TsInput = ones(Nts-(p+1),p);
TsOutput(:,1) = Xts((p+1):(Nts-1));%,1);
for i = 1:p
    TsInput(:,i) = Xts((i):(Nts-(p+2)+i));
end

PredictionTs = TsInput*w;

figure
plot(Ttr((p+1):(Ntr-1)),TrOutput, 'b')%, 'LineWidth', 2)
hold on
%figure
plot(T,X,'b.')
plot(Tts((p+1):(Nts-1)), PredictionTs, 'g')%, 'LineWidth', 2)
title('Time Series: Regression One step ahead prediction')
xlabel('Time (s)')
ylabel('X(t)')
ErrorTs = sum((PredictionTs-TsOutput).^2)/(length(TsOutput))






















return






%%%%%%%%%%%%%%%%%%%%%%% Feeding back %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Cambiando el "numero" que sumamos a p en el siguiente for cortamos el
% aprendizaje a tantas filas como ese "numero". Cuanto antes lo cortemos,
% peor será la prediccion, aun asi no es mala.

for j = 1:(Ntr-(p+1))
    % Calculate regression model in each row
    w = TrInput(j,:)\TrOutput(j);
    % Use this model to make prediction of that Output
    TrPrediction = TrInput(j,:)*w;
    % Include this prediction as point in the Input ####(por ahora siguiente fila solo)####: update Input with
    % predictions --> Unsupervised Learning!! --> w, ya que va actualizando
    for n = 1:p
        if j+n <= Ntr-(p+1)
           TrInput(j+n,p+1-n) = TrPrediction;
           % Updating the Input matrix row by row
           %Input(j+1,p) = Prediction;
           %Input(j+2,p-1) = Prediction;
           %Input(j+3,p-2) = .....
        end
    end
end


TrPrediction = TrInput((Ntr-(p+1)),:)*w;
% Plot de el ultimo punto en Output con la prediccion de ese mismo punto y
% error estimandolo
figure
plot(TrOutput(Ntr-(p+1)),TrPrediction,'bx','Linewidth',2)
hold on
xlabel('Target')
ylabel('Prediction')
title('Train set Check')
line([0.5 1.5], [0.5 1.5])
axis([1 1.15 1 1.15])
ERROR = ((TrOutput(Ntr-(p+1))-TrPrediction).^2)


GeneralTrPrediction = TrInput(:,:)*w;
figure
plot([1:length(GeneralTrPrediction)],GeneralTrPrediction, 'b.', 'LineWidth', 2)
hold on
plot([1:length(GeneralTrPrediction)],TrOutput, 'g.', 'LineWidth', 2)



% Testeando:

Nts = length(Xts);
TsInput = ones(Nts-(p+1),p);
TsOutput = ones(Nts-(p+1),1);
TsOutput(:,1) = Xts((p+1):(Nts-1));%,1);
for i = 1:p
    TsInput(:,i) = Xts((i):(Nts-(p+2)+i));
end

TsPrediction = TsInput(1,:)*w;
TsTarget = TsOutput(1);

ErrorTs = ((TsTarget-TsPrediction).^2)
figure
plot(TsTarget,TsPrediction,'rx','Linewidth',2)
xlabel('Target')
ylabel('Prediction')
title('One-Step ahead prediction in Test Set')
hold on
line([0.5 1.5], [0.5 1.5])
% axis([1 1.15 1 1.15])
% Aqui tengo que hacer lo mismo que en el loop de arriba pero con el test
% set: ir prediciendo puntos y sustituyendo en TestInput

%OutputPrediction = zeros(length(Xts),1);
%for k = 2:length(Xts)
%    OutputPrediction(k) = w

GeneralTsPrediction = TsInput(:,:)*w;

figure
plot([1:length(GeneralTsPrediction)],GeneralTsPrediction, 'r.', 'LineWidth', 2)
hold on
plot([1:length(GeneralTsPrediction)],TsOutput, 'g.', 'LineWidth', 2)

display([TsOutput GeneralTsPrediction])
ErrorTsSet = sum((GeneralTsPrediction-TsOutput).^2)/(length(TsOutput))


% Check punto a punto
puntoInicial = 100; 
numeroPuntos= 30;
display([TsInput(puntoInicial:(puntoInicial+numeroPuntos),20) TsOutput(puntoInicial:(puntoInicial+numeroPuntos)) GeneralTsPrediction(puntoInicial:(puntoInicial+numeroPuntos))])

