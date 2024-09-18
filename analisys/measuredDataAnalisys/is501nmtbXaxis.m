%function [dx,y] = BrushelessModel(t,x,u,kt,J,B,Kc,L,R,Ke,d,ws,varargin)
function [dx,y] = is501nmtbXaxis(t,x,u,Lxx,Rx,B_1,varargin)
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
    B = B_1;

    %%% State variables
    i  = x; 
    i_dot=L\(u-R*i);
    
    %x_dot vector
    dx=i_dot;
    
    %Output equation (Magnetic Field)
    y = [B * x, x];
end