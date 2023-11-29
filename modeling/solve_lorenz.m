%% Lorenz System Solver
% This function solves the Lorenz chaotic system using Euler's method.
% The goal here is to make the result as chaotic as possible. Accuracy
% matters only little.
% Author: Omar T. Amer
% Date 11/14/2023


function chaos_bits = solve_lorenz(init_point, time_step, sigma, r, beta, no_bits_req)
    % init_point         : (x, y, z) <= Inital Point
    % time_step          : Euler step size
    % sigma, r, and beta : Lorenz system parameters
    % no_bits_req        : Required number of chaos bits.
    
    chaos_bits = [];
    int_width = 2;
    frac_width = 8;
    num_width = int_width + frac_width;
    
    x = fi (init_point(1), 1, num_width, frac_width);
    y = fi (init_point(2), 1, num_width, frac_width);
    z = fi (init_point(3), 1, num_width, frac_width);
    
    time_step_frac_width = 8;
    time_step = fi(time_step, 0, time_step_frac_width, time_step_frac_width);
    sigma = fi(sigma, 0, 4, 0);
    r = fi(r, 0, 5, 0);
    beta = fi(beta, 0, 6, 4);
    
    F = fimath('ProductMode', 'SpecifyPrecision');
    F.ProductWordLength = int_width + frac_width;
    F.ProductFractionLength = frac_width;
    
    x.fimath = F;
    y.fimath = F;
    z.fimath = F;
    
    while length(chaos_bits) < no_bits_req
        next_x = x + time_step * sigma *(y - x);
        next_y = y + time_step * (r*x - x*z - y);
        next_z = z + time_step * (x*y - beta*z);
        
        x = next_x;
        y = next_y;
        z = next_z;
        
        chaos_bits = [chaos_bits, x.bin, y.bin, z.bin];
        
    end
    
    
    chaos_bits = chaos_bits(1:no_bits_req);
    
end