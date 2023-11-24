%% Spreading Factor Effect
% In this file, we plot the Lorenz system.
% For aesthetic reasons only.
% Author: Omar T. Amer
% Date 11/14/2023

clc
clear

% Input parameters
time_step = 1/256
sigma = 10
r = 28
beta = 8/3

no_of_points = 5760;

x_arr = zeros(1, no_of_points);
y_arr = zeros(1, no_of_points);
z_arr = zeros(1, no_of_points);

x = 1
y = 1
z = 1


% Plot
figure;
color_map = lines(no_of_points);
pause(5)
lorenz_sol_plot = scatter3(x_arr(:), y_arr(:), z_arr(:), 10, 'filled');
%title("Lorenz System Solution");
xlim([-25 25])
ylim([-30 30])
zlim([-1 60])
grid off
axis vis3d
axis off
lorenz_sol_plot.CData = color_map;
set(gcf,'color','k');
set (gca, 'Colormap', color_map);


numFrames = 60;

for point = 1:1:no_of_points
    next_x = x + time_step * sigma *(y - x);
    next_y = y + time_step * (r*x - x*z - y);
    next_z = z + time_step * (x*y - beta*z);
    
    x = next_x;
    y = next_y;
    z = next_z;
    
    x_arr(point) = x;
    y_arr(point) = y;
    z_arr(point) = z;
    
    title(['\color{white}Frame: ' num2str(point) '/' num2str(no_of_points)]);
    set(lorenz_sol_plot, 'XData', x_arr(:), 'YData', y_arr(:), 'ZData', z_arr(:));
    view (point/4, 30)
    drawnow
end
