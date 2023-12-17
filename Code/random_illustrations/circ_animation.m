% Define grid using linspace
x = linspace(-8, 8, 41);
y = linspace(-8, 8, 41);
[X, Y] = meshgrid(x, y);

% Create a random heatmap with most of its density around the point (-3, 5)
center = [-3, 5];
sigma = 1;
heatmap = exp(-((X - center(1)).^2 + (Y - center(2)).^2) / (2 * sigma^2));

% Set up the figure for animation
figure;
axis equal;
hold on;
xlim([-8 8]);
ylim([-8 8]);
colormap('jet');

% Create a surface plot object for the heatmap
surface_handle = surf(X, Y, heatmap, 'EdgeColor', 'none');
view(2); % Set the view to 2D

% Calculate the target angle for rotation
target_angle = atan2(center(2), center(1));

% Set the angle increment per frame
angle_increment = 2 * pi / 100;

% Initialize the current angle
current_angle = 0;

% Loop through frames and update the heatmap position
while current_angle < target_angle
    % Update the current angle
    current_angle = current_angle + angle_increment;

    % Create the rotation matrix
    R = [cos(angle_increment), sin(angle_increment);
         -sin(angle_increment),  cos(angle_increment)];

    % Rotate the grid points around the origin
    rotated_points = R * [X(:)'; Y(:)'];
    X_rotated = reshape(rotated_points(1, :), size(X));
    Y_rotated = reshape(rotated_points(2, :), size(Y));

    % Update the heatmap position in the plot
    set(surface_handle, 'XData', X_rotated, 'YData', Y_rotated);

    % Update the plot title
    title(sprintf('Current Angle: %.2f rad', current_angle));

    % Pause to control the animation speed
    pause(0.01);

    % Update the grid for the next iteration
    X = X_rotated;
    Y = Y_rotated;
end
