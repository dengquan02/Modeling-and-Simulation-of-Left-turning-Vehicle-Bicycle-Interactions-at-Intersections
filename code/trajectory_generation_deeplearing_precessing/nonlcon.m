
%Լ����������
function [const,const2] = nonlcon(acc)
% ������Լ����const�ǲ���ʽԼ����const2�ǵ�ʽԼ��
%acc�Ǽ��ٶȼ��ϣ�һ�������ļ��ٶȣ����Ǽ����ꣻ[�Ƕȣ�����]������Ľ⣬20*2   �������ԭ����Ϊ����Լ���������
perception_time = 33;  %����Ԥ���һ���㣬��ʽ�ǣ�1+24
generating_lengh = 33;
interval = 0:generating_lengh-1:perception_time-1;%Ԥ�������

% acc = [3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;];
% acc = OPT;
% acc = input(2:26,8:9);
% acc = truth_input;
timess = round(size(acc,2)/2);
acc =[acc(1:timess)' acc((timess+1):(timess*2))'];%һ�л�������
% acc = zeros(20,2);
% acc(:,1) = deg2rad(acc(:,1));%�ѽǶ��ƻ��ɻ�����
% M_b = 2000;
% k4=1.2;%Ŀ�꺯����Ȩ��
R_b = 1;%��·����
%��ȡ�궨��Ľ��
global Parameter
threshold_Risk = 15;%��߷���
G=Parameter(10);
k1=Parameter(1);k3=Parameter(2);char_intrusion=Parameter(3);char_end=Parameter(4);index_end=Parameter(5);k4=Parameter(6);
char_intrusion_right=Parameter(7);char_end_right=Parameter(8);index_end_right=Parameter(9);
%extract_oneʹ��һ���켣��һ֡
%intrusion_cood_E�ǻ�׼����
global extract_one
%Ѱ�Һ��ʵ��ٶ�Լ����
% a_limit = (E_trajectory(find(E_trajectory(:,14)==2),10));
% a_limit = sort(abs(a_limit));
% % % a_limit = prctile(a_limit ,85);%��ٷ�λ��
% % median(a_limit)
% mode(a_limit)
if extract_one(1,14)==2%����2����Ϊ�綯��
    acc_limit = 16.2;%���ֵ��47.6  %0.259����õ���17.3588;%%Ч���õ�ʱ����ƽ��ֵ17.4��ȡ����ƽ��ֵ�͵�ǰֵ�����ֵ  ��Ŀǰ�ڳ��԰ٷ�λ��23.3����λ��17.64������18.149
elseif extract_one(1,14)==1%����1����Ϊ���г�
    acc_limit =11.5;%���ֵ��27.6  0.259����õ���10.982;%%Ч���õ�ʱ����ƽ��ֵ13.4��ȡ����ƽ��ֵ�͵�ǰֵ�����ֵ  ��Ŀǰ�ڳ��԰ٷ�λ��16.8����λ��13.8������15.36
end
acc_limit = max(acc_limit,extract_one(1,10)+0.01);%��ǰ�ٶȺ��Ҹ���Լ����ȡ��ֵ
global intrusion_cood_E
% intrusion_cood_E = [47.43 27;47.43 23.5;3 27;3 23.5];

