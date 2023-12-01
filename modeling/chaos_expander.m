%% Chaos Expander
% Uses a chaos sequence retrieved from solving the logistic map
% to modulate it self with a spreading factor of length(chaos_sequence),
% meaning that it recieves an input of length x and outputs a sequence of
% x^2.
% Author: Omar T. Amer
% Date 11/16/2023

function expanded_chaos = chaos_expander(chaos_bitstream, shuffler_array)
    % Use the chaos to modulate the chaos.
    original_length = length(chaos_bitstream);
    expanded_chaos = [];
    original_chaos = fi(NaN, 0, original_length, 0);
    original_chaos.bin = chaos_bitstream;
    
    for bit = 1:1:original_length
        if original_chaos.bin(bit) == '0'
            expanded_chaos = [expanded_chaos, bitcmp(original_chaos).bin];
        else
            expanded_chaos = [expanded_chaos, original_chaos.bin];
        end
            %expanded_chaos(bit*16) = chaos_bitstream(bit);        
    end
   
    shuffled_chaos = zeros(1, length(expanded_chaos));
    % Shuffle the expanded chaos
    for bit_idx = 1:1:length(expanded_chaos)
        shuffled_chaos(shuffler_array(bit_idx)+1) = expanded_chaos(bit_idx);
    end
    expanded_chaos = shuffled_chaos-48;