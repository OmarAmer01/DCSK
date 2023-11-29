%% Logistic Map Function
% Returns a chaos sequence of length no_bits
% Growth is constant and equals four.
% Author: Omar T. Amer
% Date 11/12/2023
function chaos = logistic_map(seed, no_bits)
    integer_part_length = 1;
    fractional_part_length = 7;
    chaos = [];  
    value = fi(seed, 1, integer_part_length + fractional_part_length, fractional_part_length);
    if (value >= .9)
        value = bitcmp(value);
        value.bin(end) = '0';
    end
    while length(chaos) < no_bits
        value = bitsll(value * (1-value), 2); 
        chaos = [chaos, value.bin];
        value = fi(value, 1, integer_part_length + fractional_part_length, fractional_part_length); 
    end
    chaos = chaos(1:no_bits);
end