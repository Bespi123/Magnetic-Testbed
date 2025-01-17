function out = is501nmtbModel_simu1(input)
% IS501NMTB Model Simulation
% Simulates the behavior of a system using state-space equations.
% Computes the time derivatives of state variables and system output.

    %%% Input Parameters
    % Inputs are extracted from the input vector:
    % x: State vector (currents in the system)
    x = [input(1); input(2); input(3)];
    
    % u: Input voltage vector (mean voltage applied)
    u = [input(4); input(5); input(6)];
    
    % Td: Disturbance torque vector
    Td = [input(7); input(8); input(9)];
    
    % System parameters
    Lxx = input(10); % Autoinductance in x-coil
    Rx  = input(11); % Resistance in x-coil
    B_1 = input(12); % Biot-Savart constant in x-coil
    Lyy = input(13); % Autoinductance in y-coil
    Ry  = input(14); % Resistance in y-coil
    B_2 = input(15); % Biot-Savart constant in y-coil
    Lzz = input(16); % Autoinductance in z-coil
    Rz  = input(17); % Resistance in z-coil
    B_3 = input(18); % Biot-Savart constant in z-coil
    Lxy = input(19); % Mutual inductance between x and y
    Lxz = input(20); % Mutual inductance between x and z
    Lzy = input(21); % Mutual inductance between z and y

    %%% Parameter Matrices
    % L: System inductance matrix (includes coupling effects)
    L = [Lxx, Lxy, Lxz;
         Lxy, Lyy, Lzy;
         Lxz, Lzy, Lzz];

    % R: Resistance matrix (diagonal)
    R = diag([Rx, Ry, Rz]);
    
    % B: Biot-Savart law constants (diagonal matrix for magnetic field calculation)
    B = diag([B_1, B_2, B_3]);

    %%% Normalize Inputs
    % Ensure the input vector u is used directly without modifications
    u = [u(1); u(2); u(3)];

    %%% State Equations
    % i: Current state variable (same as x)
    i = x;

    % i_dot: Derivative of current (state-space equation)
    % L\(u - R*i) solves for i_dot in the state-space equation: L * i_dot = u - R * i
    i_dot = L \ (u - R * i);

    % dx: Time derivative of state variables (i_dot)
    dx = i_dot;

    %%% Output Equation
    % y: Magnetic field output (depends on current state and disturbance torque)
    y = B * x + Td;

    %%% Output
    % Combine the time derivatives (dx) and output (y) into a single output vector
    out = [dx; y];
end
