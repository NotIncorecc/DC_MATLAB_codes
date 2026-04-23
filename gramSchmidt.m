% --- Setup Parameters ---
T = 1;                              % Fundamental period
t = 0:0.5:T;                      % Time vector (reduced for performance)
dt = t(2) - t(1);                   % Integration step (dt)

% 1. Define Input Functions (Signals)
% You can change these to any set of signals you want to orthogonalize
s{1} = ones(size(t));               % s1: DC signal
s{2} = cos(2 * pi * t / T);         % s2: Cosine wave
s{3} = sin(2 * pi * t / T);         % s3: Sine wave
num_signals = length(s);

% Pre-allocate Cell Array for Basis Functions
u = cell(1, num_signals);

% --- Gram-Schmidt Process ---
for i = 1:num_signals
    % Start with the original signal
    w = s{i};
    
    % 2. Orthogonalization: Subtract projections of all previous basis functions
    for j = 1:i-1
        % Manual Inner Product: integral of (signal_i * basis_j) dt
        % Equivalent to sum(a .* b) * dt [cite: 465]
        projection_val = sum(s{i} .* u{j}) * dt; 
        w = w - projection_val * u{j};
    end
    
    % 3. Normalization: Ensure the remaining signal has unit energy (Energy = 1)
    % Manual Norm calculation: sqrt(integral of signal^2 dt) 
    energy = sum(w.^2) * dt;
    u{i} = w / sqrt(energy);
end

% --- Plotting Results ---
figure;
colors = ['r', 'g', 'b']; % Red, Green, Blue for the three signals
for i = 1:num_signals
    subplot(num_signals, 1, i);
    plot(t, u{i}, colors(i), 'LineWidth', 2);
    title(['Orthonormal Basis Function u' num2str(i) '(t)']);
    grid on; ylabel('Amplitude');
end
xlabel('Time (t)');