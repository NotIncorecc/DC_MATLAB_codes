%% 1. Parameters
am = 5;               % Amplitude of Message Signal (Logic 1)
fc = 40;              % Carrier Frequency
fs = 800;             % Sampling Frequency
bits = [1 0 1 1 0];   % Input bit sequence
Tb_samples = 100;     % Number of samples per bit duration

% Initialize vectors
total_samples = length(bits) * Tb_samples;
m = zeros(1, total_samples);
t = (0:total_samples-1) / fs; % Time vector

%% 2. Generate Message Signal m(t) using Nested Loops
% This replaces repelem() by manually filling sample ranges
for i = 1:length(bits)
    start_idx = (i-1) * Tb_samples + 1;
    end_idx = i * Tb_samples;
    
    for j = start_idx:end_idx
        m(j) = bits(i) * am; % Scale bit by amplitude [cite: 13, 23]
    end
end

%% 3. Generate Carrier and Modulated Signal y(t)
c = sin(2*pi*fc*t);          % Carrier wave
y = m .* c;                  % BASK Modulation (On-Off Keying) [cite: 13, 16]

%% 4. Demodulation (Coherent Detection)
%y_noisy = awgn(y, 10, 'measured'); % Add noise [cite: 19]
%yd = y_noisy .* c;                 % Multiply by carrier again 

%% 5. Visualization
subplot(3,1,1); plot(t, m, 'LineWidth', 2); title('Digital Message m(t)'); grid on;
subplot(3,1,2); plot(t, y, 'LineWidth', 1); title('BASK Modulated Signal'); grid on;
%subplot(3,1,3); plot(t, yd, 'LineWidth', 1); title('Demodulated Signal (Before Filtering)'); grid on;