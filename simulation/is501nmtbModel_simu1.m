function out = is501nmtbModel_simu1(input)
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
    x   = [input(1);input(2);input(3)];
    u   = [input(4);input(5);input(6)]; 
    Td  = [input(7);input(8);input(9)];
    Lxx = input(10);
    Rx  = input(11);
    B_1 = input(12);
    Lyy = input(13);
    Ry  = input(14);
    B_2 = input(15);
    Lzz = input(16);
    Rz  = input(17);
    B_3 = input(18);
    Lxy = input(19);
    Lxz = input(20);
    Lzy = input(21);

    %%%Parameter reading
    %L1 =[Lxx, (B_1/B_2)*Lxy, (B_1/B_3)*Lxz;
    %     (B_2/B_1)*Lxy, Lyy, (B_2/B_3)*Lzy;
    %     (B_3/B_1)*Lxz, (B_3/B_2)*Lzy, Lzz];
    L = [Lxx,Lxy,Lxz;
         Lxy,Lyy,Lzy;
         Lxz,Lzy,Lzz];
    R = diag([Rx,Ry,Rz]);
    B = diag([B_1,B_2,B_3]);
    
    %%% Normalize inputs
    u = [u(1);u(2);u(3)];
    
    % %%% State variables
     i  = x; 
     i_dot=L\(u-R*i);
     
     %x_dot vector
     dx=i_dot;
     
     %Output equation (Magnetic Field)
     y = B * x + Td;

    % %%%Out
     out = [dx;y];
end