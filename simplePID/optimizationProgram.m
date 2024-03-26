no_var=3;  %number of variables
lb = [0 0 0]; % lower bound
up = [0.01 0.01 0.01]; % high bound
%initial = [1.479699757805321e-04 1.513933366758091e-05	0.009330283036400];
initial = [6.446234579382160e-04, 1.265158550081826e-04, 4.920959472656250e-04];

%GA OPTIONS
%try
ga_opt = gaoptimset('Display','off','Generations',50,'PopulationSize',200, ...
    'InitialPopulation',initial,'PlotFcns',@gaplotbestf);
obj_fun = @(k)myObjectiveFunction(k);

[k,bestblk] = ga((obj_fun),no_var,[],[],[],[],lb,up,[],ga_opt);
%%catch exception
%    disp('Error');
%end
%opt_kp = k(1);
%opt_ki = k(3);
%opt_kd = k(2);