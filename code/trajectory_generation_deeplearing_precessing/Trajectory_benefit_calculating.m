function [output,output1,output2,output_dis,output_risk,sum_Dis_Path] = Trajectory_benefit_calculating(Potential_trajectory)
%Trajectory_benefit_calculating 
%�ú�������������켣��Ч��ģ���������������Ĺ켣�㣨ͨ����һ�������ѧϰ���ɣ�������ǹ켣Ч��ֵ
%output�ǹ켣Ч�棻output1�ǹ켣�����ꣻoutput2�ǹ켣����

% �����������
% generating_lengh = 9; %generating_lengh��ʾÿ����֪���յ�����ɹ켣����
perception_time = size(Potential_trajectory,1); %Ԥ�ⳤ��


%%  ���ݹ켣λ�ü���Ч��ֵ

%��������Ǹ������׸����ı궨�������������char_end��char_intrusion��index_end
% threshold_Risk = 2;G=0.01;R_b = 1;k1 = 1;k3 = 0.05;char_intrusion = 2;char_end = 0.2;index_end = 2;
% M_b = 2000;
R_b = 1;
% k4=1.2;%Ŀ�꺯����Ȩ��

%��ȡ�궨��Ľ��
global Parameter
%threshold_Risk = Parameter(1);
G=Parameter(10);
k1=Parameter(1);k3=Parameter(2);char_intrusion=Parameter(3);char_end=Parameter(4);index_end=Parameter(5);k4=Parameter(6);
char_intrusion_right=Parameter(7);char_end_right=Parameter(8);index_end_right=Parameter(9);

%extract_oneʹ��һ���켣��һ֡
%intrusion_cood_E�ǻ�׼����
global extract_one


%%
global intrusion_cood_E
if extract_one(1,14) == 1%��̬��������ƫ��ϵ��  ���г�
    k4 = 0.5;%PPT�ϵĽ�����õ���4
elseif extract_one(1,14) == 2  %�綯��
    k4 = 0.4;%PPT�ϵĽ�����õ���3
end
% intrusion_cood_E = [47.43 27;47.43 23.5;3 27;3 23.5];

extract = extract_one;%Ԥ���֡
extract(:,1:3) = [];
extract = reshape(extract',11,[])';%�����11�е�
extract(all(extract==0,2),:)=[];%ȥ��ȫ0��,ʣ�µ���ÿ����������ģ���һ��������
%�Կ�����һ��Ԥ��
[extract_pre] = envir_pre(extract,perception_time);%���ٶ�ģ��Ԥ��perception_time��������extract��һ�������� �����ʽ��Ԥ�ⲽ��*����x����y
diss = [];%��¼�ľ���
Risk = [];%������ŷ���,��һ����Ԥ��㣬�ڶ�������ʵ��
Dis_Path = [];%����·��

all_points = Potential_trajectory;%��Ǳ�ڹ켣����all_points
%% �ٴμ���Ŀ�꣨�����켣�㣩
time_interv = 0.12 ;
for i = 1:size(all_points,1)-1%����ÿһ��������  
    extract_time_i = reshape(extract_pre(i,:)',2,[])';%����i�������ָ���n*2��ģʽ  i=1�ǵ�ǰʱ��
    extract_time_i = [extract_time_i extract(:,3:size(extract,2))];%����Ĳ�������Ԥ��ֵ��ʹ�����������ǻ�����Ϣ������������
    truth_Risk = Risk_calculation(all_points(i,:),extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,k1,k3,char_intrusion,char_end,index_end,char_intrusion_right,char_end_right,index_end_right);%���㵱ǰ��ķ��գ�
    Risk = [Risk;norm(truth_Risk)];
    %�����Ǽ�����գ������Ǽ������
    
    

    %�ж��Ƿ�����Լ������  �����ѭ��0103ע�͵��ģ���Ϊû�з�������ֵ
%     if norm(truth_Risk)>5%������ֵ������ֵ����һЩ�������������Ͻ��ܿ���
%        dis = 2;
%     end
%     if norm(Vio)>(25/3.6)%����ǰ�ٶȴ���25km/h�����ܸ�һ����ĳͷ�
%        dis = 2;
%     end
%     dis = [dis extract_trajectory(index_in+i,6)*0.12];%����ʵ�켣������Ž�ȥ

end
global endpoint_x
global endpoint_y
dis =sqrt((all_points(size(all_points,1),1)-endpoint_x)^2+(all_points(size(all_points,2),1)-endpoint_y)^2);%���������ǰ�������λ��,�����Ǹ�ֵ
disp(dis);
dis_path = dis;%������������·��
diss = [diss;dis];%����ǰʱ�̵�ǰ�������λ�Ƽӽ�ȥ
Dis_Path = [Dis_Path,dis_path];%·�̳���

%% ���Ŀ��ֵ
% output = output + (sum(hengxiang));
% output = output + k4*(sum(Risk(size(Risk,1),1)));%����ֻ�������һ����ķ���ֵ
% k4=0.1;  %k4=0.32;%�����渳��Ĳ�ͬ���Ͳ�ͬ��ֵ
output = (1-k4)*(sum(diss,1))+ (k4)*(mean(Risk(:,1)));%mĿ��ֵ    *sum(Dis_Path)  output = (1-k4)*(sum(diss(:,1)))/8 + (k4)*(mean(Risk(:,1)))*sum(Dis_Path)/(400)/8;%ǰ
% disp('Ŀ��ֵ��')
% disp(output)
% disp((sum(diss(:,1)))/8 );
% disp((mean(Risk(:,1)))*sum(1)/(4)/8)   %Dis_Path
% disp(norm(truth_Risk))
output1 = Potential_trajectory;%���Ԥ���
output2 = (mean(Risk(:,1)))*sum(1)/(4)/8;%���Ԥ�����  output2 = (mean(Risk(:,1)))*sum(Dis_Path)/(400)/8;%���Ԥ�����
% figure(10)
% [~] = risk_3D(extract_one(1,4:5),extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,k1,k3,char_intrusion,char_end,index_end,char_intrusion_right,char_end_right,index_end_right);%�����ճ���ͼ

%% ���λ�ƺͷ��պ��ٸ��ݱ�ѡ�켣����������й�һ��
output_dis = -(sum(diss,1));% ���ǰ�������λ��
disp(diss)
output_risk = (mean(Risk(:,1)))*sum(1);  %�������ֵ   Dis_Path   ��Exhaustion_Method�м����˷��յ�·�����أ��˴�ֻ����sum(1)
sum_Dis_Path = -sum(Dis_Path);%���·���ܺ�
end



