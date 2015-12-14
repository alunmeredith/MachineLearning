%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%    FINANCIAL TIME SERIES     %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%%%%%%   Regression (not asked)


N = length(Close);
p = 20;
TrInput = ones(N-(p+1),p);
TrOutput(:,1) = Close((p+1):(N-1));%,1);

for i = 1:p
    TrInput(:,i) = Close((i):(N-(p+2)+i));
end

w = TrInput\TrOutput;
PredRegr = TrInput*w;

figure
plot(Date((p+1):(N-1)),TrOutput, 'b')
hold on
plot(Date((p+1):(N-1)), PredRegr, 'g')
title('FTSE100:  Real value vs Prediction')
xlabel('')
ylabel('')
ErrorFTSE_Regr =  sum((PredRegr-TrOutput).^2)/(length(TrOutput))

