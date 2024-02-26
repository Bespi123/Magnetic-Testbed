function u = controller(entr)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
omega = [entr(1),entr(2),entr(3),entr(4)]';
theta = [entr(5),entr(6),entr(7),entr(8)]';
u = theta'*omega;
end

