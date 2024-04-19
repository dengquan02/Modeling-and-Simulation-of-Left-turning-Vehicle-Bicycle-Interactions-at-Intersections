function [mean_dis] = fitting(X)
char_intrusion = X(1);
M = X(2);
char_end = X(3);
char_NV = X(4);
char_V = X(5);
NV_index = X(6);
V_index = X(7);
index_end = X(8);
max_excur = X(9);

% disp('start data_handle');
% tic
% char_intrusion = 200.1;%����Σ�նȵĲ���
% M = 100.1;%ȡ�õ�����ֵ���㹻�������
long = 4.5;%�ǻ����������� ԭ����5
short = 2.5; %�ǻ������̰���  ԭ����3
% char_end = 6.1;%�յ㸴�ӶȵĲ���
% char_NV = 5.1;%�ǻ������Ĳ���
% char_V = 5.1;%�������Ĳ���
long_V = 5.5;%������������
short_V = 3.5;%�������̰���
% NV_index = 0.9;%�ǻ�����Σ�նȶ���ָ����0-1֮��
% % V_index = 0.9;%������Σ�նȶ���ָ����0-1֮��
% index_end = 2.1;%����Σ�յĵĲ���
% long_Per = 1.8;%��֪����
% short_Per = 0.8;%��֪����
% perception_Radius = 0.3;%��֪Բ�ΰ뾶
% max_excur = 0.7;%������ƫ�ƾ���
tic
frequency_NV = 10^5;%��������������
global trajectory_block;
global ID;
% global all_ID;
% trajectory_block = csvread('trajectory_block.csv');%��ȡ
% ID = csvread('ID.csv');%��ȡ
intrusion_cood_E = [47.43 27;47.43 23.5;3 27;3 23.5];
%����͹۷���ֵ
[aim_danger_NV,aim_danger_int,aim_danger_end,aim_danger_V] = Risk_each(intrusion_cood_E,M,frequency_NV,long,short,long_V,short_V,char_intrusion,char_end,char_NV ,char_V,NV_index,V_index,index_end);
% all_dis = 0;%���Ӿ���
diss = [];%���еľ���
step = 20;%Ԥ�ⲽ��
for i = 1:size(ID,2)%����ÿһ���켣
    %����ÿ����ĸ�֪���շֲ� extract_one���Ǹ��Ż�������ֻ�Ǹ����������
    extract_one = trajectory_block((trajectory_block(:,1)==ID(i)),:);%��ȡ��ǰ�켣
%     ID_in = all_ID(i,:);%��ȡ��i���켣�Ĺ켣�����
    for j =1:step:size(extract_one,1)-step%����ÿһ���켣�㣬Ԥ��20����
        perception_Radius = extract_one(1,10)/3.6*0.12/2;%���ݵ�ǰ�ļ����һ�������ľ��룬������ɢ��뾶  extract_one(1,10)
        [prediction_point,Risk] = Excur_predict(extract_one(j,:),aim_danger_NV,aim_danger_int,aim_danger_end,aim_danger_V,intrusion_cood_E,perception_Radius,perception_Radius,perception_Radius,step,max_excur);
        dis = mean(sqrt((((extract_one(j:j+step,4)-prediction_point(:,1)).^2)+((extract_one(j:j+step,4)+prediction_point(:,2)).^2))));%�������ֵ
        diss = [diss;dis];
%         figure(1)
%         scatter(extract_one(j:j+step,4),extract_one(j:j+step,5),'*','b');%���ӻ�
%         hold on
%         scatter(prediction_point(:,1),prediction_point(:,2),'*','r');%���ӻ�
    end
%     disp(['fitting�����',num2str(i/size(ID,2)*100),'%']);  %disp(['fitting�����',num2str(i/trajectory_block(size(trajectory_block,1),1)*100),'%']);
end
toc
mean_dis = mean(diss);
disp(['fitting = ',num2str(mean_dis)])
end

