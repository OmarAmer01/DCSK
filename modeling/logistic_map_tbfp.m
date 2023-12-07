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
for seed = 0:1:255
    for seed_test = 1:1:no_tsts_per_seed
        chaos_bits = logistic_map(seed/256, no_bits);
        xpanded = chaos_expander(chaos_bits, shuffler);
        z1_score_per_seed = [z1_score_per_seed, z1test(xpanded)];
    end
    
    z1_score_arr(run_idx) = mean(z1_score_per_seed);
    z1_score_per_seed = [];
    run_idx = run_idx + 1;
    clc
    fprintf('Single Seed :[%d/255] Tests Complete.\n', seed);
end

[max_val, max_ind] = max(z1_score_arr);
max_seed = max_ind/256;

[min_val, min_ind] = min(z1_score_arr);
min_seed = min_ind/256;

avg = mean(z1_score_arr);

%% Running Mode

value = 0.5;

chaos = [];

for idx = 1:1:50
    % Generate 16 Bits of Chaos
    chaos_to_add = logistic_map(value, 16);
    
    % Take only 8 bits to start the next iteration
    value = fi(NaN, 0, 8, 8);
    value.bin = chaos_to_add(1:8); % Take MSB
    %value.bin = chaos_to_add(9:16); % Take LSB

    xpanded = chaos_expander(chaos_to_add, shuffler);
    chaos = [chaos, xpanded];
    clc
    fprintf('Running Mode :[%d/50] Iterations Complete.\n', idx);
end
score = z1test(double(chaos));

%% Plot

result = table([NaN; min_seed; max_seed], [avg; min_val; max_val]);
result.Properties.VariableNames = ["Seed","01 Test Score"];
result.Properties.RowNames = {'Mean';'Min';'Max'};
result.Properties.Description = 'Run for all seeds.';
disp(result)

fprintf("Running Mode Score (1000 Iterations) = %f\n", score);
plot (0:1/256:255/256, z1_score_arr);








