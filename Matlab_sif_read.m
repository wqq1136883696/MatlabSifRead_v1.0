function Matlab_sif_read(fileFolder)
%读取sif文件，保存成asc文件(还没有实现保存功能)

% 所要读取的文件夹路径
% fileFolder = 'H:\Group_Work\Wyatt_Experiment\Heterojunction\Heterojunction2\1_20181106\Linear_Polarization_Excitation\1_Monolayer_MoTe2';

% 读取的文件夹内的sif的文件
dirOutput=dir(fullfile(fileFolder,'*.sif'));
% 取出文件名，是一个cell类型的数组
fileNames={dirOutput.name}';
% 读出文件的个数
size = length(fileNames);

% 依次读出文件并且画图，并且保存成txt文件
for i = 1:size
    % 得到完整的文件名，是一个cell类型
    cell_file_path = fullfile(fileFolder,fileNames(i));
    % 改变成char格式，因为下边的read_sif函数只能接受char类型的参数
    char_file_path = char(cell_file_path);
    
    figure(i)
    % 调用函数，打开sif文件
    [pattern,calibvals,data] = read_sif(char_file_path);
end
end