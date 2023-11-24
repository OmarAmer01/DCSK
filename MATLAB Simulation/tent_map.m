%% Tent Map
% Tent map function with mu = 2;
% Author: Omar T. Amer
% Date 11/12/2023

function chaos_bits = tent_map(seed, no_bits)
    chaos_bits = [];
    
    xn = seed;
    while length(chaos_bits < no_bits)
        if (xn < 0.5)
            xn_plus1 = 2 * fi(xn);
        else
            xn_plus1 = fi(1-xn) * 2;
        end
        chaos_bits = [chaos_bits, xn_plus1];
    end
        chaos_bits = (1:no_bits);
end