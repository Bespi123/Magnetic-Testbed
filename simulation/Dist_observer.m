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
L1 =[Lxx, (B_1/B_2)*Lxy, (B_1/B_3)*Lxz;
     (B_2/B_1)*Lxy, Lyy, (B_2/B_3)*Lzy;
     (B_3/B_1)*Lxz, (B_3/B_2)*Lzy, Lzz];

L = [Lxx, Lxy, Lxz;
     Lxy, Lyy, Lzy;
     Lxz, Lzy, Lzz];
%L = diag([initial_1.Lx,initial_1.Ly,initial_1.Lz]);
R = diag([Rx,Ry,Rz]);
B = diag([B_1,B_2,B_3]);
%%% Model matrix
Ap = -inv(L1)*R ;
Bp = B*inv(L)*1E9; 
Cp = eye(3);
Dp = 0;

%%%Define x as measured magnetic Field instead of current
%X      = B_x*x; 

%%% f(x) = L^-1Rx;
%%% g(x) = L^-1Bx;
%X_dot = Ap*x+Bp*u;
p_dot = -lambda*p-lambda*(lambda*x+Ap*x+Bp*u);
%d_est = p+lambda*X_dot;
end