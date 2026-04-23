% --- Setup Parameters ---
Rb = 1;                     % Bit rate
Tb = 1/Rb;                  % Bit duration
f = 0:0.005*Rb:2*Rb;        % Frequency range
x = f*Tb;                   % Normalized frequency axis 

% --- Mathematical PSD Calculations ---

% 1. Polar NRZ: High energy at low frequencies
% Formula: Tb * sinc(f*Tb)^2 [cite: 180, 191]
PSD_polar = Tb * (sinc(x).^2);

% 2. Unipolar NRZ: Contains a DC component (dirac delta)
% Formula: 0.5 * Polar_PSD + 0.5 * Impulse at f=0 
PSD_unipolar = 0.5 * PSD_polar; 
% Note: In a plot, the dirac delta at f=0 is usually represented as a peak.

% 3. Bipolar (AMI): Null at DC (f=0), good for AC-coupled channels
% Formula: Tb * sinc(f*Tb/2)^2 * sin(pi*f*Tb)^2 
PSD_bipolar = Tb * (sinc(x/2).^2) .* (sin(pi*x).^2);

% 4. Manchester: Null at DC, wider bandwidth
% Formula: Tb * sinc(f*Tb/2)^2 * sin(pi*f*Tb/2)^2 
PSD_manchester = Tb * (sinc(x/2).^2) .* (sin(pi*x/2).^2);

% --- Plotting ---
figure;
hold on;
plot(f, PSD_polar, 'LineWidth', 2, 'DisplayName', 'Polar NRZ');
plot(f, PSD_unipolar, 'LineWidth', 2, 'DisplayName', 'Unipolar NRZ');
plot(f, PSD_bipolar, 'LineWidth', 2, 'DisplayName', 'Bipolar (AMI)');
plot(f, PSD_manchester, 'LineWidth', 2, 'DisplayName', 'Manchester');

grid on; box on;
xlabel('Frequency (f) --->');
ylabel('Power Spectral Density --->');
title('PSD for Various Binary Line Codes');
legend('Location', 'northeast');