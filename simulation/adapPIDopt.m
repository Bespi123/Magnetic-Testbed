%xcoilParameters;
no_var = 12;  %number of variables
lb = zeros(1,12); % lower bound
up = Inf(1,12); % high bound
%up(1) = 1;

initial = [x.pid_v2.Yg, x.pid_v2.np, x.pid_v2.ni, x.pid_v2.nd,...
           y.pid_v2.Yg, y.pid_v2.np, y.pid_v2.ni, y.pid_v2.nd,...
           z.pid_v2.Yg, z.pid_v2.np, z.pid_v2.ni, z.pid_v2.nd];

%GA OPTIONS
%try
ga_opt = optimoptions('ga','Display','off','MaxGenerations',10,'PopulationSize',10, ...
    'InitialPopulationMatrix',initial,'PlotFcn',@gaplotbestf,'MutationFcn', @mutationadaptfeasible);
%ga_opt.UseParallel = canUseGPU();
%ga_opt = gaoptimset('Display','off','Generations',200,'PopulationSize',200, ...
%    'InitialPopulation',initial,'PlotFcns',@gaplotbestf);
obj_fun = @(k)myObjectiveFunction_adapPID(k);

[k,bestblk] = ga((obj_fun),no_var,[],[],[],[],lb,up,[],ga_opt);
%%catch exception
%    disp('Error');
%end
%opt_kp = k(1);
%opt_ki = k(3);
%opt_kd = k(2);