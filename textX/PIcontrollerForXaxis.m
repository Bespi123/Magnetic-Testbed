%% Create TCP/IP object 't'. Specify server machine and port number. 
x_axis = tcpip("192.168.0.10", 30000);

%% Open connection to the server. 
fopen(x_axis); pause(1);
%%% Send preliminary data
commands = 'SYSTem:REMote;DISP:SCRE HOME;CURRent 2.0';
fprintf(x_axis,commands);

%% Check if magnetometer is available
disp("Display available Serial Ports:");
availableSerialPorts = IDSerialComs("available");
disp(availableSerialPorts);
%%Then we checked the name USB-SERIAL CH430 and a serial object is necesary to be created.
for i = 1:size(availableSerialPorts,1)
    if strcmp('USB-SERIAL CH340',availableSerialPorts{i,1})
        try
            s = serialport(availableSerialPorts{i,2},9600);
            disp('Port connected sucessfully.');
        catch Err
            disp(Err.message);
        end
    end
end

%% List all files into de directory
matFiles = dir(fullfile('*.mat'));
fileName = 'xCoil_Epoch_2024_01_08.mat';
flag = 0; %%flag to check previous measures

%%% Check if there are .mat files
if isempty(matFiles)
    disp('No previosly records performed.');
else
    disp('The following .mat files were founded in the current directory:');
    %%% Display all matfiles
    for i = 1:numel(matFiles)
        disp(matFiles(i).name);
        if strcmp(matFiles(i).name,fileName)
            load(matFiles(i).name);
            flag = 1;
        end
    end
end

if flag ~= 1 
    x_coil_data = nan(6,1);
end

figure();
p1 = subplot(3,2,1);
    h1 = plot(x_coil_data(1,:), x_coil_data(2,:),'r.','LineWidth',4); hold on;
    xlabel('t(s)'); ylabel('X(nT)'); axis equal; grid on;
    title('Static measurements'); 
p2 = subplot(3,2,3);
    h2 = plot(x_coil_data(1,:), x_coil_data(3,:),'g.','LineWidth',4); hold on;
    xlabel('t(s)'); ylabel('Y(nT)'); axis equal; grid on;   
p3 = subplot(3,2,5);
    h3 = plot(x_coil_data(1,:), x_coil_data(4,:),'b.','LineWidth',4); hold on;
    xlabel('t(s)'); ylabel('Z(nT)'); axis equal; grid on;  
p4 = subplot(1,2,2);
    h4 = plot(x_coil_data(5,:), x_coil_data(6,:),'k.','LineWidth',4); hold on;
    xlabel('A'); ylabel('V'); axis equal; grid on;  
    %linkaxes([p1,p2,p3],'x')
    
%%%Initialize kbhit to enable to stop the progran with a key
%kbhit('init');

ts =tic;

%% program variables
firstLoop = 1;

%% Simulation configurations
setpoint = 0;
%%PID gains
Kp = 1.460477259865257e-04;
Ki = 1.064753047190848e-05;
Kd = 0;
R = 14.84;
%%dt = 1; %% seconds
integralvalue = 0;
prev_error = 0;
tant=0;

%% Start experiment
figure()
while 1
     %%%Read magnetometer value
    rawData = read(s,27,"string");
    actualMeasures = sscanf(rawData,'%fA%fB%fC'); 
    
    %%%Start to measure the time
    t1 = toc(ts);
    dt = t1- tant;
    if(dt>=0.8)
    %%%PID controller
    % Calculate error
    current_value = actualMeasures(1);
    error = setpoint - current_value;
    
    % Proportional term
    P = Kp * error;
    
    % Integral term
    integralvalue = integralvalue + Ki * error * dt;
    
    % Derivative term
    derivative = Kd * (error - prev_error) / dt;
    
    % PID control law
    V = P + integralvalue + derivative;
    
    %V=I*R;
    
    %%%Update coil current and enable output
    fprintf(x_axis,['VOLTage ', num2str(V,'%.2f')]);
    if (firstLoop==1)
        fprintf(x_axis, 'OUTPut ON');
        firstLoop = 0;
    end
    %%%Request measured voltage and current
    fprintf(x_axis, 'MEASure:VOLTage?;MEASure:CURRent?');
    pause(0.5);
    %%% Receive lines of data from server TCP 
    while (get(x_axis, 'BytesAvailable') > 0) 
        x_axis.BytesAvailable;
        DataReceived = fscanf(x_axis);
    end  
        
    if exist('DataReceived','var')
        if (length(DataReceived)>13)
        numDat = sscanf(DataReceived,'%f%f');
        currentData = vertcat(t1, actualMeasures,numDat);
        x_coil_data = [x_coil_data,currentData];
    % %%Update graphs
    %set(h1, 'XData',[get(h1, 'XData'),t1],'YData', [get(h1, 'YData'),actualMeasures(1)]);
    %set(h2, 'XData',[get(h2, 'XData'),t1],'YData', [get(h2, 'YData'),actualMeasures(2)]);
    %set(h3, 'XData',[get(h3, 'XData'),t1],'YData', [get(h3, 'YData'),actualMeasures(3)]);
    %set(h4, 'XData',[get(h4, 'XData'),numDat(2)],'YData', [get(h4, 'YData'), numDat(1)]);
    
    %%%Update figure
    %drawnow;
        end
    end
    
    pause(0.1);
    
    % Update previous error for the next iteration
    prev_error = error;
    tant = t1;
    end
end

%%%Disconnect and clean up the server connection. 
fclose(x_axis); 
delete(x_axis); 
%%%Close Serial communication
delete(s);
clear x_axis 


function devices = IDSerialComs(options)
% IDSerialComs identifies Serial COM devices on Windows systems by friendly name
% Searches the Windows registry for serial hardware info and returns devices,
% a cell array where the first column holds the name of the device and the
% second column holds the COM number. Devices returns empty if nothing is found.
% Copyright (c) 2014, Benjamin W. Avants
% All rights reserved.
    devices = [];
    %%% Get the name of the available serial ports
    availableSerialPorts = serialportlist(options);
    if isempty(availableSerialPorts)
        disp('No Serial COMS available')
        return;
    end

    %%% Get the friendly name
    key = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USB\';
    [~, vals] = dos(['REG QUERY ' key ' /s /f "FriendlyName" /t "REG_SZ"']);
    if ischar(vals) && strcmp('ERROR',vals(1:5))
        disp('Error: IDSerialComs - No Enumerated USB registry entry')
        return;
    end
    vals = textscan(vals,'%s','delimiter','\t');
    vals = cat(1,vals{:});
    out = 0;
    for i = 1:numel(vals)
        if strcmp(vals{i}(1:min(12,end)),'FriendlyName')
            if ~iscell(out)
                out = vals(i);
            else
                out{end+1} = vals{i}; %#ok<AGROW> Loop size is always small
            end
        end
    end

    for i = 1:numel(availableSerialPorts)
        match = strfind(out,availableSerialPorts{i});
        ind = 0;
        for j = 1:numel(match)
            if ~isempty(match{j})
                ind = j;
            end
        end
        if ind ~= 0
            com = str2double(erase(availableSerialPorts{i},'COM'));
            if com > 9
                length = 8;
            else
                length = 7;
            end
            devices{i,1} = out{ind}(27:end-length); %#ok<AGROW>
            devices{i,2} = availableSerialPorts{i}; %#ok<AGROW> Loop size is always small
        end
    end
end
