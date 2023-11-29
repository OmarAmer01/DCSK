%% DCSK Demodulator
% Demodulate the incoming bitstream with a spreading factor of
% spreading_factor
% Author: Omar T. Amer
% Date 11/12/2023

function rx = dcsk_demod(recv_bitstream, spreading_factor, int, frac)
    frame_len = spreading_factor*2;
    no_of_frames = length(recv_bitstream) / frame_len;
    rx = [];

    frame_counter = 1;
    
    correlation = fi(NaN, 1, int+frac, frac);
    
    for i = 1:1:no_of_frames
        frame = recv_bitstream(frame_counter : frame_counter + frame_len-1);
        frame_counter = frame_counter + frame_len;

        ref_signal = frame(1:end/2);
        modulated_sig = frame((end/2)+1 : end);

        F = fimath('ProductMode', 'SpecifyPrecision');
        F.SumMode = 'SpecifyPrecision';
        F.SumWordLength = int+frac;
        F.SumFractionLength = frac;
        F.ProductWordLength = int + frac;
        F.ProductFractionLength = frac;

        ref_signal.fimath = F;
        modulated_sig.fimath = F;
        correlation.fimath = F;
        correlation = sum(modulated_sig .* ref_signal);
        bit = sign(correlation);
        rx = [rx, bit];
    end
    rx (rx == -1) = 0;
end
