
%Լ����������_�켣���ɵķ���
function [const,const2] = nonlcon_Complete_path(traj_points,perception_time)
% traj_points = Potential_trajectory ;
% ������Լ����const�ǲ���ʽԼ����const2�ǵ�ʽԼ��
%Լ������������������Լ�����ڼ��ٶ�Լ�������ٶ�Լ�����ܷ���Լ��
global extract_one  %׼����ȡ��ǰ״̬�µ�Լ��
Risk_constraint = 60;%��ʱԤ������60��ã������֪������15���Ȳ��� 21
Cur_constraint = 5;% max(0.16,extract_one(1,13));%�����ǽǶ���  ����������1��   5
lin_Angle_constraint = 5;%3;%10����ٶȺ͹켣�ǶȵĲ�ֵ3���Ƕ���  �Ϻõ�ʱ����10   20

if extract_one(1,14)==2%����2����Ϊ�綯��
    a_limit_V = 16.9;%�綯�����ٶ�ƽ��ֵ  16.9
    a_limit_a = 0.2703;%�綯���ļ��ٶ�ƽ��ֵ  0.2703   0.36��һЩ
elseif extract_one(1,14)==1%����1����Ϊ���г�
    a_limit_V = 11.4;%���г����ٶ�ƽ��ֵ11.4��
    a_limit_a = 0.05934;%���г��ļ��ٶ�ƽ��ֵ   0.05934    0.22��һЩ
end
speed_constraint = max(a_limit_V,extract_one(1,10));%mean([a_limit_V;extract_one(1,10)])+0.25;%+0.25max(a_limit_V,extract_one(1,10));%��λ��km/h    max(a_limit_V,extract_one(1,10));   %    mean([a_limit_V;extract_one(1,10)])+0.25
accle_constraint = 0.8;%mean([a_limit_a;abs(extract_one(1,11))])+0.1;%max(a_limit_a,extract_one(1,11))+0.05;%��λ��m/s^2   accle_constraint = max(a_limit_a,extract_one(1,11));%��λ��m/s^2
% Perception_interval = 0.4*2^0.5;

%mean([a_limit_a;abs(extract_one(1,11))])+0.1;
%%
% tic
%acc�յ�����
% acc = [-5 -3]  %�ٸ�����
% acc = OPT;
% perception_time = 17;
%��ʵ�켣
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

global intrusion_cood_E
if extract_one(1,14) == 1%��̬��������ƫ��ϵ��  ���г�
    k4 = 1*10^-1;%PPT�ϵĽ�����õ���4
elseif extract_one(1,14) == 2  %�綯��
    k4 = 0.2*10^-1;%PPT�ϵĽ�����õ���3
end
% intrusion_cood_E = [47.43 27;47.43 23.5;3 27;3 23.5];

