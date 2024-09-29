%xcoilParameters;
no_var = 9;  %number of variables
lb = zeros(1,9); % lower bound
up = Inf(1,9); % high bound

initial = [1380648.9719, 6783283495.8308, 0, 548580.3214,...
           1697252969.9689, 0, 641963.3974, 7238744360.0891, 0];

%GA OPTIONS
%try
ga_opt = optimoptions('ga','Display','off','MaxGenerations',10,'PopulationSize',10, ...
    'InitialPopulationMatrix',initial,'PlotFcn',@gaplotbestf,'MutationFcn', @mutationadaptfeasible);
%ga_opt.UseParallel = canUseGPU();
%ga_opt = gaoptimset('Display','off','Generations',200,'PopulationSize',200, ...
%    'InitialPopulation',initial,'PlotFcns',@gaplotbestf);
obj_fun = @(k)myObjectiveFunction(k);

[k,bestblk] = ga((obj_fun),no_var,[],[],[],[],lb,up,[],ga_opt);
%%catch exception
%    disp('Error');
%end
x.PID.Kp = k(1);
x.PID.Ki = k(2);
x.PID.Kd = k(3);
y.PID.Kp = k(4);
y.PID.Ki = k(5);
y.PID.Kd = k(6);
z.PID.Kp = k(7);
z.PID.Ki = k(8);
z.PID.Kd = k(9);