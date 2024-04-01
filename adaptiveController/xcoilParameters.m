%%Plant tf
% kp  = 1.5458e+03;
  bp  = 0.0413;
  ap1 = 1.9163;
  ap2 = 0.0176;
x.Kp  = 3639.2 ;                 
x.Tp1 = 108.65 ;                
x.Tp2 = 0.52435;               
x.Tz  = 24.199 ;

%%Reference tf
% km  = 1.6211e-04;
% bm  = 1;
% am1 = 0.0232;
% am2 = 1.6211e-04;
ref.km  = 0.21261;
ref.bm  = 1;
ref.am1 = 0.8;
ref.am2 = 0.2126;

%%Parameters
Ts = 1; %s

%%Controller gains
%x.alpha1 = bp-ref.bm;
%x.beta1 = (ref.am1-ap1)/x.Kp;
%x.beta2 = (ref.am2-ap2)/x.Kp;
%x.k = ref.km/x.Kp;
%%adaptation Laws
x.gamma = 1E-3;