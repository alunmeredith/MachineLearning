%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%    FINANCIAL TIME SERIES     %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%   Plot the real data into a graph to see the behaviour of the Stock Market

% Close: Value of the Stock Market at its Close of each day
figure
plot(Date, Close, 'b')
title('FTSE100   dec2010 - dec2015', 'FontSize', 16)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%           Tomorrow's prediction

%Here I use the "Close" vector instead of TrInput because in the Input matrix we have
%not defined the last value as it was the last Output used to create the
%model.
%PredTomorrowRegr = Close((N-p+1):N)'*w
%%%%%  ErrorPrediction = ((PredTomorrow-VALUE_TOMORROW).^2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Training NN with ALL past data to predict tomorrow's value
%%

Date = flipud(Date);
Close = flipud(Close);


N = length(Close);
p = 20;
TrInput = ones(N-(p+1),p);
TrOutput(:,1) = Close((p+1):(N-1));
for i = 1:p
    TrInput(:,i) = Close((i):(N-(p+2)+i));
end

[net] = feedforwardnet(30);
[net] = train(net, TrInput', TrOutput');

PredOutputNN = zeros(length(TrOutput),1);
for i=1:length(TrInput)
  PredOutputNN(i) = net(TrInput(i,:)');
end

figure
plot(Date((p+1):(N-1)),TrOutput, 'b')
hold on
plot(Date((p+1):(N-1)), PredOutputNN, 'r')
title('FTSE100: NN one step ahead prediction')
xlabel('')
ylabel('')
ErrorFTSE_NN =  sum((PredOutputNN-TrOutput).^2)/(length(TrOutput))


%%

%    FEEDBACK

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


