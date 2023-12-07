%% Chaos Expander Testbench
% This script generates all 2^16 expansions of an 8-bit number and puts them
% in a CSV file.

% Author: Omar T. Amer
% Date 12/01/2023

clear
clc

%% Generate Expansions
num_cases = 2^16;
result_arr = cell(num_cases, 3);
shuffler_matrix = readmatrix('rand_wires.txt');

for num = 1:1:num_cases
    [shuffled, xpanded] = chaos_expander(dec2bin(num-1, 16), shuffler_matrix);
    
    xpanded = num2str(xpanded);
    xpanded(xpanded == ' ') = '';
    hex_xpanded_fi = fi (NaN, 0, 256, 0);
    hex_xpanded_fi.bin = xpanded;
    hex_xpanded = hex_xpanded_fi.hex;
     
    
    
    
    shuffled= num2str(shuffled);
    shuffled(shuffled == ' ') = '';
    hex_shuffled_fi = fi (NaN, 0, 256, 0);
    hex_shuffled_fi.bin = shuffled;
    hex_shuffled = hex_shuffled_fi.hex;
    
    hex_num = dec2hex(num-1,4);
    
    result_arr{num, 1} = hex_num;
    result_arr{num, 2} = hex_xpanded;
    result_arr{num, 3} = hex_shuffled;
    
    clc
    fprintf("[%d/%d] Cases Generated.", num, num_cases);
end

fprintf("\nGenerating Output File: xpander.csv\n");
result_arr = cell2table(result_arr);
writetable(result_arr, "xpander.csv", 'Delimiter', ',', 'WriteVariableNames', false);
fprintf("xpander.csv Generated. Exiting.\n");

