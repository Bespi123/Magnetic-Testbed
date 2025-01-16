%% Linear Analysis
% This section analyze the dynamic behavior of the IS501NMTB magnetic
% test-bed. It defines the state-space representation of the system, derives 
% transfer functions, computes PID controllers, and evaluates stability 
% through pole analysis and step response plots. The analisys is performed
% taking into acount that the magnetic field is in (nT) due to the MAG649L
% measures in this dimentions

%%% Get simulation parameters
sim_parameters

%% Define mathematical model
%%%Compute matrices
L1 =[initial_1.Lx, (initial_1.B_x/initial_1.B_y)*initial_1.Lxy, (initial_1.B_x/initial_1.B_z)*initial_1.Lxz;
     (initial_1.B_y/initial_1.B_x)*initial_1.Lxy,initial_1.Ly, (initial_1.B_y/initial_1.B_z)*initial_1.Lzy;
     (initial_1.B_z/initial_1.B_x)*initial_1.Lxz,(initial_1.B_z/initial_1.B_y)*initial_1.Lzy,initial_1.Lz];
%%%Mutual inductances matrix
L = [initial_1.Lx,initial_1.Lxy,initial_1.Lxz;
     initial_1.Lxy,initial_1.Ly,initial_1.Lzy;
     initial_1.Lxz,initial_1.Lzy,initial_1.Lz];
%%%Resistance matrix
R = diag([initial_1.Rx,initial_1.Ry,initial_1.Rz]);
%%%B matrix
B = diag([initial_1.B_x,initial_1.B_y,initial_1.B_z]);

%%% Mathematical model in SS state
Ap = -inv(L1)*R ;
Bp = B/L; 
Cp = eye(3);
Dp = 0;

%%% Turn into transfer function
% Define system in state-space (SS)
sys_MIMO_1 = ss(Ap,Bp,Cp,Dp);
% Convert the system to transfer function with output in (T)
G_mimo_1 = tf(sys_MIMO_1);
% Transfer function with output in (nT)
G_mimo_2 = series(G_mimo_1,1E9);

% Find open-loop poles
p = pole(G_mimo_2);

%%%Plot open-loop step response
% Plot step response of SISO closed-loop system
figure;
step(G_mimo_2);
title('Open-Loop Response (nT)');
xlabel('Time (s)'); ylabel('Amplitude (nT)'); grid on;

% Display poles
disp('Poles of the MIMO loop:');
disp(p);

% Check stability
if all(real(p) < 0)
    disp('The SISO loop is stable.');
else
    disp('The SISO loop is unstable.');
end

%% Define PID control algorithm
%%% PID values
KP = [x.PID.Kp, y.PID.Kp, z.PID.Kp];
KI = [x.PID.Ki, y.PID.Ki, z.PID.Ki];
KD = [x.PID.Kd, y.PID.Kd, z.PID.Kd];

% Create PID controllers for output in (nT)
C_pid_x_nT = pid(KP(1), KI(1), KD(1));
C_pid_y_nT = pid(KP(2), KI(2), KD(2));
C_pid_z_nT = pid(KP(3), KI(3), KD(3));

% PID
% Closed-loop system with unity feedback (nT)
T1_nT = feedback(C_pid_x_nT * G_mimo_2(1,1), 1);
T2_nT = feedback(C_pid_y_nT * G_mimo_2(2,2), 1);
T3_nT = feedback(C_pid_z_nT * G_mimo_2(3,3), 1);

%%% Evaluate closed-loop responses with PID
% Define evaluation function
evaluateSystem = @(sys, label) struct(...
    'SettlingTime', stepinfo(sys).SettlingTime, ...
    'RiseTime', stepinfo(sys).RiseTime, ...
    'Overshoot', stepinfo(sys).Overshoot, ...
    'SteadyStateError', abs(1 - dcgain(sys)) * 100, ...
    'Label', label);

% Evaluate each axis
eval_T1 = evaluateSystem(T1_nT, 'X Axis');
eval_T2 = evaluateSystem(T2_nT, 'Y Axis');
eval_T3 = evaluateSystem(T3_nT, 'Z Axis');

% Display evaluations
disp('Closed-Loop Evaluation with PID (nT):');
disp(eval_T1);
disp(eval_T2);
disp(eval_T3);

%%% Plot closed-loop responses with performance annotations
figure;
subplot(1, 3, 1);
step(T1_nT);
title(sprintf('Closed-Loop Response - %s\nSettling Time: %.4fs, Overshoot: %.2f%%', ...
    eval_T1.Label, eval_T1.SettlingTime, eval_T1.Overshoot));
xlabel('Time (s)'); ylabel('Amplitude (nT)'); grid on;

subplot(1, 3, 2);
step(T2_nT);
title(sprintf('Closed-Loop Response - %s\nSettling Time: %.4fs, Overshoot: %.2f%%', ...
    eval_T2.Label, eval_T2.SettlingTime, eval_T2.Overshoot));
xlabel('Time (s)'); ylabel('Amplitude (nT)'); grid on;

subplot(1, 3, 3);
step(T3_nT);
title(sprintf('Closed-Loop Response - %s\nSettling Time: %.4fs, Overshoot: %.2f%%', ...
    eval_T3.Label, eval_T3.SettlingTime, eval_T3.Overshoot));
xlabel('Time (s)'); ylabel('Amplitude (nT)'); grid on;

%%% Stability check
if all([eval_T1.SettlingTime, eval_T2.SettlingTime, eval_T3.SettlingTime] < Inf)
    disp('The closed-loop system is stable for all axes.');
else
    disp('The closed-loop system is unstable for one or more axes.');
end