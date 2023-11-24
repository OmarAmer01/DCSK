%% Wire Shuffle
% This file outputs a text file that has a random mapping of wirings
% to shuffle the bits of the expanded chaotic sequence. This text file
% can then be used as an array in Verilog and in MATLAB.
% Author: Omar T. Amer
% Date 11/19/2023

rand_wires = randperm(256)-1;
%rand_wires = reshape(rand_wires, 16, 16)'; % For readability.
writematrix(rand_wires, 'rand_wires.txt');
