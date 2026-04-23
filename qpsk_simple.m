%% 1. Parameters
am = 5;               % Amplitude
fc = 40;              % Carrier Frequency
fs = 800;             % Sampling Frequency
bits = [1 0 1 1 0 1 0 0]; % 8 bits = 4 QPSK symbols
Tb_samples = 100;     % Samples per bit duration

% Initialize vectors
total_samples = (length(bits)/2) * Tb_samples;
t = (0:total_samples-1) / fs;
m_i = zeros(1, total_samples); % In-phase message (Odd bits)
m_q = zeros(1, total_samples); % Quadrature message (Even bits)

%% 2. Split Bits into I and Q Channels (Nested Loops)
% We process 2 bits at a time to make 1 symbol
for i = 1:2:length(bits)
    % Map bits to Polar (+1/-1)
    val_i = 2*bits(i) - 1;   % Odd bit (1st, 3rd...)
    val_q = 2*bits(i+1) - 1; % Even bit (2nd, 4th...)
    
    % Find where this symbol starts/ends in the time vector
    symbol_num = (i+1)/2;
    start_idx = (symbol_num-1) * Tb_samples + 1;
    end_idx = symbol_num * Tb_samples;
    
    for j = start_idx:end_idx
        m_i(j) = val_i;
        m_q(j) = val_q;
    end
end

%% 3. Modulation
c_i = am * cos(2*pi*fc*t); % In-phase Carrier
c_q = am * sin(2*pi*fc*t); % Quadrature Carrier

% Combine them: QPSK is the sum of two BPSK signals
y = (m_i .* c_i) + (m_q .* c_q);

%% 4. Visualization
subplot(3,1,1); plot(t, m_i); title('I-Channel (Odd Bits)'); ylim([-1.5 1.5]);
subplot(3,1,2); plot(t, m_q); title('Q-Channel (Even Bits)'); ylim([-1.5 1.5]);
subplot(3,1,3); plot(t, y);   title('Final QPSK Modulated Signal');