function [h1, h2] = plotVector(v0, v, scale, style, label, labelLocation) 
    % plotVector - Function to plot a 3D vector from a given starting point.
    %
    % Syntax: [h1, h2] = plotVector(v0, v, scale, style, label, labelLocation)
    %
    % Inputs:
    %   v0 - Starting point of the vector (3-element vector).
    %   v  - Direction and magnitude of the vector (3-element vector).
    %   scale - Scale factor to adjust the length of the vector.
    %   style - Line style for the vector plot (e.g., color and line type).
    %   label - Text label for the vector.
    %   labelLocation - Determines where to place the label ('m' for middle, otherwise at the end).
    %
    % Outputs:
    %   h1 - Handle to the quiver plot (vector).
    %   h2 - Handle to the text label.

    % Check if the label should be placed in the middle of the vector
    if labelLocation == 'm'
        % Increase scale slightly for label positioning
        scale = scale * 1.1; 
        
        % Create a 3D quiver plot for the vector starting at v0 and extending in direction v
        h1 = quiver3(v0(1), v0(2), v0(3), v(1) * scale, v(2) * scale, v(3) * scale, style);
        
        % Place the label at the midpoint of the vector
        h2 = text(v0(1) + v(1) * scale / 2, v0(2) + v(2) * scale / 2, v0(3) + v(3) * scale / 2, label, 'Color', style(1));
    else
        % Create a 3D quiver plot for the vector from the scaled position of v0
        h1 = quiver3(v0(1) * scale, v0(2) * scale, v0(3) * scale, v(1) * scale, v(2) * scale, v(3) * scale, style);
        
        % Place the label at the end of the vector
        h2 = text((v0(1) + v(1)) * scale, (v0(2) + v(2)) * scale, (v0(3) + v(3)) * scale, label, 'Color', style(1));
    end
    
    %% Set equal axis scales and display grid
    axis equal; % Set equal scaling for all axes to maintain the proportions of the vector
    grid on;    % Turn on the grid for better visualization
end
