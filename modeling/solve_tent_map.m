%% Solve Tent Map
% Solve and plot tent map function with mu = 2;
% Author: Omar T. Amer
% Date 11/12/2023
clc
clear
fimath('MaxProductWordLength', 65535);


no_points = 100;
x_axis = linspace(0, 1, no_points);
y_axis = linspace(0, 1, no_points);
x = fi(0.314342, 1, 16, 14);

%hPlot = scatter(NaN, NaN);
% for point = 1 : 1 : no_points
%     next_x = tent_mu_2(x);
%     set(hPlot, 'XData', x, 'YData', next_x);
%     x = next_x;
%     y_axis(point) = x;
%     pause(0.1);
%     drawnow
% end

for point = 1:1:no_points
    new_x = tent_mu_2(x);
    x = new_x;
    disp(new_x.Value);
end

function next_point = tent_mu_2(point)
    next_point = 2 * min(point, 1-point);
end