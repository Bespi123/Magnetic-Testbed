function [overshoot, to] = calculateOvershoot(y, target)
    % Calculate overshoot and time of occurrence for multiple signals (vectorized).
    %
    % Inputs:
    %   y      - Response matrix (N x M), where each column is a signal.
    %   target - 1 x M array of target values for each signal.
    %
    % Outputs:
    %   overshoot - 1 x M array of overshoot percentages for each signal.
    %   to        - 1 x M array of indices of the maximum overshoot for each signal.
    
    % Find maximum values and their indices for each column
    [maxValues, to] = max(y, [], 1); % Max along rows for each column
    
    % Calculate overshoot as a percentage of the target
    overshoot = ((maxValues - target) ./ target) * 100;
end
