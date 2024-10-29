function a_est = estimator(input)
%%%
    e     = diag([input(1),input(2),input(3)]);
    r     = [input(4),input(5),input(6)]';
    y     = [input(7),input(8),input(9)]';
    gamma = diag([input(10),input(11),input(12)]);
    
    Lxx = input(13); 
    Lyy = input(14);
    Lzz = input(15);
    % Lxy = input(16);
    % Lxz = input(17);
    % Lzy = input(18);
    Lxy = 0;
    Lxz = 0;
    Lzy = 0;
    
    B_1 = input(19);
    B_2 = input(20);
    B_3 = input(21);
    
    %%%
    L = [Lxx,Lxy,Lxz;
         Lxy,Lyy,Lzy;
         Lxz,Lzy,Lzz];
    B = diag([B_1,B_2,B_3]);
    bp = B*inv(L);
    
    a_r_est = -sign(bp)*gamma*e*r;
    a_y_est = -sign(bp)*gamma*e*y;
    
    a_est = [a_r_est;a_y_est];
end