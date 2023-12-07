%% Chaos Expander
% Uses a chaos sequence retrieved from solving the logistic map
% to modulate it self with a spreading factor of length(chaos_sequence),
% meaning that it recieves an input of length x and outputs a sequence of
% x^2.
% Author: Omar T. Amer
% Date 11/16/2023

function [shuffled_chaos,expanded_chaos] = chaos_expander(chaos_bitstream, shuffler_array)
    % Use the chaos to modulate the chaos.
    original_length = length(chaos_bitstream);
    expanded_chaos = [];
    original_chaos = fi(NaN, 0, original_length, 0);
    original_chaos.bin = chaos_bitstream;
    
    for bit = original_length:-1:1
        if original_chaos.bin(bit) == '0'
            expanded_chaos = [bitcmp(original_chaos).bin, expanded_chaos];
        else
            expanded_chaos = [original_chaos.bin, expanded_chaos];
        end
            %expanded_chaos(bit*16) = chaos_bitstream(bit);        
    end
   
    shuffled_chaos = zeros(1, length(expanded_chaos));
    % Shuffle the expanded chaos
    for bit_idx = 1:1:length(expanded_chaos)
        shuffled_chaos(255-shuffler_array(bit_idx)+1) = expanded_chaos(256-bit_idx+1);
        %shuffled_chaos(shuffler_array(bit_idx)+1) = expanded_chaos(256-bit_idx+1);
    end
    expanded_chaos = (expanded_chaos-48);
    shuffled_chaos = (shuffled_chaos-48);
    