%% Logistic Map IO Table Generator

% Author: Omar T. Amer
% Date 12/3/2023

clear
clc

bin2hex8 = @(x) dec2hex( bin2dec(x), 8);
bin2hex4 = @(x) dec2hex( bin2dec(x), 4);
bin2hex2 = @(x) dec2hex( bin2dec(x), 2);

% Parameters:
INPUT_CHAOS_SIZE = 8;
TEST_1_ITER = 256;
TEST_2_ITER = 256;
%% Test 1: Single Seed.
% Generates the mapping for all seeds.

result_single_seed = cell(TEST_1_ITER, 2);

for i = 1:1:TEST_1_ITER
    result_single_seed {i, 1} = dec2bin((i-1), INPUT_CHAOS_SIZE);
    result_single_seed {i, 2} = logistic_map((i-1)/2^INPUT_CHAOS_SIZE, INPUT_CHAOS_SIZE);
end

%% Save Test 1 Result
if (INPUT_CHAOS_SIZE == 8)
    log_map_hex = cellfun(bin2hex4, result_single_seed(:, 2), 'UniformOutput', false);
    stim_hex = cellfun(bin2hex2, result_single_seed(:, 1), 'UniformOutput', false);
else
    log_map_hex = cellfun(bin2hex8, result_single_seed(:, 2), 'UniformOutput', false);
    stim_hex = cellfun(bin2hex4, result_single_seed(:, 1), 'UniformOutput', false);
end

final_result = [stim_hex log_map_hex];
result_table = cell2table(final_result);
writetable(result_table, "lmap_table.csv", 'Delimiter', ',', 'WriteVariableNames', false);


%% Test 2: Running Mode.
% Generates the first 16 mappings for a single seed.

seed = 0xba;
result_running_mode = cell(TEST_2_ITER, 1);
seed = double(seed) / 2^INPUT_CHAOS_SIZE;

value = fi(seed, 0, INPUT_CHAOS_SIZE, INPUT_CHAOS_SIZE);

for i = 1:1:TEST_2_ITER
    chaos_to_add = logistic_map(value, INPUT_CHAOS_SIZE);
    result_running_mode{i} = chaos_to_add;


    next_val = chaos_to_add(1:INPUT_CHAOS_SIZE);
    value.bin = next_val;
end

%% Save Test 2 Result

if (INPUT_CHAOS_SIZE == 8)
    running_mode = cellfun(bin2hex4, result_running_mode, 'UniformOutput', false);
else
    running_mode = cellfun(bin2hex8, result_running_mode, 'UniformOutput', false);
end

running_mode = cell2table(running_mode);
writetable(running_mode, "lmap_run.csv", 'Delimiter', ',', 'WriteVariableNames', false);

%% Test 3: Periodicity:
    
periods = periodicity_checker(table2array(running_mode));
periods = cell2table(periods);
periods.Properties.VariableNames = {'Word', 'Number Of Subsequences'};

%% Save Test 3 Result

writetable(periods, "periodicity.csv", 'Delimiter', ',', 'WriteVariableNames', true);

disp(periods)