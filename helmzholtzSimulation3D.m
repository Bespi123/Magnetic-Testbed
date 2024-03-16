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

%%% Matrix rotations 
Az = [0, 0,-1; 0, 1, 0; 1, 0, 0]; %% From X to Z axis
Ay = [0,-1, 0; 1, 0, 0; 0, 0, 1]; %% From X to Y axis
Ax = eye(3);                      %% From X to X axis

%%% Generate Helmholtz coils
[coils.spire1,coils.spire2] = squareSpires(Ax, IS501NMTB.X.h, IS501NMTB.X.L, 1E3); %1e-3
[coils.spire3,coils.spire4] = squareSpires(Ay, IS501NMTB.Y.h, IS501NMTB.Y.L, 1E3);
[coils.spire5,coils.spire6] = squareSpires(Az, IS501NMTB.Z.h, IS501NMTB.Z.L, 1E3);

%% Start simulation
%%% Coils currents
I = [1,1,1];                    %%%In the x, y, and z in A
%%% Generate X, Y, and Z plane
Range_x = -2*IS501NMTB.X.a:0.05:2*IS501NMTB.X.a;
Range_y = -2*IS501NMTB.Y.a:0.05:2*IS501NMTB.Y.a;
Range_z = -2*IS501NMTB.Z.a:0.05:2*IS501NMTB.Z.a;

if     ~any(Range_x == 0)
    %%% In the x axis
    Range_x = [Range_x, 0];
    Range_x = sort(Range_x);
elseif ~any(Range_y == 0)
    %%% In the y axis
    Range_y = [Range_y, 0];
    Range_y = sort(Range_y);
elseif ~any(Range_z == 0)
    %%% In the z axis
    Range_z = [Range_z, 0];
    Range_z = sort(Range_z);
end

%%% Generate grid
[X, Y, Z] = meshgrid(Range_x, Range_y, Range_z);
%%% Containers for the calculated magnetic field
simResults.Bx_x = NaN(length(Range_x),length(Range_y),length(Range_z));
simResults.Bx_y = NaN(length(Range_x),length(Range_y),length(Range_z));
simResults.Bx_z = NaN(length(Range_x),length(Range_y),length(Range_z));
simResults.normBx = NaN(length(Range_x),length(Range_y),length(Range_z));

simResults.By_x = NaN(length(Range_x),length(Range_y),length(Range_z));
simResults.By_y = NaN(length(Range_x),length(Range_y),length(Range_z));
simResults.By_z = NaN(length(Range_x),length(Range_y),length(Range_z));
simResults.normBy = NaN(length(Range_x),length(Range_y),length(Range_z));

simResults.Bz_x = NaN(length(Range_x),length(Range_y),length(Range_z));
simResults.Bz_y = NaN(length(Range_x),length(Range_y),length(Range_z));
simResults.Bz_z = NaN(length(Range_x),length(Range_y),length(Range_z));
simResults.normBz = NaN(length(Range_x),length(Range_y),length(Range_z));

simResults.B_x  = NaN(length(Range_x),length(Range_y),length(Range_z));
simResults.B_y  = NaN(length(Range_x),length(Range_y),length(Range_z));
simResults.B_z  = NaN(length(Range_x),length(Range_y),length(Range_z));
simResults.normB = NaN(length(Range_x),length(Range_y),length(Range_z));

%% Create wait bar
%%%Progress bar settings
hWaitbar = waitbar(0, 'Progress: 0%','Name', 'IS501 NMTB 3D Simulation progress..');
currentIter = 0;                         %CurrentIteration
numIter = length(Range_x)*length(Range_y)*length(Range_z);

