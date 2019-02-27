%��ȡsif�ļ��������asc�ļ�
clear;
clc;

% ��Ҫ��ȡ���ļ���·��
fileFolder = 'H:\Group_Work\Wyatt_Experiment\Heterojunction\Heterojunction\1_20181106\��Ƶ�ź�\6 MO';

% ��ȡ���ļ����ڵ�sif���ļ�
dirOutput=dir(fullfile(fileFolder,'*.sif'));
% ȡ���ļ�������һ��cell���͵�����
fileNames={dirOutput.name}';
strFileName = string(fileNames);
% �����ļ��ĸ���
size = length(fileNames);

% ���ζ����ļ����һ�ͼ�����ұ����txt�ļ�
for i = 1:size
    % �õ��������ļ�������һ��cell����
    cell_file_path = fullfile(fileFolder,fileNames(i));
    % �ı��char��ʽ����Ϊ�±ߵ�read_sif����ֻ�ܽ���char���͵Ĳ���
    char_file_path = char(cell_file_path);
    
    figure(i)
    % ���ú�������sif�ļ�
    [pattern,calibvals,data] = read_sif(char_file_path);
    datas(i,1) = max(data);
    
    % ��ȡ�ļ���
    charFileName = char(strFileName(i));
    name = charFileName(1:end-4);
    number(i,1) = str2double(name);
end