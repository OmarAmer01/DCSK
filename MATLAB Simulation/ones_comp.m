%% Bitwise Not
% Author: Omar T. Amer
% Date 11/12/2023

function complement = ones_comp(bits)
    complement = bits;
    complement(complement-48 == 0) = '2';
    
    complement(complement-48 == 1) = '0';
    complement(complement-48 == 2) = '1';
end