extract = extract_one;%Ԥ���֡
extract(:,1:3) = [];
extract = reshape(extract',11,[])';%�����11�е�
extract(all(extract==0,2),:)=[];%ȥ��ȫ0��,ʣ�µ���ÿ����������ģ���һ��������
%% �Կ�����һ��Ԥ��
[extract_pre] = envir_pre(extract,perception_time);%���ٶ�ģ��Ԥ��perception_time��������extract��һ�������� �����ʽ��Ԥ�ⲽ��*����x����y
base_point = extract(1,1:2);%��׼��  �����

%% �������յ�
% ��ֵ
start_point = traj_points(1,:);
end_point = traj_points(size(traj_points,1),:);
% toc
%%
Risk = [];%������ŷ���,��һ����Ԥ��㣬�ڶ�������ʵ��
for i = 1:perception_time%����ÿһ��������,���ټ������������յ�
    extract_time_i = reshape(extract_pre(i,:)',2,[])';%����i�������ָ���n*2��ģʽ  i=1�ǵ�ǰʱ��
    extract_time_i = [extract_time_i extract(:,3:size(extract,2))];%����Ĳ�������Ԥ��ֵ��ʹ�����������ǻ�����Ϣ������������
    %��ȡ�켣��Ӧ�Ĺ켣�㣻
    truth_point = traj_points(i,1:2);%��ȡ�켣��Ӧ�Ĺ켣��λ�� ��Ϊ������յ�λ��
    truth_Risk = Risk_calculation(truth_point,extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,k1,k3,char_intrusion,char_end,index_end,char_intrusion_right,char_end_right,index_end_right);%���㵱ǰ��ķ��գ�
    %���������ʱctrl+r��,����12/24�ı������  ������������ʵ�켣�ķ���
%     real_Risk = Risk_calculation(extract_trajectory(index_in+i,4:5),extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,M_b,k1,k3,char_intrusion,char_end,index_end);%���㵱ǰ��ķ��գ�
%     Risk = [Risk;[norm(truth_Risk) norm(real_Risk)]];%��¼��ǰԤ������ʵ��ķ���ֵ
    Risk = [Risk;norm(truth_Risk)];
    %�ж��Ƿ�����Լ������  �����ѭ��0103ע�͵��ģ���Ϊû�з�������ֵ
%     if norm(truth_Risk)>11%������ֵ������ֵ����һЩ�������������Ͻ��ܿ���
%         disp(truth_Risk)
%        lin_Risk = 2;
%     end
%     if norm(Vio)>(25/3.6)%����ǰ�ٶȴ���25km/h�����ܸ�һ����ĳͷ�
%        dis = 2;
%     end
end
diss = end_point(1,1) - start_point(1,1);%����������յ��x����֮��
diss_one = (diss-0)/(20-0);%λ�ƵĹ�һ�����  ��ʽΪ����x-min��/��max-min��
% output = output + (sum(hengxiang));
risk_one = log10(1+mean(Risk(:,1))) /log10(4+1);%���յĹ�һ�����    ��ʽΪ��x�� = log10(x) /log10(max)  ע��xҪ����1������x��max��+1
output =  (1-k4)*diss_one + k4*(risk_one);%��궨��������Ȩ��
% disp(norm(truth_Risk))
output1 = traj_points;%���Ԥ���
output2 = Risk;%���Ԥ�����  ���ֵ㣨����������
% toc
% scatter(output1(:,1),output1(:,2),'*','r')
%% �������
lin_Risk = max(Risk)-Risk_constraint;%������Լ��
% disp(max(Risk))
%% ��������
[all_Cur] = PonitsCurve_calculation(traj_points);
lin_Cur = max(abs(all_Cur)) - Cur_constraint;%����Լ��
% disp(max(all_Cur))
%% �����ٶ�
distance = 0;
for i = 1:size(traj_points,1)-1
    distance = distance + norm(traj_points(i+1,:)-traj_points(i,:));
end
end_speed = (2*distance / (perception_time*0.12)*3.6) - extract_one(1,10);%ƽ���ٶ�Լ��  ��λ��km/h
lin_speed = end_speed - speed_constraint; %�ٶ�Լ��
%% ������ٶ�
accle = (end_speed - extract_one(1,10))/3.6/(perception_time*0.12);%��λ��m/s
lin_accle = abs(accle) - abs(accle_constraint);%���ٶ�Լ��  
% disp(accle)
%% ��������ٶȷ���͹켣����ļнǣ���ҪС��һ���ĽǶ�
V_angle = [extract_one(1,6),extract_one(1,7)];  %�ٶȽǶ�
V_angle = V_angle/norm(V_angle);
traj_angle = [(traj_points(2,1)-traj_points(1,1)),(traj_points(2,2)-traj_points(1,2))];%��һ����͵ڶ�����Ĺ켣�Ƕ�
traj_angle = traj_angle/norm(traj_angle);
sigma = acos(dot(V_angle,traj_angle)/(norm(V_angle)*norm(traj_angle)));
Angle_diff = sigma/pi*180;
lin_Angle_diff = Angle_diff - lin_Angle_constraint;
%% Լ��
const = [lin_speed;lin_Cur;lin_Risk;lin_accle;lin_Angle_diff];%�ٶȱ�����   const = [lin_speed;lin_Risk;lin_accCha1];%�ٶȱ�����  ȫ�Ǹ�����ʾ����Լ��
const2 = [];
end