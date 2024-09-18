function p_dot= Dist_observer(input)
%%%Input parameters
x   = [input(1);input(2);input(3)];
u   = [input(4);input(5);input(6)]; 
Lxx =  input(7);
Rx  =  input(8);
B_1 =  input(9);
Lyy =  input(10);
Ry  =  input(11);
B_2 =  input(12);
Lzz =  input(13);
Rz  =  input(14);
B_3 =  input(15);
Lxy =  input(16);
Lxz =  input(17);
Lzy =  input(18);
lambda = diag([input(19),input(20),input(21)]);
p      = [input(22);input(23);input(24)];
%%%Parameter reading
L = [Lxx,Lxy,Lxz;
     Lxy,Lyy,Lzy;
     Lxz,Lzy,Lzz];
R = diag([Rx,Ry,Rz]);
B_x = diag([B_1,B_2,B_3]);

%%%Define x as measured magnetic Field instead of current
X      = B_x*x; 

%%% f(x) = L^-1Rx;
%%% g(x) = L^-1Bx;
p_dot = -lambda*p-lambda*(lambda*X+L\R*X+L\B_x*u);
end