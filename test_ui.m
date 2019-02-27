clear;clc;
path = 'H:\Group_Work\Wyatt_Experiment\Raman_Spectroscopy\20181207\Processed';
[fileNames,size] = MatlabUI_sif_file_list_read(path);
 S = regexp(fileNames(1), '\.', 'split');
 a = S{1}(1)
 