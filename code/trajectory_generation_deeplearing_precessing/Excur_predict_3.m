function [output] = Excur_predict_3(acc)
%Excur_predict_3�������Ż��Ĺ켣��Excur_predict_2��OPT������,Excur_predict_3���Ż�������ٶȣ�����Ŀǰ�Ժ��ٶ�ģ��Ϊ׼
%��������Ŀ���Ǽ�������ֵ��
%acc�Ǽ��ٶȼ��ϣ�һ�������ļ��ٶȣ����Ǽ����ꣻ[�Ƕȣ�����]������Ľ⣬20*2   �������ԭ����Ϊ����Լ���������
% acc = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
% acc = OPT;
acc =acc';%һ�л���һ��
%��ʵ�켣
%��������Ǹ������׸����ı궨�������������char_end��char_intrusion��index_end
% threshold_Risk = 2;G=0.01;R_b = 1;k1 = 1;k3 = 0.05;char_intrusion = 2;char_end = 0.2;index_end = 2;
M_b = 2000;
R_b = 1;
% k4=1.2;%Ŀ�꺯����Ȩ��

%��ȡ�궨��Ľ��
global Parameter
%threshold_Risk = Parameter(1);
G=0.01;
k1=Parameter(1);k3=Parameter(2);char_intrusion=Parameter(3);char_end=Parameter(4);index_end=Parameter(5);k4=Parameter(6);

%extract_oneʹ��һ���켣��һ֡
%intrusion_cood_E�ǻ�׼����
global extract_one
global intrusion_cood_E
% intrusion_cood_E = [47.43 27;47.43 23.5;3 27;3 23.5];

extract = extract_one;%Ԥ���֡
extract(:,1:3) = [];
extract = reshape(extract',11,[])';%�����11�е�
extract(all(extract==0,2),:)=[];%ȥ��ȫ0��,ʣ�µ���ÿ����������ģ���һ��������
%�Կ�����һ��Ԥ��
[extract_pre] = envir_pre(extract,size(acc,1));%���ٶ�ģ��Ԥ��perception_time��������extract��һ�������� �����ʽ��Ԥ�ⲽ��*����x����y
base_point = extract(1,1:2);%��׼��
Vio = [extract(1,3) extract(1,4)];%ǰ������&������
prediction_point = base_point;%���Ԥ���ľ���
diss = [];%��¼�ľ���
Risk = [];%������ŷ���,��һ����Ԥ��㣬�ڶ�������ʵ��
hengxiang = [];
standard_point = [];
for i = 1:size(acc,1)%����ÿһ��������
    extract_time_i = reshape(extract_pre(i,:)',2,[])';%����i�������ָ���n*2��ģʽ  i=1�ǵ�ǰʱ��
    extract_time_i = [extract_time_i extract(:,3:size(extract,2))];%����Ĳ�������Ԥ��ֵ��ʹ�����������ǻ�����Ϣ������������
    %�ȼ��� ��Ҫ���ٶȵ��Ǹ��㣬ȷ��Լ����Χ��
    pre_point = [(base_point(1,1)+Vio(1,1)*0.12) (base_point(1,2)+Vio(1,2)*0.12)];%������ٶ��ƽ��ĵ㣬Ҳ��������ԭ�㣻 X���Ǻ��ٶ��ƽ���
    acceleration = acc(i);%��������ٶȸ��赱ǰ����
    %���ϼ��ٶ�
    truth_point = [pre_point(1,1) pre_point(1,2)+acceleration*0.12^2*0.5];%���ݵ�ǰʱ�̵ļ��ٶ������ʵ�켣�㣻
    Vio = [Vio(1,1) Vio(1,2)+acceleration*0.12];%���µļ��ٶȸ�����һ���������ٶ�  vt=v0+at
    truth_Risk = Risk_calculation(truth_point,extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,M_b,k1,k3,char_intrusion,char_end,index_end);%���㵱ǰ��ķ��գ�
    %���������ʱctrl+r��,����12/24�ı������
    real_Risk = Risk_calculation(extract_trajectory(index_in+i,4:5),extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,M_b,k1,k3,char_intrusion,char_end,index_end);%���㵱ǰ��ķ��գ�
    Risk = [Risk;[norm(truth_Risk) norm(real_Risk)]];%��¼��ǰԤ������ʵ��ķ���ֵ
%     Risk = [Risk;norm(truth_Risk)];
    dis = Vio(1,1)*0.12;
    %�ж��Ƿ�����Լ������  �����ѭ��0103ע�͵��ģ���Ϊû�з�������ֵ
%     if norm(truth_Risk)>threshold_Risk%������ֵ������ֵ����һЩ�������������Ͻ��ܿ���
%        dis = 2;
%     end
%     if norm(Vio)>(25/3.6)%����ǰ�ٶȴ���25km/h�����ܸ�һ����ĳͷ�
%        dis = 2;
%     end
    prediction_point = [prediction_point;truth_point];%��Ԥ��켣��ŵ�������
    standard_point = [standard_point;pre_point];%ÿһ�������ı�׼��
    hengxiang = [hengxiang;abs(Vio(1,2)*0.12)];
%     dis = [dis extract_trajectory(index_in+i,6)*0.12];%����ʵ�켣������Ž�ȥ
    diss = [diss;dis];%����ǰʱ�̵�ǰ�������λ�Ƽӽ�ȥ
    base_point = truth_point ; %��Ԥ��㸳���׼��
end
% output = sum(diss(:,1));%����λ��֮��
% output = output + k4*(sum(Risk(:,1)));%��궨��������Ȩ��
output = (sum(Risk(:,1)));%������С
% disp(output)
% disp(norm(truth_Risk))
output1 = prediction_point;%���Ԥ���
output2 = Risk;%���Ԥ�����

% %��������ͼ
 clf
    for j =1:20
        scatter(extract_trajectory(index_in+j,4),extract_trajectory(index_in+j,5),'*','b')
        hold on
        scatter(output1(j+1,1),output1(j+1,2),'*','r')
        pause(0.5)
    end
    ADE(extract_trajectory(index_in:index_in+20,4:5),output1)
end

