%% 1. Parameters
am = 5;               % Amplitude of Carrier
fc = 40;              % Carrier Frequency
fs = 800;             % Sampling Frequency
bits = [1 0 1 1 0];   % Input bit sequence
Tb_samples = 100;     % Samples per bit duration [cite: 39]

% Initialize vectors
total_samples = length(bits) * Tb_samples;
mt = zeros(1, total_samples); % Polar Message signal
t = (0:total_samples-1) / fs; % Time vector

%% 2. Generate Polar Message Signal m(t)
% In BPSK, we map bit 1 -> +1 and bit 0 -> -1 
for i = 1:length(bits)
    start_idx = (i-1) * Tb_samples + 1;
    end_idx = i * Tb_samples;
    
    % Mathematical Mapping: 2*bit - 1 converts (1,0) to (+1,-1) 
    polar_value = 2*bits(i) - 1; 
    
    for j = start_idx:end_idx
        mt(j) = polar_value; 
    end
end

%% 3. Generate Carrier and Modulated Signal y(t)
c = am * sin(2*pi*fc*t);     % Carrier wave
y = mt .* c;                 % BPSK Modulation (Phase Reversal) [cite: 16, 45]

%% 4. Demodulation (Coherent Detection)
%y_noisy = awgn(y, 20, 'measured'); % Add noise
%yd = y_noisy .* c;                 % Multiply by carrier to recover baseband [cite: 47]

%% 5. Visualization
subplot(3,1,1); plot(t, mt, 'LineWidth', 2); title('Polar Message m(t)'); grid on;
subplot(3,1,2); plot(t, y, 'LineWidth', 1); title('BPSK Modulated Signal'); grid on;
%subplot(3,1,3); plot(t, yd, 'LineWidth', 1); title('Demodulated Signal (Raw)'); grid on;