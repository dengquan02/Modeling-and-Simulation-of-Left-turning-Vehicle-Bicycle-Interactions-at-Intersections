tic;
%��ȡ���ݣ��������
%��ÿ���켣���Ӧ�Ļ������ͷǻ���������ŵ�ͬһ����,14��
[N1]=xlsread('E:\Prediction_of_BIM\Data_Preparing������\data_SH.xlsx',1);
[E1]=xlsread('E:\Prediction_of_BIM\Data_Preparing������\data_SH.xlsx',2);
[N1V]=xlsread('E:\Prediction_of_BIM\Data_Preparing������\data_SH.xlsx',3);
[E1V]=xlsread('E:\Prediction_of_BIM\Data_Preparing������\data_SH.xlsx',4);
[S]=xlsread('E:\Prediction_of_BIM\Data_Preparing������\data_SH.xlsx',5);

Num_No=60;%�����ķǻ���������ĸ�����Ŀǰ�ǰ��վ�����̵ļ���,�ο�����6����
Num_V=20;%�����Ļ���������
n_input=20;%����������켣�����
intrusion_cood_E = csvread('intrusion_cood_E.csv');%��ȡ����������׼��Ϣ����ʾ��׼�����꣬���������Ӧ�����ĸ��㣬����·��������ʱ���������£��ֱ������ϡ����¡����ϡ����µ�˳�򣬺�����-������
%��Ҫ�궨�Ĳ���
% char_intrusion = 200;%����Σ�նȵĲ���
% M = 100;%ȡ�õ�����ֵ���㹻�������
% frequency_NV = 10^5;%��������������
long = 4.5;%�ǻ����������� ԭ����5
short = 2.5; %�ǻ������̰���  ԭ����3
% char_end = 6;%�յ㸴�ӶȵĲ���
% char_NV = 5;%�ǻ������Ĳ���
% char_V = 5;%�������Ĳ���
long_V = 5.5;%������������
short_V = 3.5;%�������̰���
% NV_index = 0.9;%�ǻ�����Σ�նȶ���ָ����0-1֮��
% V_index = 0.9;%������Σ�նȶ���ָ����0-1֮��
% index_end = 2;%����Σ�յĵĲ���
% % long_Per = 1.8;%��֪����
% % short_Per = 0.8;%��֪����
% benchmark_risk = 120 ;%��׼����ֵ
% perception_Radius = 0.3;%��֪Բ�ΰ뾶
% max_acc = 0.06;%�����ٶ�

%����Ҫ�궨�Ĳ���
perception_time = 20;%��֪�������򳤶�,��������

%�궨��Ĳ���
char_intrusion = OPT(1);
M = OPT(2);
char_end = OPT(3);
char_NV = OPT(4);
char_V = OPT(5);
NV_index = OPT(6);
V_index = OPT(7);
index_end = OPT(8);
max_excur = OPT(9);


%%%ȥ����ͬ����
[E1] = same_out(E1);
[E1V] = same_out(E1V);
[N1] = same_out(N1);
[N1V] = same_out(N1V);
[S] = same_out(S);

%����ͼ
figure(1)%��ͼ
scatter(E_straight(:,2),E_straight(:,3),'.','b')
% hold on
% scatter(N1(:,2),N1(:,3),'.','r')

%%%�ҵ�ֱ�зǻ�����
[E_straight] = find_straight(E1,35,60,15,40,-10,10,20,40);
[N_straight] = find_straight(N1,0,20,40,60,0,20,0,20);


%%%%%%%��E��N�����������������%%%%%%%
[NVinterract,Vinterract] = DATA_merge (E1,N1,E1V,N1V,S);%%DATA merge
%����ȫ�ֱ���
global trajectory_block;
global E_trajectory;
[E_trajectory] = data_handle(E_straight,NVinterract,Vinterract,Num_No,Num_V,1);%��ԭʼ���ݴ����Ū���������� ,���һ�����ֱ�ʾ�켣��0�ĸ������ܳ���������
[N_trajectory] = data_handle(N_straight,NVinterract,Vinterract,Num_No,Num_V,1);%
% scatter(E_trajectory(:,4),E_trajectory(:,5),'.','b')
%������ͼ
benchmark_E = csvread('benchmark_E.csv');%��ȡ��׼��Ϣ
% csvwrite('benchmark_E.csv',benchmark_E);%��ȡ��׼��Ϣ
[trajectory_block,trajectory_no] = trajectory_divide(E_trajectory,27,55);%����Ϊ���źͷǸ���,ֻҪ������������һ��  ��������������޺����ޣ�����55��Ϊ��ֻɸѡ���·�Խ�ߵ�
% [EL_co] = elliptical_index(E_trajectory,e,angle);%��֤��̬����������ԲΣ���������ȷ�ԣ�EL_co��ŷʽ����Ľ�������
% [~] = inter(trajectory_block,benchmark_E,Num_No,Num_V);%��ͼ




%�����궨
�����궨������


%�������ʽ���Ǽ����������Ŀ͹�Σ�նȣ���δ��֪��
[aim_danger_NV,aim_danger_int,aim_danger_end,aim_danger_V] = Risk_each(intrusion_cood_E,M,frequency_NV,long,short,long_V,short_V,char_intrusion,char_end,char_NV ,char_V,NV_index,V_index,index_end);


��ȡ���ļ��ǵ������

block_cal;%�ű���Ԥ�����ֹ켣
all_cal;%�ű���Ԥ��ȫ���켣  ��0.3�Ĳ��Լ�

disp(['MAX=',num2str(max(DIS(:,3)))])
disp(['Mean=',num2str(mean(DIS(:,3)))])
disp(['Min=',num2str(min(DIS(:,3)))])
% max(Plo)
% Plo = sort(Plo,descend);
% max(lo)
% hist(Plo)
% hist(lo)
% lo(find(lo>0.1))=[];
% hist(all_risk(:,7))

toc
disp('The job is done!!!')


