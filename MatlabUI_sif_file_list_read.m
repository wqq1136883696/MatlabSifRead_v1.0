function [fileNames,size]=MatlabUI_sif_file_list_read(fileFolder)
%作用：    读取sif文件列表
%     
%输入：    文件夹路径
% 
%输出：    后缀名为sif的文件名和文件的个数

    % 所要读取的文件夹路径
    %fileFolder = 'H:\Group_Work\Wyatt_Experiment\Heterojunction\Heterojunction2\1_20181106\Linear_Polarization_Excitation\1_Monolayer_MoTe2';

    % 读取的文件夹内的sif的文件
    dirOutput=dir(fullfile(fileFolder,'*.sif'));
    % 取出文件名，是一个cell类型的数组
    fileNames={dirOutput.name}';
    % 读出文件的个数
    size = length(fileNames);
end