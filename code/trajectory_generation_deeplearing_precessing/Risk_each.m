function [aim_danger_NV,aim_danger_int,aim_danger_end,aim_danger_V] = Risk_each(intrusion_cood_E,M,frequency_NV,long,short,long_V,short_V,char_intrusion,char_end,char_NV ,char_V,NV_index,V_index,index_end)
%����ÿ�����ֵ�Σ�նȣ�ֻ��Ҫ����һ�Σ����ڽ��е��þ��У���Ҫ�����ݴ�ã�
%����
% intrusion_cood_E = csvread('intrusion_cood_E.csv');%��ȡ����������׼��Ϣ����ʾ��׼�����꣬���������Ӧ�����ĸ��㣬����·��������ʱ���������£��ֱ������ϡ����¡����ϡ����µ�˳�򣬺�����-������
% char_intrusion = 100;%����Σ�նȵĲ���
% M = 100;%ȡ�õ�����ֵ���㹻�������
% frequency_NV = 10^6;%��������������
% long = 5;%�ǻ�����������
% short = 3; %�ǻ������̰���
% char_end = 10;%�յ㸴�ӶȵĲ���
% char_NV = 1;%�ǻ������Ĳ���
% char_V = 1;%�������Ĳ���
% long_V = 8;%������������
% short_V = 6;%�������̰���
%��������������������ֵ������

%���������Σ�նȷֲ�
[aim_danger_NV,~] = Monte_Carlo_NV(long,short,M,char_NV,frequency_NV,NV_index);%�������ؿ���ģ����㶯̬���������Σ�նȣ���������Ϊ0,0��,��Ҫ���벻���Ķ���λ�úͽǶȽ��л��㣻
[aim_danger_int,~] = Monte_Carlo_intrusion(intrusion_cood_E,char_intrusion,M,frequency_NV,long,short);%�����������������Σ�նȣ�����ԭ���������Ƿָ�㣬����ǻ�����Ͷ�����������Ϊ�ܶ�һ�������пɼ���
[aim_danger_end,~] = Monte_Carlo_end(intrusion_cood_E,char_end,M,frequency_NV,long,short,index_end);%��������յ��Σ�նȣ�������ԭ���ǳ��ڵ����Ƿָ���
[aim_danger_V,~] = Monte_Carlo_V(long_V,short_V,long,short,M,char_V,frequency_NV,V_index);%��������Σ�ն�
% [~] = Risk_Heat_map([aim_danger_end]);
% [~] = Risk_Heat_map([aim_danger_int]);
% scatter3(aim_danger_NV(:,1),aim_danger_NV(:,2),aim_danger_NV(:,3),'.','r');
% scatter(aim_danger_end(:,1),aim_danger_end(:,3),'.','r');
% scatter3(aim_danger_int(:,1),aim_danger_int(:,2),aim_danger_int(:,3),'.','r');
%����Σ�նȽ���
end