%% Start simulation
for i = 1:length(Range_x)
    for j = 1:length(Range_y)
        for k = 1:length(Range_z)
           [B,Bx,By,Bz] = magneticFielsSquareCoil([X(i,j,k),...
                                 Y(i,j,k),Z(i,j,k)]', IS501NMTB, I, coils);
           simResults.B_x(i,j,k) = B(1);
           simResults.B_y(i,j,k) = B(2);
           simResults.B_z(i,j,k) = B(3);
           simResults.normB(i,j,k) = norm(B);
                      
           simResults.Bx_x(i,j,k) = Bx(1);
           simResults.Bx_y(i,j,k) = Bx(2);
           simResults.Bx_z(i,j,k) = Bx(3);
           simResults.normBx(i,j,k) = norm(Bx);
                      
           simResults.By_x(i,j,k) = By(1);
           simResults.By_y(i,j,k) = By(2);
           simResults.By_z(i,j,k) = By(3);
           simResults.normBy(i,j,k) = norm(By);

           simResults.Bz_x(i,j,k) = Bz(1);
           simResults.Bz_y(i,j,k) = Bz(2);
           simResults.Bz_z(i,j,k) = Bz(3);
           simResults.normBz(i,j,k) = norm(Bz);

            %% Progress bar configuration
            %%%% Calculate the progress percentage
            currentIter = currentIter+1;
            progress = currentIter / numIter;
            if isa(hWaitbar,'handle') && isvalid(hWaitbar)
            % Update the progress bar
                waitbar(progress, hWaitbar, sprintf('Progress: %.1f%%', progress*100));
            end
        end
    end
end
%%%Close waitbar
% Close the progress bar when the simulation is complete
close(hWaitbar);

%% Program functions
function [B,Bx,By,Bz] = magneticFielsSquareCoil(P, IS501NMTB, I, coils) 
    %%% Parameters
    mu_0 = 4*pi*1e-7;                 %Magnetic Permeability of Vacuum

    %%% Recover coils geometry
    Nx = IS501NMTB.X.N; Ny = IS501NMTB.Y.N; Nz = IS501NMTB.Z.N;
    Ix = I(1); Iy = I(2); Iz = I(3);

    %%% Initial values
    Bx = [0, 0, 0]'; %Magnetic field generated for the coil1 and coil2
    By = [0, 0, 0]'; %Magnetic field generated for the coil3 and coil4
    Bz = [0, 0, 0]'; %Magnetic field generated for the coil5 and coil6
    %B  = [0, 0, 0]'; 
    %%% Calculate magnetic field generated
    fieldnamesCoils = fields(coils);
    fieldsNameSides = fields(coils.spire1);  
    
    %%DEBUG
    %%%plotHeltholtsCoils(coils.spire1,coils.spire2,1);hold on;

    for n = 1:numel(fieldnamesCoils)
        for i = 1:numel(fieldsNameSides) 
            dl = diff(coils.([fieldnamesCoils{n,1}]).([fieldsNameSides{i,1}])')';   %infinitesimal of coil1
            for j = 1:length(coils.([fieldnamesCoils{n,1}]).([fieldsNameSides{i,1}]))-1
                %%%Calculate vector R
                R = P-coils.([fieldnamesCoils{n,1}]).([fieldsNameSides{i,1}])(:,j);
                %%%DEBUG 
                %%%%plotVector(coils.([fieldnamesCoils{n,1}]).([fieldsNameSides{i,1}])(:,j),R,1,'b',' ','m');

                %%%Calculate BiotSavartRaw
                if (strcmp([fieldnamesCoils{n,1}],'spire1')||strcmp([fieldnamesCoils{n,1}],'spire2'))
                    %%%for X coils
                    dBx = (Nx*mu_0 * Ix / (4 * pi)) * cross(dl(:,j), R) / norm(R)^3;
                    %%%DEBUG
                    %%%plotVector(coils.([fieldnamesCoils{n,1}]).([fieldsNameSides{i,1}])(:,j),dBx/norm(dBx),1,'g',' ','m');
                    Bx = Bx+dBx;

                elseif (strcmp([fieldnamesCoils{n,1}],'spire3')||strcmp([fieldnamesCoils{n,1}],'spire4'))
                    %%%for Y coils
                    dBy = (Ny*mu_0 * Iy / (4 * pi)) * cross(dl(:,j), R) / norm(R)^3;
                    %%%DEBUG
                    %%%plotVector(coils.([fieldnamesCoils{n,1}]).([fieldsNameSides{i,1}])(:,j),dBy/norm(dBy),1,'y',' ','m');
                    By = By+dBy;

                elseif (strcmp([fieldnamesCoils{n,1}],'spire5')||strcmp([fieldnamesCoils{n,1}],'spire6'))
                    %%%for Z coils
                    dBz = (Nz*mu_0 * Iz / (4 * pi)) * cross(dl(:,j), R) / norm(R)^3;
                    %%%DEBUG
                    %%plotVector(coils.([fieldnamesCoils{n,1}]).([fieldsNameSides{i,1}])(:,j),dBz/norm(dBz),1,'y',' ','m');
                    Bz = Bz+dBz;
                else
                    disp('Error')
                end
            end
        end
    end
    B = Bx+By+Bz;
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