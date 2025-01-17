function J = myObjectiveFunction(k)
% Objective Function Template Using a Simulink Block Diagram
% This function evaluates a controller's performance using a Simulink model.
% Input:
%   k - A vector containing the controller parameters.
% Output:
%   J - The fitness value based on the controller's performance.

% Acknowledgment:
% Professor Juan Pablo Requez Vivas for the Intelligent Control
% course - UNEXPO - 2023 - jrequez@unexpo.edu.ve
% Modified by Bespi123 on 26/02/2024

%%%%%%%%%%%%%%%%%%%     SECTION 1: Variables          %%%%%%%%%%%%%%%%%%%%%
% Set controller parameters from input vector k
sim_parameters; % Load required parameters (ensure this file exists and is correctly configured)

x.PID.Kp = k(1);
x.PID.Ki = k(2);
x.PID.Kd = k(3);
y.PID.Kp = k(4);
y.PID.Ki = k(5);
y.PID.Kd = k(6);
z.PID.Kp = k(7);
z.PID.Ki = k(8);
z.PID.Kd = k(9);

%%%%%%%%%%%%%%%%%%%     SECTION 3: Pre-Calculations   %%%%%%%%%%%%%%%%%%%%%
% Add any necessary pre-calculations for the objective function here

%%%%%%%%%%%%%%%%%%% SECTION 4: Simulate the Process  %%%%%%%%%%%%%%%%%%%%%%
try
    % Simulate the Simulink model
    salidas = sim('pid_controller.slx', 'SrcWorkspace', 'current');
    stable = 1;
catch exception
    % Handle unstable simulation or other errors
    if strcmp(exception.identifier, 'Simulink:Engine:DerivNotFinite')
        stable = 0;
        disp('System is not stable');
    else
        disp('An unexpected error occurred');
        stable = 0;
    end
end

if stable == 1
    % Extract simulation outputs
    yout = salidas.get('yout');
    t = salidas.get('tout');

    % Assume specific output indices for error (e), controller output (u), and system output (Y)
    temp.e = yout{1}.Values.Data;
    temp.u = yout{2}.Values.Data;
    temp.y = yout{5}.Values.Data;

    % Initialize arrays for 3D data slices
    numSlices = size(temp.e, 3);
    e = zeros(numSlices, 3);
    u = zeros(numSlices, 3);
    Y = zeros(numSlices, 3);

    % Extract data slice by slice
    for j = 1:numSlices
        e(j, :) = temp.e(:, :, j);
        u(j, :) = temp.u(:, :, j);
        Y(j, :) = temp.y(:, :, j);
    end

    %%%%%%%%%%%%%%%%%%% SECTION 5: Calculate the Fitness  %%%%%%%%%%%%%%%%%%%%%%
    % Calculate performance metrics
    itse = trapz(t, e.^2); % Integral of time-weighted squared error
    itsy = trapz(t, Y.^2); % Integral of squared system output
    entropy = calculate_entropy(Y); % Shannon entropy of the output

    % Overshoot calculation
    [overshoot, ~] = calculateOvershoot(abs(Y), [0, 0, 0]);

    % Controller energy consumption
    uwork = trapz(t, u.^2);

    % Fitness value computation (sum of selected metrics)
    J = sum(itse + uwork + itsy + entropy + overshoot * 100);
else
    % Assign a high penalty for instability
    J = Inf;
end

end

function entropy = calculate_entropy(signal)
% Calculate the Shannon entropy for each column of a signal matrix.
% Input: signal (N x 3 matrix), where each column is a signal.
% Output: entropy (1 x 3 array), where each element is the entropy of a column.

    % Preallocate entropy array
    [~, numSignals] = size(signal);
    entropy = zeros(1, numSignals);

    % Calculate entropy for each column
    for col = 1:numSignals
        % Extract the column
        colSignal = signal(:, col);
        
        % Calculate unique values and probabilities
        unique_values = unique(colSignal);
        probabilities = histcounts(colSignal, unique_values) / numel(colSignal);
        probabilities(probabilities == 0) = []; % Avoid log(0)
        
        % Compute Shannon entropy
        entropy(col) = -sum(probabilities .* log2(probabilities));
    end
end