%% Simulation parameters
%%%Parameters for the Z coil
IS501NMTB.Z.L = 1.03;
IS501NMTB.Z.a = IS501NMTB.Z.L/2 ;
IS501NMTB.Z.h = 0.5 ;
IS501NMTB.Z.N = 20; 
%%%Parameters for the Y coil
IS501NMTB.Y.L = 1.02;
IS501NMTB.Y.a = IS501NMTB.Y.L/2 ;
IS501NMTB.Y.h = 0.5 ;
IS501NMTB.Y.N = 35; 
%%%Parameters for the X coil
IS501NMTB.X.L = 1.03;
IS501NMTB.X.a = IS501NMTB.X.L/2 ;
IS501NMTB.X.h = 0.5;
IS501NMTB.X.N = 36;

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
%%% Matrix rotation from X to Y axis
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
function [B, B1, B2] = magneticFielsSquareCoil(P, N, I, spire1, spire2)
    % Function to calculate the magnetic field at point P due to two square coils (spire1 and spire2)
    % using the Biot-Savart Law.
    % Inputs:
    %   P - Observation point where the magnetic field is calculated (3x1 vector)
    %   N - Number of turns in each coil
    %   I - Current flowing through each coil
    %   spire1, spire2 - Structures representing each coil, with fields for 3D coordinates of segments
    % Outputs:
    %   B - Total magnetic field at point P (vector sum of B1 and B2)
    %   B1 - Magnetic field at P due to the first coil
    %   B2 - Magnetic field at P due to the second coil

    % Magnetic permeability of vacuum
    mu_0 = 4 * pi * 1e-7;                 
    
    % Initialize magnetic field vectors for each coil
    B1 = [0, 0, 0]'; 
    B2 = [0, 0, 0]';

    % Retrieve field names (segments) of the coils
    fieldsName = fields(spire1);

    % Loop through each segment of the coils
    for i = 1:numel(fieldsName)
        % Calculate differential length elements (dl) for each segment of coil1 and coil2
        dl_1 = diff(spire1.(fieldsName{i})')';   % Differential length element for coil 1
        dl_2 = diff(spire2.(fieldsName{i})')';   % Differential length element for coil 2

        % Loop through each point in the segment to apply Biot-Savart law
        for j = 1:length(spire1.(fieldsName{i})) - 1
            % Calculate the position vector R1 from the segment of coil 1 to point P
            R1 = P - spire1.(fieldsName{i})(:, j);
            
            % Calculate the position vector R2 from the segment of coil 2 to point P
            R2 = P - spire2.(fieldsName{i})(:, j);

            % Biot-Savart law to calculate differential magnetic field dB1 due to coil 1
            dB1 = (N * mu_0 * I / (4 * pi)) * cross(dl_1(:, j), R1) / norm(R1)^3;
            
            % Biot-Savart law to calculate differential magnetic field dB2 due to coil 2
            dB2 = (N * mu_0 * I / (4 * pi)) * cross(dl_2(:, j), R2) / norm(R2)^3;
            
            % Sum differential fields to get total field contribution from each segment
            B1 = B1 + dB1;
            B2 = B2 + dB2;
        end
    end
    
    % Total magnetic field at point P from both coils
    B = B1 + B2;
end

function [spire1, spire2] = squareSpires(A, h, L, numSeg)
    % squareSpires - Generates the coordinates for two square spires (coils) in the Y-Z plane.
    %
    % Syntax: [spire1, spire2] = squareSpires(A, h, L, numSeg)
    %
    % Inputs:
    %   A      - Rotation matrix to orient the spires.
    %   h      - Height of the coils.
    %   L      - Length of the coils.
    %   numSeg  - Number of segments for each side of the coils.
    %
    % Outputs:
    %   spire1  - Struct containing coordinates for the first coil.
    %   spire2  - Struct containing coordinates for the second coil.

    %%% Define limits for Spire 1 considering that the spire is in the Y-Z plane
    % Create the coordinates for each side of the first coil (spire1)
    spire1.side1 = [h/2 * ones(1, numSeg); linspace(L/2, -L/2, numSeg); L/2 * ones(1, numSeg)];  % Side facing -Y direction (bottom)
    spire1.side2 = [h/2 * ones(1, numSeg); -L/2 * ones(1, numSeg); linspace(L/2, -L/2, numSeg)];  % Side facing -Z direction (left)
    spire1.side3 = [h/2 * ones(1, numSeg); linspace(-L/2, L/2, numSeg); -L/2 * ones(1, numSeg)];  % Side facing +Y direction (top)
    spire1.side4 = [h/2 * ones(1, numSeg); L/2 * ones(1, numSeg); linspace(-L/2, L/2, numSeg)];   % Side facing +Z direction (right)
    
    %%% Define limits for Spire 2 considering that the spire is in the Y-Z plane
    % Create the coordinates for each side of the second coil (spire2)
    spire2.side1 = spire1.side1 - [h, 0, 0]';  % Adjust position for side facing -Y direction of coil 2
    spire2.side2 = spire1.side2 - [h, 0, 0]';  % Adjust position for side facing -Z direction of coil 2
    spire2.side3 = spire1.side3 - [h, 0, 0]';  % Adjust position for side facing +Y direction of coil 2
    spire2.side4 = spire1.side4 - [h, 0, 0]';  % Adjust position for side facing +Z direction of coil 2
    
    %%% Rotate the Helmholtz coils (spire1)
    spire1.side1 = A * spire1.side1;  % Apply rotation matrix to the first side of coil 1
    spire1.side2 = A * spire1.side2;  % Apply rotation matrix to the second side of coil 1
    spire1.side3 = A * spire1.side3;  % Apply rotation matrix to the third side of coil 1
    spire1.side4 = A * spire1.side4;  % Apply rotation matrix to the fourth side of coil 1
    
    %%% Rotate the Helmholtz coils (spire2)
    spire2.side1 = A * spire2.side1;  % Apply rotation matrix to the first side of coil 2
    spire2.side2 = A * spire2.side2;  % Apply rotation matrix to the second side of coil 2
    spire2.side3 = A * spire2.side3;  % Apply rotation matrix to the third side of coil 2
    spire2.side4 = A * spire2.side4;  % Apply rotation matrix to the fourth side of coil 2
end


function coil = coilSimulation1d(range, A, IS501NMTB, I)
    % coilSimulation1d - Simulates the magnetic field generated by two coils in three planes.
    %
    % Syntax: coil = coilSimulation1d(range, A1, IS501NMTB, I)
    %
    % Inputs:
    %   range       - Range of values for the X and Y coordinates in the simulation.
    %   A1          - Rotation matrix to orient the coils.
    %   IS501NMTB   - Structure containing coil parameters (height, length, turns).
    %   I           - Current flowing through the coils.
    %
    % Outputs:
    %   coil        - Structure containing the calculated magnetic fields and coil geometries.

    %%% Generate planes X-Y, X-Z, Y-Z
    % Create a mesh grid for the specified range
    [X, Y] = meshgrid(range, range);  % X-Y plane grid

    %%% Align axes for different planes
    coil.xy.X = X;    coil.xy.Y = Y;  % Assign X and Y for X-Y plane
    coil.yz.Y = X;    coil.yz.Z = Y;  % Assign Y and Z for Y-Z plane
    coil.xz.X = X;    coil.xz.Z = Y;  % Assign X and Z for X-Z plane
    
    %%% Containers for the calculated magnetic field
    % Initialize magnetic field components for the X-Y plane
    coil.xy.Bx = NaN(length(range), length(range));  % Magnetic field X component
    coil.xy.By = coil.xy.Bx;  % Magnetic field Y component
    coil.xy.Bz = coil.xy.Bx;  % Magnetic field Z component
    
    % Initialize magnetic field components for the Y-Z plane
    coil.yz.Bx = coil.xy.Bx;   % Magnetic field X component
    coil.yz.By = coil.xy.Bx;   % Magnetic field Y component
    coil.yz.Bz = coil.xy.Bx;   % Magnetic field Z component
    
    % Initialize magnetic field components for the X-Z plane
    coil.xz.Bx = coil.xy.Bx;   % Magnetic field X component
    coil.xz.By = coil.xy.Bx;   % Magnetic field Y component
    coil.xz.Bz = coil.xy.Bx;   % Magnetic field Z component
    
    % Initialize containers for the magnitude of the magnetic field
    coil.xy.norB = coil.xy.Bx;  % Normalized magnetic field for X-Y plane
    coil.yz.norB = coil.xy.Bx;   % Normalized magnetic field for Y-Z plane
    coil.xz.norB = coil.xy.Bx;   % Normalized magnetic field for X-Z plane

    %% Create wait bar
    hWaitbar = waitbar(0, 'Progress: 0%', 'Name', 'IS501 NMTB Simulation progress..');  % Initialize wait bar
    numIter = length(X)^2;  % Total number of iterations based on grid size
    currentIter = 0;  % Current iteration counter

    %% Simulation for the coil using Biot-Savart law
    %%% Define spired geometry
    [coil.spire1, coil.spire2] = squareSpires(A, IS501NMTB.h, IS501NMTB.L, 1E3);  % Generate coil geometries

    % Loop through the X and Y grid to calculate magnetic fields
    for i = 1:length(X)  % Iterate over X values
        for j = 1:length(Y)  % Iterate over Y values
            %%% Evaluate magnetic field in the X-Y plane
            [B1, ~, ~] = magneticFielsSquareCoil([X(i,j), Y(i,j), 0]', IS501NMTB.N, I, coil.spire1, coil.spire2);
            coil.xy.Bx(i,j) = B1(1);  % Store Bx component for X-Y
            coil.xy.By(i,j) = B1(2);  % Store By component for X-Y
            coil.xy.Bz(i,j) = B1(3);  % Store Bz component for X-Y
            coil.xy.norB(i,j) = norm(B1);  % Calculate and store the magnitude of B for X-Y

            %%% Evaluate magnetic field in the Y-Z plane
            [B2, ~, ~] = magneticFielsSquareCoil([0, X(i,j), Y(i,j)]', IS501NMTB.N, I, coil.spire1, coil.spire2);
            coil.yz.Bx(i,j) = B2(1);  % Store Bx component for Y-Z
            coil.yz.By(i,j) = B2(2);  % Store By component for Y-Z
            coil.yz.Bz(i,j) = B2(3);  % Store Bz component for Y-Z
            coil.yz.norB(i,j) = norm(B2);  % Calculate and store the magnitude of B for Y-Z

            %%% Evaluate magnetic field in the X-Z plane
            [B3, ~, ~] = magneticFielsSquareCoil([X(i,j), 0, Y(i,j)]', IS501NMTB.N, I, coil.spire1, coil.spire2);
            coil.xz.Bx(i,j) = B3(1);  % Store Bx component for X-Z
            coil.xz.By(i,j) = B3(2);  % Store By component for X-Z
            coil.xz.Bz(i,j) = B3(3);  % Store Bz component for X-Z
            coil.xz.norB(i,j) = norm(B3);  % Calculate and store the magnitude of B for X-Z

            %% Progress bar configuration
            %%%% Calculate the progress percentage
            currentIter = currentIter + 1;  % Increment the current iteration count
            progress = currentIter / numIter;  % Calculate progress as a fraction
            if isa(hWaitbar, 'handle') && isvalid(hWaitbar)  % Check if the wait bar is still valid
                % Update the progress bar
                waitbar(progress, hWaitbar, sprintf('Progress: %.1f%%', progress * 100));  % Display progress
            end
        end
    end

    %%% Close waitbar
    close(hWaitbar);  % Close the progress bar when the simulation is complete
end