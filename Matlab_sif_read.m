function Matlab_sif_read(fileFolder)
%��ȡsif�ļ��������asc�ļ�(��û��ʵ�ֱ��湦��)

% ��Ҫ��ȡ���ļ���·��
% fileFolder = 'H:\Group_Work\Wyatt_Experiment\Heterojunction\Heterojunction2\1_20181106\Linear_Polarization_Excitation\1_Monolayer_MoTe2';

% ��ȡ���ļ����ڵ�sif���ļ�
dirOutput=dir(fullfile(fileFolder,'*.sif'));
% ȡ���ļ�������һ��cell���͵�����
fileNames={dirOutput.name}';
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
end
end