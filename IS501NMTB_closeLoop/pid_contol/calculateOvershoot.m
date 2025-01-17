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
    
    % Initialize overshoot
    overshoot = zeros(1, size(y, 2));
    
    % Handle cases where target is zero
    zeroTarget = (target == 0);
    if any(zeroTarget)
        % For zero target, overshoot is just the maximum value as a percentage
        overshoot(zeroTarget) = maxValues(zeroTarget) * 100;
    end
    
    % Handle non-zero targets
    nonZeroTarget = ~zeroTarget;
    if any(nonZeroTarget)
        overshoot(nonZeroTarget) = ((maxValues(nonZeroTarget) - target(nonZeroTarget)) ./ target(nonZeroTarget)) * 100;
    end
end

