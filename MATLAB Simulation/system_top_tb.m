%% System Top Level End-to-End Testbench
% End-to-end fixed point simulation of the system.
% Author: Omar T. Amer
% Date 11/18/2023

%% MATLAB Initializations
clear
clc

%% Step 0: System Parameters.
num_experiments = 100;
BER = zeros(1, num_experiments);
z1score = zeros(1, num_experiments);
message_len = 16; % Bits
seed = 0.7;
spreading_factor = 16;
SNR = 3; %dB
recv_correlator_int_len = 4;
recv_correlator_frac_len = 0;
shuffler_array = readmatrix('rand_wires.txt');

%% Step 1: Generate Information and Chaos.
for xpr = 1:1:num_experiments
    information = randi([0 1], 1, message_len);
    seed = fi(rand, 1, 8, 7);
    
    chaos = logistic_map(seed, 16);
    xpanded_chaos = chaos_expander(chaos, shuffler_array);
    z1score(xpr) = z1test(xpanded_chaos);
%% Step 2: Modulate Information with Chaos.
    modulated = dcsk_modulate(xpanded_chaos, information, spreading_factor);

%% Step 3: Send the Modulated Signal Over an AWGN Channel.
    tx = awgn(modulated, SNR);

%% Step 4: Demodulate the Received Signal.
    rx = fi(tx, 1, recv_correlator_frac_len+recv_correlator_int_len, recv_correlator_frac_len);
    recv_information = dcsk_demod(rx, spreading_factor, recv_correlator_int_len, recv_correlator_frac_len);

%% Step 5: Calculate the BER.
    BER(xpr) = biterr(recv_information, information) * 100/ message_len;

end

%% Step 6: Report
results_table = table(BER', z1score', 'VariableNames', ["BER", "Expanded Chaos 0-1 Test"]);

mean_ber = mean(table2array(results_table(:,1)));
mean_z1 = mean(table2array(results_table(:,2)));

min_ber = min(table2array(results_table(:,1)));
max_ber = max(table2array(results_table(:,1)));

min_z1 = min(table2array(results_table(:,2)));
max_z1 = max(table2array(results_table(:,2)));

result = table([mean_ber; min_ber; max_ber], [mean_z1; min_z1; max_z1]);
result.Properties.VariableNames = ["BER","01 Test Score"];
result.Properties.RowNames = {'Mean';'Min';'Max'};
disp(result)