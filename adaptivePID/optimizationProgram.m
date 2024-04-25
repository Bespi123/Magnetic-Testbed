no_var=8;  %number of variables
lb = -0.1*ones(1,8); % lower bound
up =  0.1*ones(1,8); % high bound
%initial = [0.00664884785499449	0.00321464749562130	1.16161059495086e-05];
initial = [0.0375   -0.0115    0.0827    0.0711    0.0063    0.0538    0.0164    0.1000];

%GA OPTIONS
ga_opt = optimoptions('ga','Display','off','MaxGenerations',25,'PopulationSize',100, ...
    'InitialPopulationMatrix',initial,'PlotFcn',@gaplotbestf,'MutationFcn','mutationpositivebasis');
%ga_opt = gaoptimset('Display','off','Generations',25,'PopulationSize',100, ...
%    'InitialPopulation',initial,'PlotFcns',@gaplotbestf);
obj_fun = @(k)myObjectiveFunction(k);

[k,bestblk] = ga((obj_fun),no_var,[],[],[],[],lb,up,[],ga_opt);

opt_kp = k(1);
opt_ki = k(3);
opt_kd = k(2);