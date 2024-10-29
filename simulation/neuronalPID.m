function theta = neuronalPID(entr)
e = entr(1);
e_int = entr(2);
e_dot = entr(3);
x =  entr(4);
Yg =  entr(5);
np =  entr(6);
ni =  entr(7);
nd =  entr(8);
kp_old
ki_old
kd_old 

x = 
kp = np*e*e*sigmoid_dot(x, Yg);
ki = ni*e*e_int*sigmoid_dot(x, Yg);
kd = nd*e*e_dot*sigmoid_dot(x, Yg);

theta = [kp,ki,kd]';

end

function f_dot = sigmoid_dot(x, Yg)
    f_dot = 4*exp(-x*Yg)/(1+exp(-x*Yg))^2;
end