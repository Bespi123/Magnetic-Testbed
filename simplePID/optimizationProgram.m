no_var=3;  %number of variables
lb = [0 0 0]; % lower bound
up = [0.01 0.01 0.01]; % high bound
%initial = [0.00664884785499449	0.00321464749562130	1.16161059495086e-05];
initial = [ 1.4605e-04 0 1.0648e-05];

%GA OPTIONS
ga_opt = gaoptimset('Display','off','Generations',25,'PopulationSize',100, ...
    'InitialPopulation',initial,'PlotFcns',@gaplotbestf);
obj_fun = @(k)myObjectiveFunction(k);

[k,bestblk] = ga((obj_fun),no_var,[],[],[],[],lb,up,[],ga_opt);

opt_kp = k(1);
opt_ki = k(3);
opt_kd = k(2);