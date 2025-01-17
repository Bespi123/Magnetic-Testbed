function ts = calculateSettlementTime(e, t, tol)
    % calculateSettlementTime calculates the settling time of a system response.
    %
    % Inputs:
    %   e   - Array of error values (response - desired value)
    %   t   - Array of time values corresponding to the response
    %   tol - Tolerance for the settling band (e.g., 0.02 for 2%)
    %
    % Output:
    %   ts - Settling time (time when the response enters and stays within
    %        the bounds defined by the tolerance)
    
    % Set bounds for the settling region
    bounds = [-tol tol];
    
    % Find indices where the error is outside the bounds
    [x, ~] = find(~(e < bounds(2) & e > bounds(1)));
    
    if isempty(x) || x(end) == length(t)
        % If the error never settles or is out of range at the last point
        ts = NaN;
    else
        % Find the last time the error was outside the bounds
        ts = t(max(x));
    end
end
