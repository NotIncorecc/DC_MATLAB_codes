% --- Setup Parameters ---
bits = randi([0 1], 1, 200);     % Use 200 bits for a clear "eye"
N = 100;                         % Samples per bit
Tb = 1;                          % Bit duration
SNR_dB = 15;                     % Signal-to-Noise Ratio

% 1. Generate Polar NRZ Signal (Manual loop to avoid inbuilt functions)
total_samples = length(bits) * N;
sig = zeros(1, total_samples);
for i = 1:length(bits)
    start_idx = (i-1)*N + 1;
    end_idx = i*N;
    sig(start_idx : end_idx) = 2*bits(i) - 1; 
end

% 2. Add Noise
noise = (10^(-SNR_dB/20)) * randn(1, total_samples);
sig_noisy = sig + noise;

% --- MANUAL EYE DIAGRAM LOGIC (The "Wrapping" Technique) ---
samples_per_trace = 2 * N; % We look at 2 bit periods [cite: 43]
num_traces = floor(total_samples / samples_per_trace);

% Reshape stacks segments of the signal on top of each other [cite: 44, 46]
eye_matrix = reshape(sig_noisy(1 : num_traces * samples_per_trace), samples_per_trace, num_traces);

% Create local time axis for 2 bit periods [cite: 49]
t_eye = linspace(0, 2*Tb, samples_per_trace);

% --- Plotting with Stability Fixes ---
fig = figure;
set(fig, 'Renderer', 'painters'); % FIX: Avoids WebGL/Graphics errors

% Plot using a standard color to reduce GPU load
plot(t_eye, eye_matrix, 'Color', [0 0.4 0.8]); 

grid on;
title('Simplified NRZ Eye Diagram (Manual Wrap)');
xlabel('Time (Units of Tb) --->');
ylabel('Amplitude --->');
xticks([0 Tb 2*Tb]);
xticklabels({'0','Tb','2Tb'});