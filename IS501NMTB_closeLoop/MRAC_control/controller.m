function u = controller(input)
% Controller Function
% Computes the control signal `u` based on reference inputs `r`, system outputs `y`,
% and estimated gain matrices `a_r_est` and `a_y_est`.

    % Extract reference inputs (desired states) from the input vector
    r = [input(1), input(2), input(3)]'; % Column vector of reference inputs
    
    % Extract system outputs (current states) from the input vector
    y = [input(4), input(5), input(6)]'; % Column vector of system outputs
    
    % Construct diagonal matrices for the estimated gains
    a_r_est = diag([input(7), input(8), input(9)]);  % Estimated gains for the reference inputs
    a_y_est = diag([input(10), input(11), input(12)]); % Estimated gains for the system outputs
    
    % Compute the control signal as a weighted combination of r and y
    u = a_r_est * r + a_y_est * y; % Control law: u = a_r_est*r + a_y_est*y
end


