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
%initial_1.Lxy = 0;%1E-5
%initial_1.Lxz = 0;
%initial_1.Lzy = 0;
initial_1.Lxy = rand(1)*1E-4;%1E-5
initial_1.Lxz = rand(1)*1E-4;
initial_1.Lzy = rand(1)*1E-4;

%%Controller Parameters
%%%PID parameters
x.PID.Kp = 7.034383411703327e-04;
x.PID.Ki = 0.001083608847320;
x.PID.Kd = 3.096305095968147e-05;

%%%y-coil
%%%PID parameters
y.PID.Kp = 0.001047044877412;
y.PID.Ki = 8.904034390454403e-05;
y.PID.Kd = 0;

%%%z-coil
 % z.PID.Kp =0;
 % z.PID.Ki = 8.067154903969480e-06;
 % z.PID.Kd = 0;
z.PID.Kp = 0;
z.PID.Ki = 0.00008067154904;
z.PID.Kd = 0;
%%%observer
observer.l1 = 1-3;
observer.l2 = 0.1;
observer.l3 = 0.1;

%%%gain Estimator
% estimator.gamma1=1; 1E-2
% estimator.gamma2=1;
% estimator.gamma3=1;
estimator.gamma1=5E-2;
estimator.gamma2=1E-2;
estimator.gamma3=1E-2;
% %%%gain Estimator
estimator1.gamma1=7.5E-4;
estimator1.gamma2=7.5E-4;
estimator1.gamma3=7.5E-4;
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