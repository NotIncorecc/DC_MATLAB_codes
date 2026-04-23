% Gram-Schmidt Orthogonalization with 3D Visualization
A = [2 1 0; 1 3 1; 0 1 2]; % Input matrix (columns are vectors v1, v2, v3)
[m, n] = size(A);
Q = zeros(m, n);

figure; hold on; grid on; view(3);
colors_orig = ['r', 'g', 'b']; % Colors for original vectors
colors_orth = ['m', 'c', 'y']; % Colors for orthogonal vectors

for k = 1:n
    temp = A(:, k);
    
    % Plot original vector (dashed line)
    quiver3(0,0,0, A(1,k), A(2,k), A(3,k), 0, 'Color', colors_orig(k), ...
        'LineStyle', '--', 'LineWidth', 1.5, 'DisplayName', ['Original v' num2str(k)]);
    
    for j = 1:k-1
        % Gram-Schmidt projection step
        projection = (Q(:, j)' * A(:, k)) / (Q(:, j)' * Q(:, j));
        temp = temp - projection * Q(:, j);
    end
    Q(:, k) = temp; 
    
    % Plot the resulting orthogonal vector (solid line)
    quiver3(0,0,0, Q(1,k), Q(2,k), Q(3,k), 0, 'Color', colors_orig(k), ...
        'LineWidth', 2.5, 'DisplayName', ['Orthogonal u' num2str(k)]);
end

title('Gram-Schmidt Process: Original vs Orthogonal Vectors');
xlabel('X-axis'); ylabel('Y-axis'); zlabel('Z-axis');
legend('Location', 'northeastoutside');
axis equal;

% Verify orthogonality numerically
disp('Dot products (should be near zero):');
disp(['u1 . u2 = ', num2str(Q(:,1)' * Q(:,2))]);
disp(['u1 . u3 = ', num2str(Q(:,1)' * Q(:,3))]);
disp(['u2 . u3 = ', num2str(Q(:,2)' * Q(:,3))]);
