function [out] = centralizedAdaptiveLaw(entr)

gamma = diag([entr(1),entr(2),entr(3)]);
x = [entr(4),entr(5),entr(6)]';
e = [entr(7),entr(8),entr(9)]';
P = [entr(10),entr(11),entr(12);
     entr(13),entr(14),entr(15);
     entr(16),entr(17),entr(18)];
B = [entr(19),entr(20),entr(21);
     entr(22),entr(23),entr(24);
     entr(25),entr(26),entr(27)];

Kx_dot_t = gamma*x*e'*P*B;
Kx_dot = Kx_dot_t';
out = Kx_dot(:); 
end