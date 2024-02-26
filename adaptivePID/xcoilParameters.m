%%Plant tf
kp  = 1.5458e+03;
bp  = 0.0413;
ap1 = 1.9163;
ap2 = 0.0176;
% %%Reference tf
% km  = 1.6211e-04;
% bm  = 1;
% am1 = 0.0232;
% am2 = 1.6211e-04;
% %%Parameters
Ts = 1; %s
% %%Controller gains
% alpha1 = bp-bm;
% beta1 = (am1-ap1)/kp;
% beta2 = (am2-ap2)/kp;
% k = km/kp;
% %%adaptation Laws
lambda = 0.0001;
n = 0.001;
alpha = 0.1;
beta = 0.001;
epsilon = 1E-6;
% gamma = 1E-10;
%%plant = tf([kp kp*bp],[1  ap1 ap2]);
%%plant_discrete = c2d(plant,Ts);

