%%Reference tf
% km  = 1.6211e-04;
% bm  = 1;
% am1 = 0.0232;
% am2 = 1.6211e-04;
ref.km  = 0.21261;
ref.bm  = 1;
ref.am1 = 0.8;
ref.am2 = 0.2126;

%%Plant tf
x.Kp  = 3639.2 ;                 
x.Tp1 = 108.65 ;                
x.Tp2 = 0.52435;               
x.Tz  = 24.199 ;
%%%y-coil
y.Kp  = 6900.7;                 
y.Tp1 = 4.5513;                 
y.Tp2 = 4.3827;                 
y.Tz  = 2.7486;
%%%z-coil
z.Kp  = 3137.9 ;                
z.Tp1 = 46.134 ;                
z.Tp2 = 0.35501;                
z.Tz  = 166.08 ;

%%Parameters
Ts = 1; %s

%%adaptation Laws
x.gamma = 1E-3;     %1E-3
x.h = 1;
y.gamma = 1E-3;     %1E-3
y.h = 1;
z.gamma = 10;     %1E-3
z.h = 1;

%%Initial values x-coil
x.init.k      = 7.219490754370038e-04;  %2.055032348632813e-04;
x.init.theta1 = 0;                      %-4.88281250000000e-04;
x.init.theta2 = 6.461143493652344e-05;  %3.309249877929688e-04;
x.init.theta0 = -7.824430036089732e-04; %9.765625000000000e-04;
x.init.omega1 = 0.009204973281076;      %0.009123169101952;
x.init.omega2 = 0;                      %9.326541512872863e-04;

%%Initial values y-coil
y.init.k      =  6.9007e-3;%ref.km/z.Kp;
y.init.theta1 =  0.009968654332761;
y.init.theta2 =  0.001591547288395;
y.init.theta0 = -0.001649363917734;
y.init.omega1 = -0.004063952623625;
y.init.omega2 =  0.001216831427107;

%%Initial values z-coil
z.init.k      =  6.7753e-05;
z.init.theta1 =  0.000;
z.init.theta2 =  0.000;
z.init.theta0 =  0.000;
z.init.omega1 =  0.000;
z.init.omega2 =  0.000;