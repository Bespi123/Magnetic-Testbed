%%%x-coil
x.Kp    = 3639.2 ;                 
x.Tp1   = 108.65 ;                
x.Tp2   = 0.52435;               
x.Tz    = 24.199 ;
%%%PID parameters
x.PID.Kp = 7.034383411703327e-04;
%x.PID.Kp = 1.458563076444158e-04;
x.PID.Ki = 0.001083608847320;
%x.PID.Ki = 1.061570442188780e-05;
x.PID.Kd = 3.096305095968147e-05;
%x.PID.Kd = 0;

%%%y-coil
y.Kp  = 6900.7;                 
y.Tp1 = 4.5513;                 
y.Tp2 = 4.3827;                 
y.Tz  = 2.7486;
%%%PID parameters
y.PID.Kp = 0.001047044877412;
y.PID.Ki = 8.904034390454403e-05;
y.PID.Kd = 0;
% y.PID.Kp = 0;
% y.PID.Ki = 2.784156518528394e-06;
% y.PID.Kd = 0;

%%%z-coil
z.Kp  = 3137.9 ;                
z.Tp1 = 46.134 ;                
z.Tp2 = 0.35501;                
z.Tz  = 166.08 ;
%%%PID parameters
% z.PID.Kp = 1.537799835205078e-05;
% z.PID.Ki = 5.664950833305315e-05;
% z.PID.Kd = 4.768371582031250e-07;
% z.PID.Kp = 6.682365123566340;
% z.PID.Ki = -0.023846868893873;
% z.PID.Kd = -0.015251337799268;
 z.PID.Kp =0;
 z.PID.Ki = 8.067154903969480e-06;
 z.PID.Kd = 0;