extract = extract_one;%Ԥ���֡
extract(:,1:3) = [];
extract = reshape(extract',11,[])';%�����11�е�
extract(all(extract==0,2),:)=[];%ȥ��ȫ0��,ʣ�µ���ÿ����������ģ���һ��������
%�Կ�����һ��Ԥ��
[extract_pre] = envir_pre(extract,perception_time);%���ٶ�ģ��Ԥ��perception_time��������extract��һ�������� �����ʽ��Ԥ�ⲽ��*����x����y
base_point = extract(1,1:2);%��׼��
Vio = [extract(1,3) extract(1,4)];%ǰ������&������
speed = [];
prediction_point = base_point;%���Ԥ���ľ���
acc_cha  = [];
diss = [];%��¼�ľ���
Risk = [];%������ŷ��գ���һ����0����ָ��ʼ�����ߵķ���
predicted_V = [];%�洢ֱ������ϵ���ٶ�
interval(:,1) = [];
time_interv = 0.12 * (generating_lengh-1);%�µ�ʱ����
for i = 1:size(interval,2)%����ÿһ�������� 
    extract_time_i = reshape(extract_pre(interval(i),:)',2,[])';%����i�������ָ���n*2��ģʽ  i=1�ǵ�ǰʱ��
    extract_time_i = [extract_time_i extract(:,3:size(extract,2))];%����Ĳ�������Ԥ��ֵ��ʹ������
    %�ȼ��� ��Ҫ���ٶȵ��Ǹ��㣬ȷ��Լ����Χ��
    pre_point = [(base_point(1,1)+Vio(1,1)*time_interv) (base_point(1,2)+Vio(1,2)*time_interv)];%������ٶ��ƽ��ĵ㣬Ҳ��������ԭ�㣻
    [acceleration(1,1),acceleration(1,2)] = pol2cart(acc(i,1),acc(i,2));%�����ٶȵļ�����ת��Ϊֱ������
    acc_cha = [acc_cha;acceleration];%ֱ������ļ��ٶ�
    %�����ٶȻ�����λ������ϵ
    truth_point = [pre_point(1,1)+acceleration(1,1)*time_interv^2*0.5 pre_point(1,2)+acceleration(1,2)*time_interv^2*0.5];%���ݵ�ǰʱ�̵ļ��ٶ������ʵ�켣�㣻 s=v0t+0.5*at^2
    speed = [speed;norm(Vio)*time_interv];%���ٶȱ���������
    predicted_V = [predicted_V;Vio];%��ÿһ�����ٶȱ�������
    Vio = [Vio(1,1)+acceleration(1,1)*time_interv Vio(1,2)+acceleration(1,2)*time_interv];%��Ԥ���ٶȸ����׼��  vt=v0+at
%     truth_point = extract_trajectory(index_in+18,4:5);%�鿴��ʵ�켣��������
    truth_Risk = Risk_calculation(truth_point,extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,k1,k3,char_intrusion,char_end,index_end,char_intrusion_right,char_end_right,index_end_right);%���㵱ǰ��ķ��գ�
    Risk = [Risk;norm(truth_Risk)];%��¼��ǰ��ķ���ֵ

    dis = Vio(1,1)*time_interv;
    %�ж��Ƿ�����Լ������
%     if norm(truth_Risk)>threshold_Risk%������ֵ������ֵ
%        dis = 2;
%     end
%     if acc(i,2)>0.24||acc(i,2)<0
%        dis = 0;
%     end
    prediction_point = [prediction_point;truth_point];%��Ԥ��켣��ŵ�������
    diss = [diss;dis];%����ǰʱ�̵�ǰ�������λ�Ƽӽ�ȥ
%     scatter(truth_point(1,1),truth_point(1,2),'*','r');
%     hold on
%     scatter(pre_point(1,1),pre_point(1,2),'*','b');
    base_point = truth_point ; %��Ԥ��㸳���׼��
end
output = sum(diss);%����λ��֮��
% disp(norm(truth_Risk))
output1 = prediction_point;%���Ԥ���
output2 = Risk;%���Ԥ�����
lin_speed = max((speed)-(acc_limit/3.6*time_interv)) ;%�ٶ�����,С�����ޣ���lin_speedС�ڵ���0��20������ٶ�����
lin_Risk = max((Risk)-threshold_Risk) ; %threshold_Risk��������,С�����ޣ���lin_speedС�ڵ���0��
acc_cha1 = [];
for i =1:size(acc,1)-2
    acc_cha1 = [acc_cha1;abs(norm(acc_cha(i+1,:)-acc_cha(i,:)))];%�����ȣ��ٶȣ� 
end
lin_accCha1 = max(acc_cha1)-5;%�����Ȳ��Ҳ��֪��������ٺ��ʣ�ԭ����5taiyaun
const = [lin_speed;lin_accCha1;lin_Risk];%;%;%�ٶȱ�����   const = [lin_speed;lin_Risk;lin_accCha1];%�ٶȱ�����  ȫ�Ǹ�����ʾ����Լ��
% disp(const)
const2 = 0;
end