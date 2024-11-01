%function [dx,y] = is501nmtbModel(t,x,u,Lxx,Lyy,Lzz,Lxy,Lxz,Lzy,Rx,Ry,Rz,B_1,B_2,B_3,varargin)
function [dx,y] = is501nmtbModel(t,x,u,Lxx,Rx,B_1,Lyy,Ry,B_2,Lzz,Rz,B_3,Lxy,Lxz,Lzy,varargin)

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
    y = [B * x; x];
end