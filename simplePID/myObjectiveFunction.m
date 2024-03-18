function J=myObjectiveFunction(x)
% Template for Creating an Objective Function Using a Simulink Block Diagram
% x contains all the controller variables of the problem in a column vector.
% Acknoledgment: 
% Professor Juan Pablo Requez Vivas for the Intelligent Control
% course - UNEXPO - 2023 - jrequez@unexpo.edu.ve
% Modified by Bespi123 on 26/02/2024

%%%%%%%%%%%%%%%%%%%     SECTION 1: Variables          %%%%%%%%%%%%%%%%%%%%%
% Separate the variables into their appropriate names, according to the
% problem at hand. These variables correspond to the elements of x, which
% must be n different elements.
PID_kp=x(1); PID_kd=x(2); PID_ki=x(3);     %Pid gains 

%%%%%%%%%%%%%%%%%%%     SECTION 2: Conditions         %%%%%%%%%%%%%%%%%%%%%
% Operating conditions of the problem. If the problem has parameters or 
% data that you need to add, place them in this section.
xcoilParameters; %call plant variables

%%%%%%%%%%%%%%%%%%%     SECTION 3: Pre-Calculations   %%%%%%%%%%%%%%%%%%%%%
% Pre-calculations
% If the problem requires performing pre-calculations to facilitate the
% evaluation of the objective function, place them here.

%%%%%%%%%%%%%%%%%%% SECTION 4: Simulate the Process  %%%%%%%%%%%%%%%%%%%%%%
% Simulink is called to simulate the process of interest and calculate the
% simulation outputs
% WARNING!!! The model name must be changed in the following line
salidas=sim('simplePID','SrcWorkspace','current');
% The simulation outputs are divided into two groups, the time and the
% outputs themselves
yout=salidas.get('yout');
t=salidas.get('tout');

% It is common to have the system error as out1, the controller output u as
% out2, and the output y as out3
e=yout(:,1); u=yout(:,2); y=yout(:,3);%Define erro, control signal and output

%%%%%%%%%%%%%%%%%%% SECTION 5: Calculate the Fitness  %%%%%%%%%%%%%%%%%%%%%%
% The response of the process is now analyzed. If the input is not a step, 
% other variables or representative calculations must be chosen in this
% section and what is shown may not be applicable.

%-----Indice preestablecido------------
%digamos que se desea que el tiempo de establecimiento sea un valor
%espec�fico
desired_setlement_time = 376;
% Define the settling time threshold (e.g., 2%)
threshold_setlement_time = 0.02; 
% Find the final value of the output
final_value = y(end);
% Identify the settling time index
settling_time_idx = find( ~(e < threshold_setlement_time*final_value), 1, 'last');
% Calculate the current settling time
setling_time = t(settling_time_idx);
setlement_time_error = abs(desired_setlement_time-setling_time);

%----RisingTime
desired_rising_time = 80;
% Define the settling time threshold (e.g., 2%)
threshold_rising_time =  0.5;
% Identify the settling time index
rising_time_idx = find( ~(e < threshold_rising_time*final_value), 1, 'last');
% Calculate the settling time
rising_time = t(rising_time_idx);
rising_time_error = abs(desired_rising_time-rising_time);

%-----�ndices de error integral --------
%itse=trapz(t,t.*e.^2);
itse=trapz(t,e.^2);

%-----
overshoot = max(y);
a = overshoot - 1;
if a > 0
    overshoot_index = a;
else
    overshoot_index = 0;
end
%umax = max(u);
uwork = trapz(t,u.^2);

%%%-----Elecci�n del �ndice deseado como fitness-------
%%% Se determina la salida del la funci�n fitness
%%%J=itse+overshoot+umax+uwork+timeWorking;
%%%J=itse+setlement_time_error+overshoot+rising_time_error;
%%%J=itse+setlement_time_error+rising_time_error;
J=0.2*itse+0.3*rising_time_error^2+0.3*setlement_time_error^2+0.2*overshoot_index^2+0.2*uwork;