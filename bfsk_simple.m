%% 1. Parameters
am = 5;               % Amplitude
fc1 = 40;             % Frequency for Bit 1
fc2 = 20;             % Frequency for Bit 0
fs = 800;             % Sampling Frequency
bits = [1 0 1 1 0];   % Input bit sequence
Tb_samples = 100;     % Samples per bit duration

% Initialize vectors
total_samples = length(bits) * Tb_samples;
t = (0:total_samples-1) / fs;
mt = zeros(1, total_samples); % Message signal
y = zeros(1, total_samples);  % Modulated signal

%% 2. BFSK Modulation Loop
for i = 1:length(bits)
    start_idx = (i-1) * Tb_samples + 1;
    end_idx = i * Tb_samples;
    
    % Time segment for this specific bit
    t_segment = t(start_idx:end_idx);
    
    if bits(i) == 1
        % Switch to Frequency 1
        y(start_idx:end_idx) = am * cos(2*pi*fc1*t_segment);
        mt(start_idx:end_idx) = am;
    else
        % Switch to Frequency 2
        y(start_idx:end_idx) = am * cos(2*pi*fc2*t_segment);
        mt(start_idx:end_idx) = 0;
    end
end

%% 3. Demodulation (Non-Coherent logic)
y_noisy = y;%awgn(y, 15, 'measured');

% Step A: Correlate the noisy signal with both local carriers
yd1 = y_noisy .* cos(2*pi*fc1*t); 
yd2 = y_noisy .* cos(2*pi*fc2*t); 

% Step B: Integrate and Decide (The "Demodulated Wave" Logic)
recovered_mt = zeros(1, total_samples); % Initialize the output wave

for i = 1:length(bits)
    start_idx = (i-1) * Tb_samples + 1;
    end_idx = i * Tb_samples;
    
    % Manual Integration: Sum the energy for this bit duration
    sum1 = sum(yd1(start_idx:end_idx)); 
    sum2 = sum(yd2(start_idx:end_idx));
    
    % Decision Step: Which frequency was stronger?
    if sum1 > sum2
        recovered_mt(start_idx:end_idx) = am; % Recovered Logic 1
    else
        recovered_mt(start_idx:end_idx) = 0;  % Recovered Logic 0
    end
end

%% 4. Visualization
figure;
subplot(4,1,1); plot(t, mt); title('Original Message Signal'); ylim([-1 6]);
subplot(4,1,2); plot(t, y_noisy); title('Received Noisy BFSK Signal');
subplot(4,1,3); plot(t, yd1); title('Correlated with Frequency 1 (Logic 1 Branch)');
subplot(4,1,4); plot(t, recovered_mt, 'r', 'LineWidth', 2); title('Final Demodulated Wave'); ylim([-1 6]);

%%%
