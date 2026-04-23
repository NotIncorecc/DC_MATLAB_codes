%% 1. Parameters
nu = 2;               % Number of Users
ml = 4;               % Number of bits per user
hl = 4;               % Spreading factor (Hadamard length)
H = hadamard(hl);     % Generate unique 'languages' (codes) for users

%% 2. Transmitter: Spreading
tx_signal = zeros(1, ml * hl);

for k = 1:nu
    % Generate random bits for user k and map to BPSK (+1, -1)
    bits = (randi([0 1], 1, ml) * 2) - 1;
    
    % Get the unique code for this user (Row k of Hadamard matrix)
    user_code = H(k, :);
    
    % Spread the bits: Each bit is multiplied by the entire code
    % Using kron() is the most intuitive way to 'stretch' bits with the code
    spread_bits = kron(bits, user_code);
    
    % Add this user's signal to the common channel (CDMA sum)
    tx_signal = tx_signal + spread_bits;
end

%% 3. Channel: Add Noise
%rx_signal = awgn(tx_signal, 10, 'measured');

%% 4. Receiver: Despreading (For User 1)
% To recover User 1's data, we multiply the received signal by User 1's code
user1_code = H(1, :);
% Reshape rx signal to align with the code length
rx_matrix = reshape(tx_signal, hl, ml);%reshape(rx_signal, hl, ml);

recovered_bits = zeros(1, ml);
for b = 1:ml
    % Dot product: Multiply received chunk by the specific user code
    % If the 'language' matches, the signal adds up (Integrate & Dump)
    decision_stat = sum(rx_matrix(:, b)' .* user1_code);
    
    if decision_stat > 0
        recovered_bits(b) = 1;
    else
        recovered_bits(b) = -1;
    end
end

%% 5. Visualization
subplot(2,1,1); stem(tx_signal); title('Combined CDMA Signal (All Users)');
subplot(2,1,2); stem(recovered_bits); title('Recovered Bits for User 1');