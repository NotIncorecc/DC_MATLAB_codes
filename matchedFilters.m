%% 1. Parameters
dx = 0.01;                  % Sample spacing
t = -5:dx:5;                % Time vector

%% 2. Create the Input Pulse x(t)
% Let's create a pulse that is +1 from [0,1] and -1 from [1,2]
x = (t >= 0 & t < 1) - (t >= 1 & t <= 2); 

%% 3. Design the Matched Filter h(t)
% Rule: h(t) = x(T - t). For a pulse ending at T=2, h(t) is x(2-t)
% Intuitively: h(t) is just the input pulse flipped horizontally.
h = fliplr(x); 

%% 4. Filter Output y(t)
% Convolution mirrors the physical "sliding" of the signal through the filter
y = conv(x, h, 'same') * dx; 

%% 5. Visualization
subplot(3,1,1); plot(t, x, 'LineWidth', 2); title('Input Pulse x(t)'); grid on;
subplot(3,1,2); plot(t, h, 'LineWidth', 2); title('Impulse Response h(t) = x(T-t)'); grid on;
subplot(3,1,3); plot(t, y, 'LineWidth', 2); title('Matched Filter Output y(t)'); grid on;