function p_dot = Dist_observer(input)
%%% Disturbance Observer Function
% Calculates the time derivative of the disturbance observer's state (p_dot)
% based on input parameters such as system states, control inputs, and observer gains.

%%% Input parameters
% Decompose the input vector into meaningful variables
x   = [input(1); input(2); input(3)]; % System state vector
u   = [input(4); input(5); input(6)]; % Control input vector
Lxx = input(7);  % Component of matrix L1 in the x-coil
Rx  = input(8);  % Resistance in the x-coil
B_1 = input(9);  % Damping coefficient in the x-coil
Lyy = input(10); % Component of matrix L1 in the y-coil
Ry  = input(11); % Resistance in the y-coil
B_2 = input(12); % Damping coefficient in the y-coil
Lzz = input(13); % Component of matrix L1 in the z-coil
Rz  = input(14); % Resistance in the z-coil
B_3 = input(15); % Damping coefficient in the z-coil
Lxy = input(16); % Off-diagonal term (x-y coupling) in matrix L
Lxz = input(17); % Off-diagonal term (x-z coupling) in matrix L
Lzy = input(18); % Off-diagonal term (z-y coupling) in matrix L
lambda = diag([input(19), input(20), input(21)]); % Observer gain matrix (diagonal)
p      = [input(22); input(23); input(24)]; % Current state of the disturbance observer

%%% Parameter reading
% Construct the L1 matrix (scaled dynamics matrix with coupling terms)
L1 = [Lxx, (B_1/B_2)*Lxy, (B_1/B_3)*Lxz;
      (B_2/B_1)*Lxy, Lyy, (B_2/B_3)*Lzy;
      (B_3/B_1)*Lxz, (B_3/B_2)*Lzy, Lzz];

% Construct the L matrix (unscaled dynamics matrix with coupling terms)
L = [Lxx, Lxy, Lxz;
     Lxy, Lyy, Lzy;
     Lxz, Lzy, Lzz];

% Construct diagonal resistance and damping matrices
R = diag([Rx, Ry, Rz]); % Resistance matrix
B = diag([B_1, B_2, B_3]); % Damping matrix

% Define observer system matrices
Ap = -inv(L1) * R; % State dynamics matrix for the disturbance observer
Bp = B / L * 1E9; % Control input matrix (scaled by 1E9)
%Cp = eye(3); % Output matrix (identity)
%Dp = 0; % Feedthrough matrix (not used in this function)

%%% Compute the time derivative of the disturbance observer's state
% Using the observer dynamics equation: p_dot = -lambda*p - lambda*(lambda*x + Ap*x + Bp*u)
p_dot = -lambda * p - lambda * (lambda * x + Ap * x + Bp * u);
end