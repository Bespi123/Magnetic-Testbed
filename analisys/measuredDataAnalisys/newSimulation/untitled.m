%xcoilParameters;
no_var = 9;  %number of variables
lb = zeros(1,9); % lower bound
up = Inf(1,9); % high bound

initial = [7.034383411703327e-04, 0.001083608847320, 3.096305095968147e-05,...
           0.001047044877412, 8.904034390454403e-05, 0, 0, 0.00008067154904, 0];

%GA OPTIONS
%try
ga_opt = optimoptions('ga','Display','off','MaxGenerations',10,'PopulationSize',20, ...
    'InitialPopulationMatrix',initial,'PlotFcn',@gaplotbestf,'MutationFcn', @mutationadaptfeasible);
ga_opt.UseParallel = canUseGPU();
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