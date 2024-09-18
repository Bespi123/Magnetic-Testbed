function out = is501nmtbModel_simu(input)
    %Define inputs
    %u:      V (Vmean)
    %Lxx:    Torque constant (N*m/A)
    %Lyy:     Rotor inertia (kg*m^2)
    %Lzz:     Constante de friccion viscosa (N*m*s)
    %Lxy:    Constante de friccion de Coulomb (N*m*s)
    %Lxz:     Inductancia (H)
    %Lzy:     Resistencia (R)
    %Rx:    Constante contraelectromotriz (V/(Rad/s))
    %Ry:     Starting Torque (N*m)   
    %Rz:    Stribeck angular rate (rad/s)
    %B_1:   Biot-Savart law in x
    %B_2:   Biot-Savart law in y 
    %B_3:   Biot-Savart law in z
    
    %%%Input reading
    x = [input(1);input(2);input(3)];
    u = [input(4);input(5);input(6)]; 
    Lxx = input(7);
    Rx  = input(8);
    B_1 = input(9);
    Lyy = input(10);
    Ry  = input(11);
    B_2 = input(12);
    Lzz = input(13);
    Rz  = input(14);
    B_3 = input(15);
    Lxy = input(16);
    Lxz = input(17);
    Lzy = input(18);
    %%%Parameter reading
    L = [Lxx,Lxy,Lxz;
         Lxy,Lyy,Lzy;
         Lxz,Lzy,Lzz];
    R = diag([Rx,Ry,Rz]);
    B = diag([B_1,B_2,B_3]);
    
    %%% Normalize inputs
    u = [u(1);u(2);u(3)];
    
    %%% State variables
    i  = x; 
    i_dot=L\(u-R*i);
    
    %x_dot vector
    dx=i_dot;
    
    %Output equation (Magnetic Field)
    y = B * x;

    %%%Out
    out = [dx;y];
end