function theta_dot = adaptationLaw(entr)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
kp = entr(1);
gamma = entr(2);
error = entr(3);
omega = [entr(4),entr(5),entr(6),entr(7)];
theta_dot = -1*sign(kp)*gamma*error*omega;
end

