clear all; 
close all; 
clc;

dx = 0.001;
t = -10:dx:10;

% x(t) Input Pulse
x = 0*t;

ind1 = t >= 0 & t < 1;
ind2 = t >= 1 & t <= 2;

x(ind1) = 1;
x(ind2) = -1;

% h = x(T - t) and T = 2
% Impulse Response of Matched Filter
h = 0*t;

ind3 = t >= 0 & t < 1;
ind4 = t >= 1 & t <= 2;

h(ind3) = -1;
h(ind4) = 1;

y = dx * conv(x, h, "same");   % Matched Filter Output

figure;

subplot(3, 1, 1);
plot(t, x, "LineWidth", 2);
xlabel('Time (s)');
ylabel('Amplitude');
title('Input Pulse x(t)');
grid on;

subplot(3, 1, 2);
plot(t, h, "LineWidth", 2);
xlabel('Time (s)');
ylabel('Amplitude');
title('Impulse Response of Matched Filter h(t) = x(T - t); T = 2');
grid on;

subplot(3, 1, 3);
plot(t, y, "LineWidth", 2);
xlabel('Time (s)');
ylabel('Amplitude');
title('Output Pulse y(t)');
grid on;
