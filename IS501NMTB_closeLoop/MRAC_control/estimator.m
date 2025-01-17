function a_est = estimator(input)
% Estimator Function
% Computes the estimated matrices `a_r_est` and `a_y_est` based on input parameters
% such as system states, reference inputs, error feedback, and gain matrices.

    % Extract error feedback matrix (diagonal)
    e = diag([input(1), input(2), input(3)]); % Diagonal matrix of error gains
    
    % Extract reference inputs and system outputs
    r = [input(4), input(5), input(6)]'; % Column vector of reference inputs
    y = [input(7), input(8), input(9)]'; % Column vector of system outputs
    
    % Extract adaptive gain matrix (diagonal)
    gamma = diag([input(10), input(11), input(12)]); % Adaptive gain matrix
    
    % Extract elements of the L matrix (system dynamics)
    Lxx = input(13); % Diagonal element for x-direction
    Lyy = input(14); % Diagonal element for y-direction
    Lzz = input(15); % Diagonal element for z-direction
    
    % Define off-diagonal elements as zero (commented inputs are placeholders)
    % Uncomment these if you want to make the system fully parameterizable
    % Lxy = input(16);
    % Lxz = input(17);
    % Lzy = input(18);
    Lxy = 0; % Coupling between x and y is zero
    Lxz = 0; % Coupling between x and z is zero
    Lzy = 0; % Coupling between z and y is zero
    
    % Extract damping coefficients for the B matrix
    B_1 = input(19); % Damping coefficient in x-direction
    B_2 = input(20); % Damping coefficient in y-direction
    B_3 = input(21); % Damping coefficient in z-direction
    
    % Construct L matrix (system dynamics matrix)
    L = [Lxx, Lxy, Lxz;
         Lxy, Lyy, Lzy;
         Lxz, Lzy, Lzz]; % Symmetric matrix of system dynamics
    
    % Construct B matrix (damping matrix)
    B = diag([B_1, B_2, B_3]); % Diagonal matrix of damping coefficients
    
    % Compute bp matrix (scaled system dynamics)
    bp = B * inv(L); % Product of B and the inverse of L
    
    % Compute estimated gain matrices
    a_r_est = -sign(bp) * gamma * e * r; % Gain matrix for reference inputs
    a_y_est = -sign(bp) * gamma * e * y; % Gain matrix for system outputs
    
    % Concatenate estimated gains into a single output
    a_est = [a_r_est; a_y_est]; % Stack a_r_est and a_y_est vertically
end