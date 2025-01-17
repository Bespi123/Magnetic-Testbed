% Extract simulation outputs
tout = out.tout;        % Time vector from simulation output
yout = out.simout;      % 3D array representing the satellite perturbations
yout1 = out.simout1;    % 3D array representing the estimated perturbations

% Initialize arrays to store perturbation data
n = size(yout, 3);      % Number of slices in the 3D output arrays
p_est = zeros(n, 3);    % Preallocate array for estimated perturbations
p_sat = zeros(n, 3);    % Preallocate array for satellite perturbations

% Extract data from the 3D arrays slice by slice
numSlices = size(yout, 3); % Number of slices in the 3D array
for j = 1:numSlices
    % Extract data for each slice into 2D arrays
    p_est(j, :) = yout1(:, :, j); % Estimated perturbations for slice j
    p_sat(j, :) = yout(:, :, j);  % Satellite perturbations for slice j
end

% Plot the estimated perturbations
figure();
sp1 = subplot(3, 1, 1); % First subplot for x-axis perturbations
p1 = semilogx(tout, p_est(:, 1), 'LineWidth', 2); grid on; % Plot x-axis perturbations
title('Estimated Perturbations'); % Title for the figure
xlabel('time (s)'); ylabel('\Delta B_p x (nT)'); % Axis labels

sp2 = subplot(3, 1, 2); % Second subplot for y-axis perturbations
p1 = semilogx(tout, p_est(:, 2), 'LineWidth', 2); grid on; % Plot y-axis perturbations
xlabel('time (s)'); ylabel('\Delta B_p y (nT)'); % Axis labels

sp3 = subplot(3, 1, 3); % Third subplot for z-axis perturbations
p1 = semilogx(tout, p_est(:, 3), 'LineWidth', 2); grid on; % Plot z-axis perturbations
xlabel('time (s)'); ylabel('\Delta B_p z (nT)'); % Axis labels

% Link the x-axes of all subplots for synchronized zooming and panning
linkaxes([sp1, sp2, sp3], 'x');

% Plot the satellite perturbations
figure();
sp1 = subplot(3, 1, 1); % First subplot for x-axis satellite perturbations
p1 = semilogx(tout, p_sat(:, 1), 'LineWidth', 2); grid on; % Plot x-axis satellite perturbations
title('Satellite Perturbations'); % Title for the figure
xlabel('time (s)'); ylabel('B_{sat} x (nT)'); % Axis labels

sp2 = subplot(3, 1, 2); % Second subplot for y-axis satellite perturbations
p1 = semilogx(tout, p_sat(:, 2), 'LineWidth', 2); grid on; % Plot y-axis satellite perturbations
xlabel('time (s)'); ylabel('B_{sat} y (nT)'); % Axis labels

sp3 = subplot(3, 1, 3); % Third subplot for z-axis satellite perturbations
p1 = semilogx(tout, p_sat(:, 3), 'LineWidth', 2); grid on; % Plot z-axis satellite perturbations
xlabel('time (s)'); ylabel('B_{sat} z (nT)'); % Axis labels

% Link the x-axes of all subplots for synchronized zooming and panning
linkaxes([sp1, sp2, sp3], 'x');

% Set limits for each subplot for better visualization
subplot(3, 1, 1); ylim([-10 10]); % Limit for x-axis subplot
subplot(3, 1, 2); ylim([0 25]);   % Limit for y-axis subplot
subplot(3, 1, 3); ylim([0 40]);   % Limit for z-axis subplot
