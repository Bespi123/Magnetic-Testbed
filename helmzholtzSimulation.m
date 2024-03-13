%% Simulation parameters
%%%Parameters for the Z coil
IS501NMTB.Z.L = 1.03;
IS501NMTB.Z.a = IS501NMTB.Z.L/2 ;
IS501NMTB.Z.h = 0.5 ;
IS501NMTB.Z.N = 59.12; 
%%%Parameters for the Y coil
IS501NMTB.Y.L = 1.02;
IS501NMTB.Y.a = IS501NMTB.Y.L/2 ;
IS501NMTB.Y.h = 0.5 ;
IS501NMTB.Y.N = 111.2; 
%%%Parameters for the X coil
IS501NMTB.X.L = 1.03;
IS501NMTB.X.a = IS501NMTB.X.L/2 ;
IS501NMTB.X.h = 0.5;
IS501NMTB.X.N = 97.18;

%% Simulation Configurations for Z coil
%%% Coils current for z coil
Iz = 1;
%%% Generate X, Y, plane
Rangez = -2*IS501NMTB.Z.a:0.05:2*IS501NMTB.Z.a;
if ~any(Rangez == 0)
    Rangez = [Rangez, 0];
    Rangez = sort(Rangez);
end
%%% Matrix rotation from X to Z axis
Az = [0   0   -1; 0   1   0; 1   0   0];
zcoil = coilSimulation1d(Rangez, Az, IS501NMTB.Z, Iz);

%% Simulation Configurations for Y coil
%%% Coils current
Iy = 1;
%%% Generate X, Y, plane
Rangey = -2*IS501NMTB.Y.a:0.05:2*IS501NMTB.Y.a;
if ~any(Rangey == 0)
    Rangey = [Rangey, 0];
    Rangey = sort(Rangey);
end
%%% Matrix rotation from X to Z axis
Ay = [0   -1   0; 1    0   0; 0    0   1];
ycoil = coilSimulation1d(Rangey, Ay, IS501NMTB.Y, Iy);

%% Simulation Configurations for X coil
%%% Coils current
Ix = 1;
%%% Generate X, Y, plane
Rangex = -2*IS501NMTB.X.a:0.05:2*IS501NMTB.X.a;
if ~any(Rangex == 0)
    Rangex = [Rangex, 0];
    Rangex = sort(Rangex);
end
%%% Matrix rotation from X to X axis
Ax = eye(3);
xcoil = coilSimulation1d(Rangex, Ax, IS501NMTB.X, Ix);

