% Training Mackey-Glass function

%% Input parameters
a        = 0.2;     % value for a in eq (1)
b        = 0.1;     % value for b in eq (1)
tau      = 17;		% delay constant in eq (1)
x0       = 1.2;		% initial condition: x(t=0)=x0
deltat   = 0.1;	    % time step size (which coincides with the integration step)
sample_n = 2000;	% total no. of samples, excluding the given initial condition
interval = 1;	    % output is printed at every 'interval' time steps

time = 0;
index = 1;
history_length = floor(tau/deltat);
x_history = zeros(history_length, 1); % here we assume x(t)=0 for -tau <= t < 0
x_t = x0;

X = zeros(sample_n+1, 1); % vector of all generated x samples
T = zeros(sample_n+1, 1); % vector of time samples

for i = 1:sample_n+1,
    X(i) = x_t;
    if (mod(i-1, interval) == 0),
         %disp(sprintf('%4d %f', (i-1)/interval, x_t));
    end
    if tau == 0,
        x_t_minus_tau = 0.0;
    else
        x_t_minus_tau = x_history(index);
    end

    x_t_plus_deltat = mackeyglass_rk4(x_t, x_t_minus_tau, deltat, a, b);

    if (tau ~= 0),
        x_history(index) = x_t_plus_deltat;
        index = mod(index, history_length)+1;
    end
    time = time + deltat;
    T(i) = time;
    x_t = x_t_plus_deltat;
end

plot(T,X,'b.')
title('Mackey-Glass time series')
xlabel('time')
ylabel('X(t)')

return

% Split in training and test sets
N = sample_n;
Ttr = T((1:ceil(3*N/4)),:);
Xtr = X((1:ceil(3*N/4)),:);
Tts = T(((ceil(3*N/4)+1):N),:);
Xts = X(((ceil(3*N/4)+1):N),:);

% linear regression??? --> least squares??
%w = inv(Ttr'*Ttr)*Ttr'*Xtr;
%Xhts = Tts*w;
%Xhtr = Ttr*w;

% No funciona, como devuelve w=numero, lo unico q hace es reescalar Tts,
% por lo que tiene la misma forma!!!

%figure, clf,
%plot(Xtr, Xhtr, 'r.', 'LineWidth', 2)
%grid on
%xlabel('Target', 'FontSize', 14)
%ylabel('Prediction', 'FontSize', 14)
%% 
%title('Training Set', 'FontSize', 14)
%hold on
%line([-2 3], [-2 3])
%figure, clf,
%plot(Xts, Xhts, 'r.', 'LineWidth', 2)
%% 
%grid on
%xlabel('Target', 'FontSize', 14)
%ylabel('Prediction', 'FontSize', 14)
%title('Test Set', 'FontSize', 14)
%axis([-2 4 -3 3])
%hold on
%line([-2 3], [-2 3])
%ErrorTr = sum((Xhtr-Xtr).^2)/(length(Xtr))
%ErrorTs = sum((Xhts-Xts).^2)/(length(Xts))
%% 




