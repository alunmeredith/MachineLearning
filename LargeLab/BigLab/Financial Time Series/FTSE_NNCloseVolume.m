
% Prediction using the Volume as well

N = length(Close);
p = 20;
CloseInput = ones(N-(p+1),p);
VolumeInput = ones(N-(p+1),p);
Output(:,1) = Close((p+1):(N-1));
for i = 1:p
    CloseInput(:,i) = Close((i):(N-(p+2)+i));
    VolumeInput(:,i) = Volume((i):(N-(p+2)+i));
end
Input = [CloseInput VolumeInput];

[net] = feedforwardnet(50);
[net] = train(net, Input', Output');

PredNN = zeros(length(Output),1);
for i=1:length(Input)
  PredNN(i) = net(Input(i,:)');
end

figure
plot(Date((p+1):(N-1)),Output, 'b')%, 'LineWidth', 2)
hold on
plot(Date((p+1):(N-1)), PredNN, 'r')%, 'LineWidth', 2)
title('FTSE100: Close+Volume prediction')
xlabel('')
ylabel('')
ErrorFTSE_CloseVolume =  sum((PredNN-Output).^2)/(length(Output))




return
%%

%    FEEDBACK  TODO!

Date = flipud(Date);
Close = flipud(Close);


N = length(Close);
Xtr = Close((1:ceil(4*N/5)));
Xts = Close(((ceil(4*N/5)+1):N));
Ttr = Date((1:ceil(4*N/5)));
Tts = Date(((ceil(4*N/5)+1):N));

Ntr = length(Xtr);
p = 20;
TrInput = ones(Ntr-(p+1),p);
%TrOutput = ones(Ntr-(p+1),1);
TrOutput(:,1) = Xtr((p+1):(Ntr-1));%,1);
for i = 1:p
    TrInput(:,i) = Xtr((i):(Ntr-(p+2)+i));
end

[net] = feedforwardnet(30);
[net] = train(net, TrInput', TrOutput');

%%%%%%%%%%%%%%%%%%%%%%%%%%    Test Set    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nts = length(Xts);
TsInput = ones(Nts-(p+1),p);
TsOutput(:,1) = Xts((p+1):(Nts-1));
for j = 1:p
    TsInput(:,j) = Xts((j):(Nts-(p+2)+j));
end


PredictionFeedback = zeros(length(TsInput),1);
for j = 1:length(TsInput)
    PredictionFeedback(j)  = net(TsInput(j,:)');
    for n = 1:p
        if j+n <= Nts-(p+1)
           TsInput(j+n,p+1-n) = PredictionFeedback(j);
        end
    end
end

figure
%plot(Ttr((p+1):(Ntr-1)),TrOutput, 'b')
%hold on
%plot(Tts((p+1):(Nts-1)), TsOutput, 'r')
plot(Date, Close, 'b')
hold on
plot(Tts((p+1):(Nts-1)), PredictionFeedback, 'r')
title('FTSE: Feedback NN prediction')
ErrorTsFeedback = sum((PredictionFeedback-TsOutput).^2)/(length(TsOutput))



