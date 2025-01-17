%% Genetic Algorithm Configuration and Execution with Parallelization

% Number of variables
no_var = 9;  % Number of optimization variables

% Bounds for the variables
lb = zeros(1, no_var); % Lower bounds (all variables >= 0)
up = Inf(1, no_var);  % Upper bounds (no limit)

% Initial population for GA
initial = [0.00042024, 2.2979, 0, ...
           0.00078586, 2.3250, 0, ...
           0.00059495, 7.1080, 0];

% Genetic Algorithm (GA) options
% Display: Suppresses intermediate output
% MaxGenerations: Limits the number of generations
% PopulationSize: Controls the size of the population
% InitialPopulationMatrix: Sets the initial population
% PlotFcn: Plots the best fitness value over iterations
% MutationFcn: Uses an adaptive feasible mutation function

try
    % Enable parallelization
    ga_opt = optimoptions('ga', 'Display', 'off', 'MaxGenerations', 10, ...
                          'PopulationSize', 10, 'InitialPopulationMatrix', initial, ...
                          'PlotFcn', @gaplotbestf, 'MutationFcn', @mutationadaptfeasible, ...
                          'UseParallel', true); % Enable parallel computing
    
    % Check if the parallel pool is available and start it if needed
    if isempty(gcp('nocreate'))
        parpool; % Start a parallel pool if not already started
    end

    % Objective function handle
    obj_fun = @(k) myObjectiveFunction(k);

    % Run the genetic algorithm
    [k, bestblk] = ga(obj_fun, no_var, [], [], [], [], lb, up, [], ga_opt);

    % Assign the optimized parameters to the PID controllers
    x.PID.Kp = k(1);
    x.PID.Ki = k(2);
    x.PID.Kd = k(3);
    y.PID.Kp = k(4);
    y.PID.Ki = k(5);
    y.PID.Kd = k(6);
    z.PID.Kp = k(7);
    z.PID.Ki = k(8);
    z.PID.Kd = k(9);

    % Display optimized parameters (optional)
    disp('Optimized Parameters:');
    disp(k);

catch exception
    % Handle any exceptions during the GA execution
    disp('An error occurred during the GA optimization process:');
    disp(exception.message);
end