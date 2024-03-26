no_var=8;  %number of variables
lb = -0.1*ones(1,8); % lower bound
up =  0.1*ones(1,8); % high bound
%initial = [0.00664884785499449	0.00321464749562130	1.16161059495086e-05];
initial = [0.1, 0.01, 0.1, 0.01, 1E-6, 2.290700520974975e-04, 1.996463879247196e-05, 0];

%GA OPTIONS
ga_opt = gaoptimset('Display','off','Generations',25,'PopulationSize',100, ...
    'InitialPopulation',initial,'PlotFcns',@gaplotbestf);
obj_fun = @(k)myObjectiveFunction(k);

[k,bestblk] = ga((obj_fun),no_var,[],[],[],[],lb,up,[],ga_opt);

opt_kp = k(1);
opt_ki = k(3);
opt_kd = k(2);