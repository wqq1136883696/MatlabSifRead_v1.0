function [fileNames,size]=MatlabUI_sif_file_list_read(fileFolder)
%���ã�    ��ȡsif�ļ��б�
%     
%���룺    �ļ���·��
% 
%�����    ��׺��Ϊsif���ļ������ļ��ĸ���

    % ��Ҫ��ȡ���ļ���·��
    %fileFolder = 'H:\Group_Work\Wyatt_Experiment\Heterojunction\Heterojunction2\1_20181106\Linear_Polarization_Excitation\1_Monolayer_MoTe2';

    % ��ȡ���ļ����ڵ�sif���ļ�
    dirOutput=dir(fullfile(fileFolder,'*.sif'));
    % ȡ���ļ�������һ��cell���͵�����
    fileNames={dirOutput.name}';
    % �����ļ��ĸ���
    size = length(fileNames);
end