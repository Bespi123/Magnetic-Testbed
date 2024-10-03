%%%Constants
mu_0 = 4*pi*1e-7;    %%%Permeability in the vacum

%%%Nominal values
%%%%%X-axis
IS501NMTB.X.L   = 1.03;
IS501NMTB.X.R   = 14.84;
IS501NMTB.X.a   = IS501NMTB.X.L/2 ;
IS501NMTB.X.h   = 0.5;
IS501NMTB.X.N   = 36;
IS501NMTB.X.Lx  = 2*IS501NMTB.X.N^2*(2^(1/2)*mu_0*IS501NMTB.X.L^2)/(IS501NMTB.X.a*pi);
IS501NMTB.X.tau = IS501NMTB.X.Lx/IS501NMTB.X.R;
%%%%%Y-axis
IS501NMTB.Y.L   = 1.02;
IS501NMTB.Y.a   = IS501NMTB.Y.L/2;
IS501NMTB.Y.h   = 0.5;
IS501NMTB.Y.N   = 35;
IS501NMTB.Y.R   = 7.61;
IS501NMTB.Y.Ly  = 2*IS501NMTB.Y.N^2*(2^(1/2)*mu_0*IS501NMTB.Y.L^2)/(IS501NMTB.Y.a*pi);
IS501NMTB.Y.tau = IS501NMTB.Y.Ly/IS501NMTB.Y.R;
%%%%%Z-axis
IS501NMTB.Z.L   = 1.03;
IS501NMTB.Z.a   = IS501NMTB.Z.L/2;
IS501NMTB.Z.h   = 0.5 ;
IS501NMTB.Z.N   = 20;
IS501NMTB.Z.R   = 10.32;
IS501NMTB.Z.Lz  = 2*IS501NMTB.Z.N^2*(2^(1/2)*mu_0*IS501NMTB.Z.L^2)/(IS501NMTB.Z.a*pi);
IS501NMTB.Z.tau = IS501NMTB.Z.Lz/IS501NMTB.Z.R;

%%%Biot Savart law
coeff_teor = @(N,a,h) (4 * mu_0 * N * a^2) / (pi) * (1/((a^2 + (h/2)^2) * (2 * a^2 + (h/2)^2)^(1/2)));

%%%Simulation Parameters
initial_1.Lx  = IS501NMTB.X.Lx;       %%0.00208911
initial_1.Rx  = IS501NMTB.X.R;        %%14.913
initial_1.B_x = coeff_teor(IS501NMTB.X.N,IS501NMTB.X.a,IS501NMTB.X.h); %%5.38582e-05
%%%Simulation Parameters
initial_1.Ly  = IS501NMTB.Y.Ly;       %%0.00208911
initial_1.Ry  = IS501NMTB.Y.R;        %%14.913
initial_1.B_y = coeff_teor(IS501NMTB.Y.N,IS501NMTB.Y.a,IS501NMTB.Y.h); %%5.38582e-05
%%%Simulation Parameters
initial_1.Lz  = IS501NMTB.Z.Lz;       %%0.00208911
initial_1.Rz  = IS501NMTB.Z.R;        %%14.913
initial_1.B_z = coeff_teor(IS501NMTB.Z.N,IS501NMTB.Z.a,IS501NMTB.Z.h); %%5.38582e-05
%%%Mutual inductances
initial_1.Lxy = 0;%1E-5
initial_1.Lxz = 0;
initial_1.Lzy = 0;
% initial_1.Lxy = rand(1)*1E-5;%1E-5
% initial_1.Lxz = rand(1)*1E-5;
% initial_1.Lzy = rand(1)*1E-5;


%%Controller Parameters
% % %%%PID parameters
% % x.PID.Kp = 1380648.9719;
% % x.PID.Ki = 6783283495.8308;
% % x.PID.Kd = 0;
%%%PID parameters (nT)
x.PID.Kp = 0.00042024;
x.PID.Ki = 2.2979;
x.PID.Kd = 0;

%%%y-coil
% % %%%PID parameters
% % y.PID.Kp = 548580.3214;
% % y.PID.Ki = 1697252969.9689;
% % y.PID.Kd = 0;
%%%PID parameters (nT)
y.PID.Kp = 0.00078586;
y.PID.Ki = 2.325;
y.PID.Kd = 0;

%%%z-coil
% % z.PID.Kp = 641963.3974;
% % z.PID.Ki = 7238744360.0891;
% % z.PID.Kd = 0;
%%%PID parameters (nT)
z.PID.Kp = 0.00059495;
z.PID.Ki = 7.108;
z.PID.Kd = 0;

%%%observer
observer.l1 = 1000;
observer.l2 = 1000;
observer.l3 = 1000;

%%gain Estimator
%estimator.gamma1=5E-12;
%estimator.gamma2=5E-12;
%estimator.gamma3=5E-12;
 % estimator.gamma1=5E0;
 % estimator.gamma2=5E0;
 % estimator.gamma3=5E0;
