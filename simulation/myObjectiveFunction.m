function J=myObjectiveFunction(k)
% Template for Creating an Objective Function Using a Simulink Block Diagram
% x contains all the controller variables of the problem in a column vector.
% Acknoledgment: 
% Professor Juan Pablo Requez Vivas for the Intelligent Control
% course - UNEXPO - 2023 - jrequez@unexpo.edu.ve
% Modified by Bespi123 on 26/02/2024

%%%%%%%%%%%%%%%%%%%     SECTION 1: Variables          %%%%%%%%%%%%%%%%%%%%%
parameters;
x.PID.Kp=k(1);
x.PID.Ki=k(2);
x.PID.Kd=k(3);
y.PID.Kp=k(4);
y.PID.Ki=k(5);
y.PID.Kd=k(6);
z.PID.Kp=k(7);
z.PID.Ki=k(8);
z.PID.Kd=k(9);

%%%%%%%%%%%%%%%%%%%     SECTION 3: Pre-Calculations   %%%%%%%%%%%%%%%%%%%%%
% Pre-calculations
% If the problem requires performing pre-calculations to facilitate the
% evaluation of the objective function, place them here.

%%%%%%%%%%%%%%%%%%% SECTION 4: Simulate the Process  %%%%%%%%%%%%%%%%%%%%%%
% Simulink is called to simulate the process of interest and calculate the
% simulation outputs
% WARNING!!! The model name must be changed in the following line
try
   salidas=sim('closeLoopv2.slx','SrcWorkspace','current');
   stable = 1;
catch exception
   
   if strcmp(exception.identifier,'Simulink:Engine:DerivNotFinite')
    stable = 0;
    disp('System No stable')
   else
       disp('Otro error')
       stable = 0;
   end
end

if(stable == 1)
% The simulation outputs are divided into two groups, the time and the
% outputs themselves
yout = salidas.get('yout');
t    = salidas.get('tout');

% It is common to have the system error as out1, the controller output u as
% out2, and the output y as out3
temp.e    = yout{1}.Values.Data;
temp.u    = yout{2}.Values.Data;
temp.y    = yout{5}.Values.Data;

e    = zeros(size(temp.e, 3),3);
u    = zeros(size(temp.u, 3),3);
Y    = zeros(size(temp.y, 3),3);

%Display each slice of the 3D array
numSlices = size(temp.e, 3);
for j = 1:numSlices
    %fprintf('val(:,:, %d) =\n\n', j);
    e(j,:) = temp.e(:, :, j);
    u(j,:) = temp.u(:, :, j);
    Y(j,:) = temp.y(:, :, j);
end

%%%%%%%%%%%%%%%%%%% SECTION 5: Calculate the Fitness  %%%%%%%%%%%%%%%%%%%%%%
% The response of the process is now analyzed. If the input is not a step, 
% other variables or representative calculations must be chosen in this
% section and what is shown may not be applicable.

%-----Indice preestablecido------------
%digamos que se desea que el tiempo de establecimiento sea un valor
%espec�fico
%desired_setlement_time = 376;
%desired_rising_time    = 80;
%desired_setlement_time = 0;
%desired_rising_time    = 0;

% calculate rising time
%tr = calculateRissingTime(e, t, 50/100);
%d_tr = abs(desired_rising_time-tr);

% Calculate settlement time
%ts = calculateSettlementTime(e, t, 5/100);
%d_ts = abs(desired_setlement_time-ts);

%-----�ndices de error integral --------
%itse=trapz(t,t.*e.^2);
itse = trapz(t,e.^2);

itsy = trapz(t,Y.^2);

entropy = calculate_entropy(Y);
% % %-----
%overshoot = max(y);
[overshoot, ~] = calculateOvershoot(abs(Y));

uwork = trapz(t,u.^2);

%%%-----Elecci�n del �ndice deseado como fitness-------
%%% Se determina la salida del la funci�n fitness
%%%J=itse+overshoot+umax+uwork+timeWorking;
%%%J=itse+setlement_time_error+overshoot+rising_time_error;
%%%J=itse+setlement_time_error+rising_time_error;
%if isempty(tr) || isempty(ts)
%    J = 5E4;
%else
    %J = d_tr+d_ts+itse+uwork+itsy+entropy+overshoot*100; %%%High value of J
    J = sum(itse+uwork+itsy+entropy+overshoot*100); %%%High value of J
%end
else
    J = Inf;

end

end

function entropy = calculate_entropy(signal)
    % Calculate the Shannon entropy of a signal.
    % Input: signal (1D array)
    % Output: entropy

    unique_values = unique(signal);
    probabilities = histcounts(signal, unique_values) / numel(signal);
    entropy = -sum(probabilities .* log2(probabilities));
end