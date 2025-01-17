function tr = calculateRisingTime(e, t, rising)
    % calculateRisingTime calculates the rising time of a system response.
    %
    % Inputs:
    %   e       - Array of error values (response - target value or normalized response)
    %   t       - Array of time values corresponding to the response
    %   rising  - Rising threshold (e.g., 0.1 for 10%)
    %
    % Output:
    %   tr      - Rising time (time when the response first reaches the threshold)
    
    % Define bounds for the rising region
    boundsris = [-rising rising];
    
    % Find indices where the response is within the rising range
    [x, ~] = find((e <= boundsris(2) & e >= boundsris(1)));
    
    % If the response never enters the rising range, return NaN
    if isempty(x)
        tr = NaN;
        return;
    end
    
    % Rising time is the first time the response reaches the bounds
    tr = t(min(x));
end
