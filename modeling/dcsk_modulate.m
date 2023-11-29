%% DCSK Modulator
% Modulate chaos_bitstream with information_bitstream with a spreading
% factor of spreading_factor.
% Author: Omar T. Amer
% Date 11/12/2023

function tx = dcsk_modulate(chaos_bitstream,information_bitstream,spreading_factor)  
    no_of_chips = spreading_factor;
    no_of_info_bits = length(information_bitstream);
    tx = [];
    
    % This is the index of the chaos bitstream
    chaos_selector = 1;
    
    for i = 1:1:no_of_info_bits
        bit = information_bitstream(i);
        to_add = chaos_bitstream(chaos_selector : chaos_selector+ no_of_chips-1);
        chaos_selector = chaos_selector + no_of_chips;

        if (bit == 0)
            negative_chaos = ones_comp(to_add);
            frame = [to_add, negative_chaos];
        else
            frame =  [to_add, to_add];
        end
        
        tx = [tx, frame];

    end
    tx = double(tx-48); % From ASCII to binary
    tx(tx == 0) = -1; % NRZ
end