%% 1. Parameters
fs = 10000;
t = 0:1/fs:0.5;       % Time vector
fm = 2;               % Message frequency (2 Hz)
fc = 20;              % Carrier frequency (20 Hz Sawtooth)

%% 2. Signal Generation
m = 0.5 * sin(2*pi*fm*t);     % Message (scaled)
c = sawtooth(2*pi*fc*t);      % Sawtooth Carrier [cite: 16]

%% 3. PWM Generation
% If message > carrier, pulse is HIGH (1), otherwise LOW (0) [cite: 19, 20]
pwm = m > c; 

%% 4. PPM Generation
% Detect the falling edge of PWM (where signal goes from 1 to 0) [cite: 21]
% diff(pwm) returns -1 at falling edges
pwm_diff = [0, diff(pwm)]; 
ppm_width = 10;                % Width of the fixed PPM pulse
ppm = zeros(size(t));

for i = 1:length(t) - ppm_width
    if pwm_diff(i) == -1       % Found a falling edge [cite: 21]
        ppm(i : i + ppm_width) = 1; 
    end
end

%% 5. Visualization
subplot(3,1,1); plot(t, m, 'b', t, c, 'r--'); 
title('Message (Blue) vs Sawtooth Carrier (Red) [cite: 17]');
subplot(3,1,2); plot(t, pwm); 
ylim([-0.1 1.1]); title('PWM: Width varies with Amplitude ');
subplot(3,1,3); plot(t, ppm, 'm'); 
ylim([-0.1 1.1]); title('PPM: Position varies with Amplitude ');