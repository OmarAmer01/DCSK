%% Periodicity Checker

% This script calculates the periods of all subsequences in a given HEX
% sequence. Returns a cell array with the the number and length of
% subsequences that include an element.

% Author: Omar T. Amer
% Date: 12/05/2023

function periods = periodicity_checker(hex_cell_vect)
    
    periods = {};
    unique_elements = unique(hex_cell_vect);
    for idx = 1:1:numel(unique_elements)
        
        indicies = find (string(unique_elements(idx)) == string(hex_cell_vect));
        period_lengths = [];
        for j = numel(indicies):-1:2
            period_lengths = [period_lengths, indicies(j)-indicies(j-1)];
        end
        periods(idx, 1) = unique_elements(idx);
        periods(idx, 2) = {numel(period_lengths)};
        
        

        
    end
end