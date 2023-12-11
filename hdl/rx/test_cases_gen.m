word_length = 32;
number_of_words = 10;
information_matrix = zeros(number_of_words,word_length);
for i=1:number_of_words
    word_value = randi(2^word_length-1);
    information_matrix(i,:)=de2bi(word_value,word_length);
end
for Spreading_Factor=[2,4,8,16]
    input_data = zeros(word_length*number_of_words,2*Spreading_Factor);
    for j=1:number_of_words
        for i=1:word_length
            chaos_seq=randi(2^Spreading_Factor-1);
            bit_chaos=de2bi(chaos_seq,Spreading_Factor);
            mod_bit = not(xor(information_matrix(j,i),bit_chaos));
            input_data((j-1)*word_length+i,:) = [mod_bit bit_chaos];
        end
    end
    directory = 'E:\AUC_projects\DCSK-main\DCSK-main\hdl\demodulator';
    filename = sprintf('Input_Data_Beta_%d.txt', Spreading_Factor);
    fullFilePath = fullfile(directory, filename);
    fileID = fopen(fullFilePath, 'w');
    for i = 1:size(input_data, 1)
        fprintf(fileID, '%d ', input_data(i, :));
        fprintf(fileID, '\n');
    end
    fclose(fileID);
end
directory = 'E:\AUC_projects\DCSK-main\DCSK-main\hdl\demodulator';
filename = 'Information_Data.txt';
fullFilePath = fullfile(directory, filename);
fileID = fopen(fullFilePath, 'w');
for i = 1:size(information_matrix, 1)
    fprintf(fileID, '%d ', information_matrix(i, :));
    fprintf(fileID, '\n');
end
fclose(fileID);
