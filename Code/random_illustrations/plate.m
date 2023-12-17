% Define the disc properties
center = [0, 0];
radius = 3;
num_points_radial = 20; % Number of points along the radial direction
num_points_angular = 50; % Number of points along the angular direction

% Create the radial and angular coordinates
r = linspace(0, radius, num_points_radial);
theta = linspace(0, 2 * pi, num_points_angular);

% Convert to Cartesian coordinates using meshgrid
[R, Theta] = meshgrid(r, theta);
X = center(1) + R .* cos(Theta);
Y = center(2) + R .* sin(Theta);

% Plot the points in green
figure;
scatter(X(:), Y(:), 'g');
axis equal;
xlim([-radius, radius] + center(1));
ylim([-radius, radius] + center(2));
title('Disc in Cartesian Coordinates');
