function [output] = Complete_feature_ODpoints(start_point,end_point,extract_one,perception_time)
% �������ݰ��������յ㼰���������Լ� Ԥ��ʱ��
% �Ǳ�ѵ����ȷ������֮������ٽ�������Ե��޸ģ�

%% ���޸�
% %�о�����
% precessing_test1 = [extract_one(4:9) extract_one(14) extract_one(15:20) extract_one(25)];
% 
% t = (perception_time - 1)*0.12;%��������ʱ��
% Host_S_start_test =  extract_one(4:5);  %���λ��
% Host_V_start_test =  extract_one(6:7);  %����ٶ�
% Host_A_start_test =  extract_one(8:9);%�����m/s   �����ٶ�
% 
% Host_S_end_test =  end_point;  %�յ�λ��
% Host_V_end_test = (2 .*(Host_S_end_test - Host_S_start_test)./t) - Host_V_start_test; %�õ������ٶȾ���
% Host_V_end_test = Host_V_start_test + Host_A_start_test.*t;
% A_mean_test = (Host_V_end_test - Host_V_start_test)./t;%������ٶȣ���һ���ϵ�ƽ�����ٶ�
% Host_A_end_test = A_mean_test*2 - Host_A_start_test;%����õ����յļ��ٶ�
% 
% %��������  ������о�����  ����Ϊ+n
% Inter_S_start_test =  extract_one(1,15:16);  %���λ��
% Inter_V_start_test =  extract_one(1,17:18);%�����m/s
% Inter_A_start_test =  extract_one(1,19:20);
% 
% Inter_A_end_test = Inter_A_start_test;%���ٶȲ���
% Inter_V_end_test = t.*Inter_A_start_test + Inter_V_start_test;%�ٶȰ��պ���ٶȼ���
% Inter_S_end_test = Inter_S_start_test + Inter_V_start_test * t+ 0.5.*Inter_A_end_test.*t.^2;%���ٶ�ģ�ͼ���
% 
% %��ֵ
% test_output1 = precessing_test1;%�����о�������״ �ͽ���������״
% test_output1 = [test_output1 Host_S_end_test Host_V_start_test Host_A_start_test extract_one(14)];%����о������յ�λ�� ,�ٶȺͼ��ٶȣ��ٶȺͼ��ٶȾ��ǳ�ʼ״̬�� 
% test_output1 = [test_output1 Inter_S_end_test Inter_V_end_test Inter_A_end_test extract_one(25)];%���轻�������λ�� �ٶȺͼ��ٶ�
% 
% output = test_output1;

%% ԭ���� ���о�������д���x��y����ͬʱ����  �����Ǻ���ٶ�ģ��
V0 = extract_one(1,6:7);%�����m/s
t = (perception_time - 1)*0.12;%��������ʱ��
A0 = extract_one(1,8:9);%�о�����ļ��ٶ�
A_mean = ((end_point - start_point) - V0.*t).*2./(t^2);   %����s=0.5*a*t^2+V0*t�������
Vt = (A_mean*t) + V0;  %����Vt=V0+a*t
At = A_mean*2 - A0;%����õ����յļ��ٶ�   ����A_mean = (AT+A0)/2

%% �Խ���������д���  ���ٶȲ��䣬�ٶȲ��䣬λ�ð���CAģ�ͼ���
inter_Data = extract_one(1,15:25);%��ȡһ���������󣨵�1����
A_inter_Data = inter_Data(1,5:6);%5:6Ӧ���Ǽ��ٶȵ����� �����ٶȲ���ֱ�Ӹ���
V_inter_Data =  t.*A_inter_Data;%�����ʽ�Ǵ�ģ����Ǵ�ʽ����ȥ��ķ��������Щ��   ����ٶ����ٶ�   %2021.11.24�ǣ� V_inter_Data = inter_Data(1,3:4);%�ٶȲ���    V_inter_Data =  inter_Data(1,3:4) + t.*A_inter_Data;%����ٶ����ٶ�  
P_inter_Data =  V_inter_Data.*t + 0.5.*A_inter_Data.* t^2;%�����ʽ�Ǵ�ģ����Ǵ�ʽ����ȥ��ķ��������Щ��   ���ݺ���ٶ�ģ�ͼ����,����·��    P_inter_Data = inter_Data(1,1:2) + V_inter_Data.*t + 0.5.*A_inter_Data.* t^2;%���ݺ���ٶ�ģ�ͼ����,����·��
inter = [P_inter_Data V_inter_Data A_inter_Data];


% P_inter_Data = inter_Data(1,1:2) + inter_Data(1,3:4) * t ;%���ݺ��ٶ�ģ�ͼ����,����·��
% inter = [P_inter_Data inter_Data(1,3:4) A_inter_Data];
%% ��ֵ
x_output = [extract_one(1,4:9) extract_one(1,14)];%��������о�������Ϣ
x_output = [x_output extract_one(1,13)]
x_output = [x_output inter_Data(1,1:6) inter_Data(1,11)];%������㽻��������Ϣ
x_output = [x_output extract_one(1,24)]
x_output = [x_output end_point Vt At extract_one(1,14)];%�����յ��о�������Ϣ   %2021.11.24�ǣ� x_output = [x_output end_point V0 A0 extract_one(1,14)];%�����յ��о�������Ϣ    %x_output = [x_output end_point Vt At extract_one(1,14)];%�����յ��о�������Ϣ
x_output = [x_output extract_one(1,13)]
x_output = [x_output inter inter_Data(1,11)]; %�����յ㽻��������Ϣ
x_output = [x_output extract_one(1,24)]

output = x_output;


end