% Improved Eye Diagram - Intuitive Manual Implementation
n_bits = 200;               % More bits to fill the diagram
sps = 100;                  % Samples per symbol
bits = randi([0 1], 1, n_bits);
bipolar_signal = 2*bits - 1;

% 1. Create a continuous signal with transitions (Rectangular pulses)
rect_pulse = ones(1, sps);
signal = kron(bipolar_signal, rect_pulse);

% 2. Apply a simple filter to create slopes (Essential for the "Eye")
% This mimics bandwidth limitation/ISI
filter_order = sps; 
h = ones(1, filter_order) / filter_order; % Moving average filter
smoothed_signal = conv(signal, h, 'same');

% 3. Add a touch of noise
smoothed_signal = smoothed_signal + 0.05 * randn(size(smoothed_signal));

% 4. Plotting logic
figure; hold on; grid on;
trace_len = 2 * sps; % Display 2 symbol periods
offset = sps/2;      % Shift to center the "eye"

for i = offset : sps : (length(smoothed_signal) - trace_len)
    plot(linspace(0, 2, trace_len), smoothed_signal(i : i + trace_len - 1), 'b');
end

title('Corrected Eye Diagram (Bipolar NRZ)');
xlabel('Symbol Duration (2T)');
ylabel('Amplitude');
ylim([-1.5 1.5]);
