%xcoilParameters;
no_var = 8;  %number of variables
%lb = [0 -0.1 -0.1 -0.1 -0.1 -0.1 0 0]; % lower bound
%up = [1E-3 0.1 0.1 0.1 0.1 0.1 1E4 1E4]; % high bound
lb = [0 -Inf -Inf -Inf -Inf -Inf 0 -Inf ]; % lower bound
up = [Inf Inf Inf Inf Inf Inf Inf Inf]; % high bound

%initial = [6.775600000000000e-05 0.250000000000000 0 0 0 1 13.105135224940307 -5.341519126646842];
initial = [0.015692756000000, -6.176194766351632, 0, 0, 0,1,10.212275872372466,-6.216519126646842];

%GA OPTIONS
%try
ga_opt = optimoptions('ga','Display','off','MaxGenerations',500,'PopulationSize',500, ...
    'InitialPopulationMatrix',initial,'PlotFcn',@gaplotbestf,'MutationFcn', @mutationadaptfeasible);

%ga_opt = gaoptimset('Display','off','Generations',200,'PopulationSize',200, ...
%    'InitialPopulation',initial,'PlotFcns',@gaplotbestf);
obj_fun = @(k)myObjectiveFunction(k);

[k,bestblk] = ga((obj_fun),no_var,[],[],[],[],lb,up,[],ga_opt);
%%catch exception
%    disp('Error');
%end
%opt_kp = k(1);
%opt_ki = k(3);
%opt_kd = k(2);