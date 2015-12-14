function [ w, fh ] = linearReg( Y, f, w )
% This function gives predictions / model from training data
% If w = 'train' it trains the model, otherwise it uses the model provided
% to predict test data. 

% returns model and predictions
if strcmp(w, 'train')
    w = inv(Y'*Y)*Y'*f; %maths from lecture!
end
fh = Y*w;
figure(1), clf,
plot(f, fh, 'r.', 'LineWidth', 2),
grid on
s=getenv('USERNAME');
xlabel('True House Price', 'FontSize', 14)
ylabel('Prediction', 'FontSize', 14)
title(['Linear Regression: ' s], 'FontSize', 14)


%figure(1), clf,
%hist(f - fh, 20)
%grid on
%s=getenv('USERNAME');
%xlabel('Residual size', 'FontSize', 14)
%ylabel('Frequency', 'FontSize', 14)
%title(['Residual distribution: ' s], 'FontSize', 14)
end
