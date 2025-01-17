function [overshoot, to] = calculateOvershoot(y, target)
    % calculateOvershoot calculates the overshoot and the time of occurrence.
    %
    % Inputs:
    %   y      - Response array of the system.
    %   target - Target value of the response (e.g., steady-state value).
    %
    % Outputs:
    %   overshoot - Maximum overshoot as a percentage of the target value.
    %   to        - Index of the time of maximum overshoot.

    % Find the maximum response and its index
    [maxValue, to] = max(y);
    
    % Calculate overshoot as a percentage of the target value
    overshoot = ((maxValue - target) / target) * 100;
end