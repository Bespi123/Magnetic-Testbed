function x_dot = is501nmtbModel_simu(input)
% IS501NMTBMODEL_SIMU Simulates the dynamic response of the IS501 NMTB test-bed.
% This function models the generated magnetic field of the system based on 
% its physical parameters, input voltages, and external disturbances.
% 
% INPUT:
%   input - A vector of size (21x1) containing the following parameters:
%       input(1:3)  - x: State variables (current components in x, y, z) (A)
%       input(4:6)  - u: Input voltages in x, y, z directions (V)
%       input(7:9)  - Td: Disturbance torques in x, y, z directions (nT)
%       input(10)   - Lxx:  constant (N*m/A)
%       input(11)   - Rx: Counter-electromotive force constant (V/(rad/s))
%       input(12)   - B_1: Biot-Savart law constant in x direction
%       input(13)   - Lyy: Rotor inertia (kg*m^2)
%       input(14)   - Ry: Starting torque (N*m)
%       input(15)   - B_2: Biot-Savart law constant in y direction
%       input(16)   - Lzz: Viscous friction constant (N*m*s)
%       input(17)   - Rz: Stribeck angular rate (rad/s)
%       input(18)   - B_3: Biot-Savart law constant in z direction
%       input(19)   - Lxy: Coulomb friction constant (N*m*s)
%       input(20)   - Lxz: Inductance (H)
%       input(21)   - Lzy: Resistance (Ohms)
% 
% OUTPUT:
%   x_dot - The rate of change of the state variables (currents) in nT.

%% Input Reading
% Extract inputs and parameters from the input vector
x = [input(1); input(2); input(3)];    % State variables (currents)
u = [input(4); input(5); input(6)];    % Input voltages
Td = [input(7); input(8); input(9)];   % Disturbances mag field
Lxx = input(10); Rx = input(11); B_1 = input(12);
Lyy = input(13); Ry = input(14); B_2 = input(15);
Lzz = input(16); Rz = input(17); B_3 = input(18);
Lxy = input(19); Lxz = input(20); Lzy = input(21);

%% Parameter Matrices
% Construct the system matrices based on the input parameters
L1 = [Lxx, (B_1 / B_2) * Lxy, (B_1 / B_3) * Lxz;...
      (B_2 / B_1) * Lxy, Lyy, (B_2 / B_3) * Lzy;...
      (B_3 / B_1) * Lxz, (B_3 / B_2) * Lzy, Lzz];  % Effective inductance matrix

L = [Lxx, Lxy, Lxz;...
     Lxy, Lyy, Lzy;...
     Lxz, Lzy, Lzz];                             % Inductance matrix

R = diag([Rx, Ry, Rz]);                          % Resistance matrix
B = diag([B_1, B_2, B_3]);                       % Biot-Savart matrix

%% System Dynamics
% Define the state-space matrices
Ap = -inv(L1) * R;                               % State matrix (dynamics)
Bp = B * inv(L) * 1E9;                           % Input matrix (scaled to nT)

%% State Update
% Calculate the rate of change of the state variables
% x_dot is expressed in (nT) (nanoteslas)
x_dot = Ap * (x - Td) + Bp * u;

end