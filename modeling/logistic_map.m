%% Logistic Map Function
% Returns a chaos sequence of length no_bits
% Growth is constant and equals four.
% Author: Omar T. Amer
% Date 11/12/2023

function chaos = logistic_map(seed, no_bits)
    % Seed
    seed_word_len = no_bits;
    seed_frac_len = no_bits;
    
    % Product
    prod_frac_len = 2*seed_frac_len;
    prod_word_len = 2*seed_frac_len;
    
    chaos = [];
    
    value = fi(seed, 0,...
               seed_word_len,...
               seed_frac_len);
           
    fmath = fimath('ProductFractionLength', prod_frac_len,...
                   'ProductWordLength', prod_word_len,...
                   'SumWordLength', seed_word_len,...
                   'SumFractionLength', seed_word_len,...
                   'SumMode', 'KeepLSB');
               
    value.fimath = fmath;
    
    % Reject Values that kill the sequence:
    if (value.hex == "00" | value.hex == "ff")
        value.hex = "aa";
    end
    
    one = fi(1, 0, seed_word_len, seed_frac_len);
    one.fimath = fmath;
    
    one_minus_val = one - value;
    one_minus_val.fimath = fmath;
    
    mul_res = fi (NaN, 1, prod_word_len, prod_frac_len);

    
    val_reintr = fi (NaN, 1, seed_word_len, seed_frac_len);
    new_type = numerictype(1, seed_word_len, seed_frac_len);
    
    while length(chaos) < 2*no_bits
        val_reintr = reinterpretcast(value, new_type);
        one_minus_val_reintr = reinterpretcast(one_minus_val, new_type);
        mul_res = val_reintr * one_minus_val_reintr;
        mul_res.SumWordLength = prod_word_len;
        mul_res.SumFractionLength = prod_frac_len;
        
        value = bitsll(mul_res, 2); 
        
        chaos = [chaos, value.bin];
    end
    chaos = chaos(1:2*no_bits);
end