%% 1. Parameters
fs = 10000;           % Sampling frequency
t = 0:1/fs:1;         % Time vector (1 second)
fm = 2;               % Message frequency (Hz)
fc = 25;              % Carrier frequency (Hz) - determines pulse rate

%% 2. Signal Generation
% Message signal (Sine wave)
m = sin(2*pi*fm*t); 

% Carrier signal (Square pulse train)
% 'duty', 10 creates narrow pulses for sampling
c = 0.5 * (square(2*pi*fc*t, 10) + 1); 

%disp(m);
%disp(c);

%% 3. Modulation (Natural vs. Flat-Top)
% Natural Sampling: Just multiply message by pulse train
pam_natural = m .* c;

% Flat-Top Sampling: Hold the value of 'm' at the start of the pulse
% We use 'sample-and-hold' logic here
pam_flat = zeros(size(t));
for i = 1:length(t)
    if c(i) > 0
        if i == 1 || c(i-1) == 0  % If pulse just started
            hold_val = m(i);      % Capture the message value
        end
        pam_flat(i) = hold_val;   % Hold it for the duration of the pulse
    end
end

%% 4. Visualization
subplot(3,1,1); plot(t, m); title('Message Signal');
subplot(3,1,2); plot(t, c); title('Pulse Train (Carrier)');
subplot(3,1,3); plot(t, pam_flat, 'r', t, m, 'b--'); 
title('Flat-Top PAM Signal');
legend('PAM', 'Original Message');