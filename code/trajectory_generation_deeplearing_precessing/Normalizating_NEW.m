function [Complete_Data_odPoints_output] = Normalizating_NEW(Complete_Data_odPoints,N_points,mmax,mmin)
% ����һ��  ��������ǿ����  ���ȥ�Ļ��ǿ����

% csvwrite('mmax(20210831_1).csv',mmax);%д�����ֵ����
% csvwrite('mmin(20210831_1).csv',mmin);%д����Сֵ����

% %% �������
% mmax = csvread('mmax(20210831_1).csv');%�����ֵ����
% mmin = csvread('mmin(20210831_1).csv');%����Сֵ����
N_lengh_point = size(mmax,2);%��ȡ������

%% �任��״
Complete_Data_odPoints_1 = reshape(Complete_Data_odPoints',N_lengh_point,[])';%���խ����  N_lengh_point����������

%% ��ʼ����
Complete_Data_odPoints_2 = zeros(size(Complete_Data_odPoints_1,1),size(Complete_Data_odPoints_1,2));%�趨ռλ
for i = 1:size(Complete_Data_odPoints_1,1)
    for j = 1:N_lengh_point
        Complete_Data_odPoints_2(i,j) = (Complete_Data_odPoints_1(i,j)-mmin(j)) / (mmax(j)-mmin(j));%��ȡ���ֵ
    end
end
%% �ٴα任��״
Complete_Data_odPoints_output = reshape(Complete_Data_odPoints_2',(size(Complete_Data_odPoints,2)),[])';%�任��״,��ɿ����


end