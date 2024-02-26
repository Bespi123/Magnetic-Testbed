function [Q, R] = geneticAlgorithm(A, B, C, D)  
    % �Ŵ��㷨����  
    popSize = 100; % ��Ⱥ��С  
    chromLength = 4; % Ⱦɫ�峤�ȣ��������Q��R����2x2����  
    genMax = 100; % ����������  
      
    % ��ʼ����Ⱥ  
    pop = round(rand(popSize, chromLength));  
      
    % ��ѭ��  
    for gen = 1:genMax  
        % ��Ӧ�Ⱥ������������A��B��C��D�Ѹ�����  
        fitness = calculateFitness(pop, A, B, C, D);  
          
        % ѡ�����  
        pop = select(pop, fitness);  
          
        % �������  
        pop = crossover(pop);  
          
        % ͻ�����  
        pop = mutate(pop);  
    end  
      
    % ����Q��R����Ľ�  
    Q = pop(:, 1:2);  
    R = pop(:, 3:4);  
end 

function cost = calculateCostFunction(A, B, C, D, Q, R)  
    % ���������ۺ�����ֵ  
    % ������㷽ʽȡ��������ϵͳ����ʹ��ۺ�������  
    cost = sum(sum(abs(A*Q*R + B*R + C*Q + D)));  
end

% ��Ӧ�Ⱥ���������ʵ��ϵͳ���������ۺ����ĸ�ֵ��  
function fitness = calculateFitness(pop, A, B, C, D)  
    Q = pop(:, 1:2);  
    R = pop(:, 3:4);  
    % ���������ۺ����ĸ�ֵ��������㷽ʽȡ��������ϵͳ����ʹ��ۺ�������  
    fitness = -calculateCostFunction(A, B, C, D, Q, R);  
end  
  
% ѡ����������̶�ѡ��  
function newPop = select(pop, fitness)  
    totalFitness = sum(fitness);  
    p = cumsum(fitness/totalFitness); % �ۼƸ���  
    r = rand(1, size(pop, 1)); % �����  
    newPop = zeros(size(pop));  
    for i = 1:size(pop, 1)  
        [~, idx] = min(abs(r - p)); % �ҵ���ӽ����ۼƸ��ʵ�����  
        newPop(i, :) = pop(idx, :); % ѡ��Ⱦɫ��  
        r = r + 1/length(r); % ���������  
    end  
end  
  
% ������������㽻�棩  
function newPop = crossover(pop)  
    % ���ѡ������Ⱦɫ����н���  
    idx1 = randi([1, size(pop, 1)]);  
    idx2 = randi([1, size(pop, 1)]);  
    if idx1 ~= idx2  
        crossPoint = randi([1, size(pop, 2) - 1]); % ���ѡ�񽻲��λ��  
        newPop(idx1, :) = [pop(idx1, 1:crossPoint), pop(idx2, crossPoint+1:end)]; % �Ӵ�1��Ⱦɫ���ɸ���1��ǰ���ֺ͸���2�ĺ󲿷����  
        newPop(idx2, :) = [pop(idx2, 1:crossPoint), pop(idx1, crossPoint+1:end)]; % �Ӵ�2��Ⱦɫ���ɸ���2��ǰ���ֺ͸���1�ĺ󲿷����  
    else  
        newPop = pop; % �������Ⱦɫ����ͬ���򲻽��н��棬ֱ�Ӹ��Ƹ���Ⱦɫ�嵽�Ӵ���  
    end  
end  
  
% ͻ�����������ͻ�䣩  
function newPop = mutate(pop)  
    % ��ÿ��Ⱦɫ���ÿ����������һ�����ʽ���ͻ�䣨�������ͻ�����Ϊ0.01��  
    mutRate = 0.01; % ͻ����  
    newPop = pop;  
    for i = 1:size(pop, 1)  
        for j = 1:size(pop, 2)  
            if rand < mutRate % �������ͻ�䣬������ֵ�滻��ǰ����ֵ�����������ֵ�ǽ���0��1֮����������  
                newPop(i, j) = round(rand); % ����ֵ�滻��ǰ����ֵ�����������ֵ�ǽ���0��1֮����������  
            end  
        end  
    end  
end