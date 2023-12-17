% Generate a grid of x and y values
[x, y] = meshgrid(linspace(-10, 10, 100));

% Evaluate a 2D Gaussian function on the grid
sigma = 3;
heatmap = exp(-((x - 1).^2 + (y - 2).^2) / (2 * sigma^2));

% Visualize the original heatmap
figure;
surf(x, y, heatmap);
title('Original heatmap');

% Rotation angle in degrees
theta = 30;

% Convert the angle to radians
theta_rad = deg2rad(theta);

% Create the rotation matrix
R = [cos(theta_rad), -sin(theta_rad);
     sin(theta_rad), cos(theta_rad)];

% Rotate the x and y values
rotated_coords = [x(:), y(:)] * R;

% Re-evaluate the heatmap function on the rotated coordinates
rotated_x = reshape(rotated_coords(:, 1), size(x));
rotated_y = reshape(rotated_coords(:, 2), size(y));
rotated_heatmap = exp(-((rotated_x - 1).^2 + (rotated_y - 2).^2) / (2 * sigma^2));

% Visualize the rotated heatmap
figure;
surf(rotated_x, rotated_y, rotated_heatmap);
title('Rotated heatmap');
