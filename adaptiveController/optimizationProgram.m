xcoilParameters;
no_var = 8;  %number of variables
lb = [0 -0.1 -0.1 -0.1 -0.1 -0.1 0 0]; % lower bound
up = [1E-3 0.1 0.1 0.1 0.1 0.1 1E4 1E4]; % high bound
initial = [6.7756E-5 0 0 0 0 0 0.5 1];
%initial = [2.290700520974975e-04, 1.996463879247196e-05, 0];

%GA OPTIONS
%try
ga_opt = gaoptimset('Display','off','Generations',30,'PopulationSize',100, ...
    'InitialPopulation',initial,'PlotFcns',@gaplotbestf);
obj_fun = @(k)myObjectiveFunction(k);

[k,bestblk] = ga((obj_fun),no_var,[],[],[],[],lb,up,[],ga_opt);
%%catch exception
%    disp('Error');
%end
%opt_kp = k(1);
%opt_ki = k(3);
%opt_kd = k(2);