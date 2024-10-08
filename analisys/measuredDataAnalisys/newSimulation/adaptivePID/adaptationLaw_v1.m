function theta_dot = adaptationLaw_v1(entr)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
n      = entr(1);
omega  = entr(2);
k      = entr(3);
phi    = entr(4); 

s      = entr(5);
s_int  = entr(6);
s_dot  = entr(7);

myPi  = [entr(8);entr(9);entr(10)];
Td    = entr(11);

%theta_dot = n*myPi*(s_dot+omega*s_int+k*sati111(s,phi)+Td);
theta_dot = n*myPi*(s_dot+omega*s_int+k*sat11(s,phi)+Td);
end

% Función de saturación para la capa límite
function sat_s = sat11(s, phi)
    %sat_s = min(max(s / phi, -1), 1);
    sat_s = [sati111(s(1), phi);...
             sati111(s(2), phi);...
             sati111(s(3), phi)];
end

function sat_s_i = sati111(s, phi)
    if abs(s)>=phi
        sat_s_i = sign(s / phi);
    else
        sat_s_i = s / phi;
    end
end