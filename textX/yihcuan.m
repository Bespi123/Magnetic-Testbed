function [Q, R] = geneticAlgorithm(A, B, C, D)  
    % 遗传算法参数  
    popSize = 100; % 种群大小  
    chromLength = 4; % 染色体长度（这里假设Q和R都是2x2矩阵）  
    genMax = 100; % 最大迭代次数  
      
    % 初始化种群  
    pop = round(rand(popSize, chromLength));  
      
    % 主循环  
    for gen = 1:genMax  
        % 适应度函数（这里假设A、B、C、D已给定）  
        fitness = calculateFitness(pop, A, B, C, D);  
          
        % 选择操作  
        pop = select(pop, fitness);  
          
        % 交叉操作  
        pop = crossover(pop);  
          
        % 突变操作  
        pop = mutate(pop);  
    end  
      
    % 返回Q和R矩阵的解  
    Q = pop(:, 1:2);  
    R = pop(:, 3:4);  
end 

function cost = calculateCostFunction(A, B, C, D, Q, R)  
    % 这里计算代价函数的值  
    % 具体计算方式取决于您的系统矩阵和代价函数定义  
    cost = sum(sum(abs(A*Q*R + B*R + C*Q + D)));  
end

% 适应度函数（根据实际系统矩阵计算代价函数的负值）  
function fitness = calculateFitness(pop, A, B, C, D)  
    Q = pop(:, 1:2);  
    R = pop(:, 3:4);  
    % 这里计算代价函数的负值，具体计算方式取决于您的系统矩阵和代价函数定义  
    fitness = -calculateCostFunction(A, B, C, D, Q, R);  
end  
  
% 选择操作（轮盘赌选择）  
function newPop = select(pop, fitness)  
    totalFitness = sum(fitness);  
    p = cumsum(fitness/totalFitness); % 累计概率  
    r = rand(1, size(pop, 1)); % 随机数  
    newPop = zeros(size(pop));  
    for i = 1:size(pop, 1)  
        [~, idx] = min(abs(r - p)); % 找到最接近的累计概率的索引  
        newPop(i, :) = pop(idx, :); % 选择染色体  
        r = r + 1/length(r); % 更新随机数  
    end  
end  
  
% 交叉操作（单点交叉）  
function newPop = crossover(pop)  
    % 随机选择两个染色体进行交叉  
    idx1 = randi([1, size(pop, 1)]);  
    idx2 = randi([1, size(pop, 1)]);  
    if idx1 ~= idx2  
        crossPoint = randi([1, size(pop, 2) - 1]); % 随机选择交叉点位置  
        newPop(idx1, :) = [pop(idx1, 1:crossPoint), pop(idx2, crossPoint+1:end)]; % 子代1的染色体由父代1的前部分和父代2的后部分组成  
        newPop(idx2, :) = [pop(idx2, 1:crossPoint), pop(idx1, crossPoint+1:end)]; % 子代2的染色体由父代2的前部分和父代1的后部分组成  
    else  
        newPop = pop; % 如果两个染色体相同，则不进行交叉，直接复制父代染色体到子代中  
    end  
end  
  
% 突变操作（均匀突变）  
function newPop = mutate(pop)  
    % 在每个染色体的每个基因上以一定概率进行突变（这里假设突变概率为0.01）  
    mutRate = 0.01; % 突变率  
    newPop = pop;  
    for i = 1:size(pop, 1)  
        for j = 1:size(pop, 2)  
            if rand < mutRate % 如果发生突变，则用新值替换当前基因值（这里假设新值是介于0和1之间的随机数）  
                newPop(i, j) = round(rand); % 用新值替换当前基因值（这里假设新值是介于0和1之间的随机数）  
            end  
        end  
    end  
end