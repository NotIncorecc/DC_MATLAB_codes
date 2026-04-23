% --- Setup Parameters ---
bits = [1 0 1 1 0];              % Input bit sequence
N = 100;                         % Samples per bit (Samples_per_bit)
total_samples = length(bits) * N;
t = 0:total_samples-1;           % Time vector

% Initialize signal arrays
unrz = zeros(1, total_samples);
pnrz = zeros(1, total_samples);
manchester = zeros(1, total_samples);

% --- Main Encoding Loop ---
for i = 1:length(bits)
    % Calculate the start and end index for the current bits samples
    start_idx = (i-1)*N + 1;
    end_idx = i*N;
    mid_point = start_idx + N/2;
    
    current_bit = bits(i);
    
    % Secondary loop to fill samples for the duration of one bit
    for j = start_idx:end_idx
        
        %% 1. Unipolar NRZ: 1 remains 1, 0 remains 0 [cite: 62]
        unrz(j) = current_bit;
        
        %% 2. Polar NRZ: Map 0 -> -1 and 1 -> 1 (Formula: 2x - 1) [cite: 63]
        pnrz(j) = 2*current_bit - 1;
        
        %% 3. Manchester: Transition at the middle (T/2) 
        % If bit is 1: High for first half, Low for second half [cite: 66]
        % If bit is 0: Low for first half, High for second half [cite: 66]
        polar_val = 2*current_bit - 1; 
        
        if j < mid_point
            manchester(j) = polar_val;     % First half
        else
            manchester(j) = -polar_val;    % Second half (transition)
        end
    end
end

% --- Plotting ---
figure;
subplot(3,1,1); plot(t, unrz, 'LineWidth', 2); title('Unipolar NRZ'); grid on; ylim([-0.5 1.5]);
subplot(3,1,2); plot(t, pnrz, 'LineWidth', 2); title('Polar NRZ'); grid on; ylim([-1.5 1.5]);
subplot(3,1,3); plot(t, manchester, 'LineWidth', 2); title('Manchester'); grid on; ylim([-1.5 1.5]);