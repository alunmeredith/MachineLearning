REPS = 2;
TRAINFRAC = 0.8;
CV_FOLDS = 5;

load('redWine.mat'); %returns "redWine" matrix
load -ascii housing.data; %returns "housing" matrix
%[f, Y, N] = normalise(redWine); %normalise the data
[f, Y, N] = normalise(housing); %normalise the data

Ntrain = TRAINFRAC*N;
Ntest = (1-TRAINFRAC)*N;
ii = cvIndices(Y, round(TRAINFRAC / (1-TRAINFRAC)));

sig = zeros(CV_FOLDS,1);
for i = 1:CV_FOLDS
    Ytrain = Y(ii ~= i,:);
    Yval = Y(ii == i,:);
    ftrain = f(ii ~= i,:);
    fval = f(ii == i,:);
    sig(i) = norm( Ytrain(ceil(rand*Ntrain),:) - Ytrain(ceil(rand*Ntrain),:) );
end
sig = mean(sig);

rtest=zeros(REPS,1);
rtrain=zeros(REPS,1);
for i = 1:REPS
    [rtest(i), rtrain(i)] = labFiveScript(round(Ntrain/1.5), f, Y, ii, sig);
end