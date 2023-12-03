%% Chaos Expander Testbench
% This script verifies the output csv file from the SystemVerilog
% testbench.
% Author: Omar T. Amer
% Date 12/01/2023

clear
clc
%% Read the CSV file.

csv_path = "..\ver\modulator\hdl_model_xpnd.csv";
fid = fopen(csv_path, 'r');

format_spec = '%s,%s';

hdl_results = readmatrix(csv_path, 'OutputType', 'string')


%% Compare with MATLAB's output
shuffler_array = readmatrix("rand_wires.txt");

for i = 1:1:2^16
    input = dec2bin(hex2dec(hdl_results{i}), 16);
    hdl_result = hdl_results {i + 2^16};
    
    model_result = chaos_expander(input, shuffler_array);
    % Define the chunk size
    chunk_size = 4;

    % Split the binary string into chunks
    chunks = cellstr(reshape(strrep(num2str(model_result), ' ', ''), chunk_size, [])');

    % Convert each chunk to hexadecimal
    hex_chunks = cellfun(@(chunk) dec2hex(bin2dec(chunk), numel(chunk) / 4), chunks, 'UniformOutput', false);

    % Concatenate the hexadecimal chunks
    model_result = cat(2, hex_chunks{:}); % Meow
    err_msg = sprintf("[FAIL] Test %d\nFound %s\nExpected %s\nINPUT: %x", i, hdl_result, model_result, input);
    if (strcmpi(model_result, hdl_result))
        disp("[PASS]")
    else
        disp(err_msg)
    end
end
