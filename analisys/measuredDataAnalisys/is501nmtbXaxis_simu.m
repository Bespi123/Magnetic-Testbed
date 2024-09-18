%function [dx,y] = BrushelessModel(t,x,u,kt,J,B,Kc,L,R,Ke,d,ws,varargin)
function [dx] = is501nmtbXaxis_simu(x,u,Lxx,Rx)
%function dx = BrushelessModel(t,x,u,kt,J,B,Kc,L,R,Ke,varargin)

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

    L = Lxx;
    R = Rx;

    %%% State variables
    i  = x; 
    i_dot=L\(u-R*i);
    
    %x_dot vector
    dx = i_dot;
end