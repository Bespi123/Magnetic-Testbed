no_var = 2;  %number of variables
lb = [-Inf -Inf]; % lower bound
up = [Inf Inf]; % high bound
initial = [1E-06 1];
%initial = [2.290700520974975e-04, 1.996463879247196e-05, 0];

%GA OPTIONS
%try
ga_opt = gaoptimset('Display','off','Generations',50,'PopulationSize',50, ...
    'InitialPopulation',initial,'PlotFcns',@gaplotbestf); 
obj_fun = @(k)myObjectiveFunction(k);

[k,bestblk] = ga((obj_fun),no_var,[],[],[],[],lb,up,[],ga_opt);
%%catch exception
%    disp('Error');
%end
%opt_kp = k(1);
%opt_ki = k(3);
%opt_kd = k(2);