%% Program functions
function [B,B1,B2] = magneticFielsSquareCoil(P, N, I, spire1, spire2) 
    %%% Parameters
    mu_0 = 4*pi*1e-7;                 %Magnetic Permeability of Vacuum
    %%% Initial values
    B1 = [0, 0, 0]'; B2 = [0, 0, 0]'; %Magnetic field generated for the coil1 and coil2

    %%% Calculate magnetic field generated by Coil1 and Coil2 
    fieldsName = fields(spire1);       
    for i = 1:numel(fieldsName)
        dl_1= diff(spire1.([fieldsName{i,1}])')';   %infinitesimal of coil1
        dl_2= diff(spire2.([fieldsName{i,1}])')';   %infinitesimal of coil2

        for j = 1:length(spire1.([fieldsName{i,1}]))-1
            %% Calculate vector R1 for coil 1 and R2 for coil 2
            R1 = P-spire1.([fieldsName{i,1}])(:,j);
            R2 = P-spire2.([fieldsName{i,1}])(:,j);

            %% Calculate biot Savart Law
            dB1 = (N*mu_0 * I / (4 * pi)) * cross(dl_1(:,j), R1) / norm(R1)^3;
            dB2 = (N*mu_0 * I / (4 * pi)) * cross(dl_2(:,j), R2) / norm(R2)^3;
            B1 = B1 + dB1;
            B2 = B2 + dB2;
        end     
    end
    B = B1+B2;
end

function [spire1,spire2] = squareSpires(A, h, L, numSeg)
    %%% Define limit for Spire 1 considering that the spire is in y-z plane
    spire1.side1 = [h/2*ones(1,numSeg); linspace(L/2,-L/2,numSeg); L/2*ones(1,numSeg)       ];  %minusYspire1 
    spire1.side2 = [h/2*ones(1,numSeg); -L/2*ones(1,numSeg)      ; linspace(L/2,-L/2,numSeg)];  %minusZspire1
    spire1.side3 = [h/2*ones(1,numSeg); linspace(-L/2,L/2,numSeg); -L/2*ones(1,numSeg)      ];  %plusYspire1
    spire1.side4 = [h/2*ones(1,numSeg); L/2*ones(1,numSeg)       ; linspace(-L/2,L/2,numSeg)];  %plusZspire1
    
    %%% Define limit for Spire 2 considering that the spire is in y-z plane
    spire2.side1 = spire1.side1 - [h,0,0]'; %minusYspire2 
    spire2.side2 = spire1.side2 - [h,0,0]'; %minusZspire2
    spire2.side3 = spire1.side3 - [h,0,0]'; %plusYspire2
    spire2.side4 = spire1.side4 - [h,0,0]'; %plusZspire2
    
    %%%Rotate helmholtz coils (spire1)
    spire1.side1 = A*spire1.side1; spire1.side2 = A*spire1.side2;
    spire1.side3 = A*spire1.side3; spire1.side4 = A*spire1.side4;
    %%%Rotate helmholtz coils (spire2)
    spire2.side1 = A*spire2.side1; spire2.side2 = A*spire2.side2;
    spire2.side3 = A*spire2.side3; spire2.side4 = A*spire2.side4;
end

function coil = coilSimulation1d(cubeRange, A1, IS501NMTB, I)
    %%% Generate planes X-Y, X-Z, Y-Z
    %%%Plane X-Y
    [X, Y] = meshgrid(cubeRange, cubeRange);
    %%% Align axes
    coil.xy.X=X;    coil.xy.Y=Y;
    coil.yz.Y=X;    coil.yz.Z=Y;
    coil.xz.X=X;    coil.xz.Z=Y;
    
    %%% Containers for the calculated magnetic field
    coil.xy.Bx = NaN(length(cubeRange),length(cubeRange));
    coil.xy.By = coil.xy.Bx; coil.xy.Bz = coil.xy.Bx; 
    
    coil.yz.Bx = coil.xy.Bx; coil.yz.By = coil.xy.Bx; 
    coil.yz.Bz = coil.xy.Bx; 
    
    coil.xz.Bx = coil.xy.Bx; coil.xz.By = coil.xy.Bx; 
    coil.xz.Bz = coil.xy.Bx; 
    
    coil.xy.norB = coil.xy.Bx; coil.xy.norB = coil.xy.Bx;
    coil.xy.norB = coil.xy.Bx;
    
    %% Simulation for the coil using BiotSavart coil
    %%%Define spired geometry
    [coil.spire1,coil.spire2] = squareSpires(A1, IS501NMTB.h, IS501NMTB.L, 1E3);
    for i = 1:length(X)
        for j = 1:length(Y)
            %%%Evaluate in x-y plane
            [B1,~,~] = magneticFielsSquareCoil([X(i,j),Y(i,j),0]', IS501NMTB.N, I, coil.spire1,coil.spire2);
            coil.xy.Bx(i,j) = B1(1); coil.xy.By(i,j) = B1(2); coil.xy.Bz(i,j) = B1(3); 
            coil.xy.norB(i,j) = norm(B1);
            %%%Evaluate in y-z plane
            [B2,~,~] = magneticFielsSquareCoil([0,X(i,j),Y(i,j)]', IS501NMTB.N, I, coil.spire1,coil.spire2);
            coil.yz.Bx(i,j) = B2(1); coil.yz.By(i,j) = B2(2); coil.yz.Bz(i,j) = B2(3); 
            coil.yz.norB(i,j) = norm(B2);
            %%%Evaluate in x-z plane
            [B3,~,~] = magneticFielsSquareCoil([X(i,j),0,Y(i,j)]', IS501NMTB.N, I, coil.spire1,coil.spire2);
            coil.xz.Bx(i,j) = B3(1); coil.xz.By(i,j) = B3(2); coil.xz.Bz(i,j) = B3(3); 
            coil.xz.norB(i,j) = norm(B3);
        end
    end
end