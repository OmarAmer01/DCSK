%% Logistic Map Function Testbench
% This file tests the fixed point representation against the randomness
% of the function.
% Author: Omar T. Amer
% Date 11/14/2023

clc
clear

no_bits = 16;
no_tsts_per_seed = 2;
shuffler = readmatrix('rand_wires.txt');
z1_score_arr = zeros(1, 99);
z1_score_per_seed = [];
%% Single Seed. Expand afterwards.
run_idx = 1;
for seed = 0.01:0.01:0.99
    for seed_test = 1:1:no_tsts_per_seed
        chaos_bits = logistic_map(seed, no_bits);
        xpanded = chaos_expander(chaos_bits, shuffler);
        z1_score_per_seed = [z1_score_per_seed, z1test(xpanded)];
    end
    
    z1_score_arr(run_idx) = mean(z1_score_per_seed);
    z1_score_per_seed = [];
    run_idx = run_idx + 1;
end

[max_val, max_ind] = max(z1_score_arr);
max_seed = 0.01 * max_ind;

[min_val, min_ind] = min(z1_score_arr);
min_seed = 0.01 * min_ind;

avg = mean(z1_score_arr);

%% Running Mode

value = 0.05;

chaos = '';
for idx = 1:1:10
    chaos_to_add = logistic_map(value, 16);
    value = fi(NaN, 1, 8, 7);
    value.bin = chaos_to_add(1:8);
    xpanded = chaos_expander(chaos_to_add, shuffler);
    chaos = [chaos, xpanded-48];
end
score = z1test(double(chaos));
fprintf("Running Mode Score = %f\n", score);
%% Plot

result = table([NaN; min_seed; max_seed], [avg; min_val; max_val]);
result.Properties.VariableNames = ["Seed","01 Test Score"];
result.Properties.RowNames = {'Mean';'Min';'Max'};
result.Properties.Description = 'Run for all seeds.';
disp(result)

plot (0.01:0.01:0.99, z1_score_arr);








