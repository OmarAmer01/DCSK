%% Spreading Factor Effect
% In this file, we test the effect of increasing the spreading factor
% on the BER in an AWGN channel.
% Using Logistic Map as a chaos generator
% Author: Omar T. Amer
% Date 11/12/2023

clc
clear
fimath('MaxProductWordLength', 65535);

% Input parameters
const_spreading_factor = 12;
SNR = 0; % DB
growth = 4;
num_trials_per_point = 50;
num_runs = 8;

%Repeat the experiment for different lengths of input bitstreams
ber_const_spread_factor = zeros(1, num_runs);
x_axis = zeros(1, num_runs);
for run = 1:1:num_runs
    BER = zeros(1, num_trials_per_point);
    for trial = 1:1:num_trials_per_point
        input_bitstream = randi([0 1], 1, bitsll(8, run));
        chaos_bitstream = logistic_map(growth, 0.4, length(input_bitstream) * const_spreading_factor );
        tx = dcsk_modulate(chaos_bitstream, input_bitstream, const_spreading_factor );
        noisy_tx = awgn(tx, SNR);
        rx = dcsk_demod(noisy_tx, const_spreading_factor );
        BER(trial) = biterr(rx, input_bitstream) * 100 / length(rx);
    end
    ber_const_spread_factor(run) = mean(BER);
    x_axis(run)= bitsll(8, run);
end

% Repeat the experiment for different spreading factors [LOGISTIC MAP]
% msg_len = 64;
% ber_const_msg_len = zeros(1, num_runs);
% x_axis_sprd = zeros(1, num_runs);
% for run = 1:1:num_runs
%     BER = zeros(1, num_trials_per_point);
%     spreading_factor = 10 * run;
%     for trial = 1:1:num_trials_per_point
% 
%         input_bitstream = randi([0 1], 1, msg_len);
%         chaos_bitstream = logistic_map(growth, 0.4, length(input_bitstream) * spreading_factor);
%         tx = dcsk_modulate(chaos_bitstream, input_bitstream, spreading_factor);
%         noisy_tx = awgn(tx, SNR);
%         rx = dcsk_demod(noisy_tx, spreading_factor);
%         BER(trial) = biterr(rx, input_bitstream) * 100 / length(rx);
%     end
%     ber_const_msg_len(run) = mean(BER);
%     x_axis_sprd(run)= spreading_factor;
% end

% Repeat the experiment for different spreading factors [LORENZ]
% msg_len = 64;
% ber_const_msg_len_lorenz = zeros(1, num_runs);
% x_axis_sprd = zeros(1, num_runs);
% for run = 1:1:num_runs
%     BER = zeros(1, num_trials_per_point);
%     spreading_factor = 10 * run;
%     for trial = 1:1:num_trials_per_point
% 
%         input_bitstream = randi([0 1], 1, msg_len);
%         chaos_bitstream = solve_lorenz([1 1 1], 1/64, 10, 28, 8/3, length(input_bitstream) * spreading_factor);
%         tx = dcsk_modulate(chaos_bitstream, input_bitstream, spreading_factor);
%         noisy_tx = awgn(tx, SNR);
%         rx = dcsk_demod(noisy_tx, spreading_factor);
%         BER(trial) = biterr(rx, input_bitstream) * 100 / length(rx);
%     end
%     ber_const_msg_len_lorenz(run) = mean(BER);
%     x_axis_sprd(run)= spreading_factor;
% end

%% Plot
%subplot(2, 1, 1)
bar(1:1:num_runs, ber_const_spread_factor, 'EdgeColor', [1 1 1]);
title_str = sprintf("BER Vs. Input Length | Spreading Factor = %d | SNR = %.2f dB", const_spreading_factor, SNR);
title(title_str)
set(gca,'XTickLabel',x_axis)
ylabel("BER %")
xlabel("Information Bits Length (Bits)")

% bar(1:1:num_runs, [ber_const_msg_len; ber_const_msg_len_lorenz] , 'EdgeColor', [1 1 1]);
% legend("Logistic Map", "Lorenz")
% title_str = sprintf("BER Vs. Spreading Factor | Input Length = %d bits | SNR = %.2f dB", msg_len ,SNR);
% title(title_str)
% set(gca,'XTickLabel',x_axis_sprd)
% ylabel("BER %")
% xlabel("Spreading Factor")

% subplot(2, 1, 2)
% bar(1:1:num_runs, ber_const_msg_len_lorenz, 'EdgeColor', [1 1 1]);
% title_str = sprintf("BER Vs. Spreading Factor | Input Length = %d bits | SNR = %.2f dB\nLorenz", msg_len ,SNR);
% title(title_str)
% set(gca,'XTickLabel',x_axis_sprd)
% ylabel("BER %")
% xlabel("Spreading Factor")
