function [Potential_trajectory_allData_output] = Anti_normalizating_NEW(Potential_trajectory_allData,perception_time,mmax,mmin)
% ����һ��  ���������խ����  ���ȥ�Ļ���խ����

% csvwrite('mmax(20210831_1).csv',mmax);%д�����ֵ����
% csvwrite('mmin(20210831_1).csv',mmin);%д����Сֵ����

%% �������
% mmax = csvread('mmax(20210831_1).csv');%�����ֵ����
% mmin = csvread('mmin(20210831_1).csv');%����Сֵ����
N_lengh_point = size(mmax,2);%��ȡ������

%% ��ʼ����
% Potential_trajectory_allData_1 = reshape(Potential_trajectory_allData',N_lengh_point,[])';%���խ����  N_lengh_point����������
[Potential_trajectory_allData_output,~] = Anti_normalizating(Potential_trajectory_allData,Potential_trajectory_allData,mmax,mmin); %����һ����tt_t��ʾ��ֵ��yy_y��ʾԤ�⣬���ȥ����խ����
% Potential_trajectory_allData_output = reshape(Potential_trajectory_allData_2',(N_lengh_point*perception_time),[])';%�任��״,��ɿ����


end