%estimator.gamma1=1E1;
%estimator.gamma2=1E1;
%estimator.gamma3=1E1;
estimator.gamma1=5E2;
estimator.gamma2=5E2;
estimator.gamma3=5E2;

% %%%gain Estimator
estimator1.gamma1=1E-3;
estimator1.gamma2=1E-3;
estimator1.gamma3=1E-3;
 
% estimator1.gamma1=eps;
 % estimator1.gamma2=eps;
 % estimator1.gamma3=eps;

%%%saturation values
saturation.x = 15;
saturation.y = 7;
saturation.z = 12;

%%%Orbit Parameters
earth.Radius      = 6786000;
orbit.altitude    = 500E3;   
orbit.semiMajorAxis = orbit.altitude+earth.Radius;
orbit.eccentricity = 0;
orbit.inclination = 97.34; 
orbit.rightAscensionOfAscendingNode = 313.131; 
orbit.argumentOfPeriapsis = 0; 
orbit.trueAnomaly = 0;
%orbit.period      = 2*pi/sqrt(earth.mu)*orbit.semiMajorAxis^(3/2); % Orbital period
%orbit.vcircular   = sqrt(earth.mu/orbit.semiMajorAxis);            % Circular velocity

% Definir parámetros del controlador
% sliding.phi = 0.001;         % Grosor de la capa límite para reducir chattering
% sliding.Ks = [5,5,5]*1E10;    % Ganancia de deslizamiento (ajustar según necesidad)
% sliding.omega = [1,1,1]*5E-1;
% 
% 
% sliding.n = [1,1,1]*1E2;
% % sliding.phi = 0.5010;         % Grosor de la capa límite para reducir chattering
% % sliding.Ks = [19.1433,16.2556,5.0000];    % Ganancia de deslizamiento (ajustar según necesidad)
% % sliding.omega = [0.1000,0.1000,14.1209];

sliding.phi = 1E-3;       % Grosor de la capa límite para reducir chattering
sliding.Ks    = [5,5,5]*1E2;    % Ganancia de deslizamiento (ajustar según necesidad)
sliding.omega = [1,1,1]*1E-4;

%sliding.n = [0.1,0.1,0.1]*1E-25;
sliding.n = [0.1,0.1,0.1]*1E-12;


%%%Adaptation Law gains
x.lambda = 5E-15;
x.n = 1E-15;
x.alpha = 3E-15;
x.beta = 5E-15;
x.epsilon = 1E-15;

% % %%%Initial Conditions
% % x.kd_init  = 0;
% % x.ki_init = 6783283495.8308;
% % x.kp_init = 1380648.9719;
%%%Initial Conditions (nT)
x.kd_init = 0.00;
x.ki_init = 0.00;
x.kp_init = 0.00;

%%%Adaptation Law gains
y.lambda = 5E-15;
y.n = 1E-15;
y.alpha = 3E-15;
y.beta = 5E-15;
y.epsilon = 1E-15;

%%%Initial Conditions
% % y.kd_init = 0;
% % y.ki_init = 1697252969.9689;
% % y.kp_init = 548580.3214;
%%%Initial Conditions (nT)
y.kd_init = 0.00;
y.ki_init = 0.00;
y.kp_init = 0.00;

%%%Adaptation Law gains
z.lambda = 5E-15;
z.n = 1E-15;
z.alpha = 3E-15;
z.beta = 5E-15;
z.epsilon = 1E-15;

%%%Initial Conditions
% % z.kd_init = 0;
% % z.ki_init = 7238744360.0891;
% % z.kp_init = 641963.3974;
%%%Initial Conditions (nT)
z.kd_init = 0;
z.ki_init = 0.00;
z.kp_init = 0.00;



%%%%PID adaptive v2
x.pid_v2.Yg = 0.1;
x.pid_v2.np = 1;
x.pid_v2.ni = 1;
x.pid_v2.nd = 1;

y.pid_v2.Yg = 0.1;
y.pid_v2.np = 1;
y.pid_v2.ni = 1;
y.pid_v2.nd = 1;

z.pid_v2.Yg = 0.1;
z.pid_v2.np = 1;
z.pid_v2.ni = 1;
z.pid_v2.nd = 1;


%%%Modelo de referencia
Am = [-1, 0, 0; 0, -1, 0; 0, 0, -1];
Bm = eye(3);  % Para cada entrada
Cm = eye(3);
Dm = 0;
%%%Check if the transfer func fills our needs
sys_ss = ss(Am, Bm, Cm, Dm);
sys_tf = tf(sys_ss);

%Q = 1*eye(3)*1E-10;
Q = 1*eye(3)*1E-1;
%-5
%Q = 1*eye(3)*1E-9;
%%%Solve the lyapunov equation
P = lyap(eye(3),Q,[],Am');
P = P';

centralized.gamma_x = [1,1,1]*1E1;
centralized.gamma_r = [1,1,1]*1E1;
centralized.gamma_b = [1,1,1]*1E3;
centralized.P = P(:);
