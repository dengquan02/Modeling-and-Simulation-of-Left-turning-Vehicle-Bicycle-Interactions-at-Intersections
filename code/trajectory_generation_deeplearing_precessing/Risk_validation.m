function [output] = Risk_validation(extract_20)
%��������Ŀ������֤��ʵ�켣�Ƿ���Ĵ��ڷ�����С����������һ������ֵ֮�¾����ˣ�
%acc�Ǽ��ٶȼ��ϣ�һ�������ļ��ٶȣ����Ǽ����ꣻ[�Ƕȣ�����]������Ľ⣬20*2   �������ԭ����Ϊ����Լ���������
%����������Ǻ�20����ʵ���ٶ�
% acc = [3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;];
% acc = OPT;

extract_20 = extract_trajectory(index_in:index_in+20,:);%20����������ʵ���ݣ�����������ֵ�� 
acc = zeros(20,2);
[acc(:,1),acc(:,2)] = cart2pol(extract_20(2:21,8),extract_20(2:21,9));%��ֱ�����껻�ɼ����꣬����ľͲ��ø���  ������ٶ���λ�õ�������ģ���Ҫת��Ϊ
extract_20(:,1:3) = [];
% wo = extract_20(:,3:4)*0.12;
% scatter(extract_20(:,1),extract_20(:,2),'*','r')%��ʵ�켣��
% ��Ԥ�⽻ͨ����ֵ������ʵ��ͨ����������ÿһ����������ķ���ֵ���鿴Ԥ����Ƿ�������ͣ�
threshold_Risk = 0.5;
G=0.01;
R_b = 1;
M_b = 5000;
k1 = 1;
k3 = 0.05;
char_intrusion = 2;%ԭ����200
char_end = 0.2;%ԭ����6
index_end = 2;

%extract_oneʹ��һ���켣��һ֡
%intrusion_cood_E�ǻ�׼����
global extract_one
intrusion_cood_E = [47.43 27;47.43 23.5;3 27;3 23.5];

extract = extract_one;%Ԥ���֡
extract(:,1:3) = [];
extract = reshape(extract',11,[])';%�����11�е�
extract(all(extract==0,2),:)=[];%ȥ��ȫ0��,ʣ�µ���ÿ����������ģ���һ��������

base_point = extract(1,1:2);%��׼��
Vio = [extract(1,3) extract(1,4)];%ǰ������&������
prediction_point = base_point;%���Ԥ���ľ���
diss = [];%��¼�ľ���
Risk = [];%������ŷ��գ���һ����0����ָ��ʼ�����ߵķ���
standard_point = [];
for i = 1:size(acc,1)%����ÿһ��������
    extract_time_i = reshape(extract_20(i,:),11,[])';
    extract_time_i(all(extract_time_i==0,2),:)=[];%ȥ��ȫ0��,ʣ�µ���ÿ����������ģ���һ��������
    %�ȼ��� ��Ҫ���ٶȵ��Ǹ��㣬ȷ��Լ����Χ��
    pre_point = [(base_point(1,1)+Vio(1,1)*0.12) (base_point(1,2)+Vio(1,2)*0.12)];%������ٶ��ƽ��ĵ㣬Ҳ��������ԭ�㣻
    [acceleration(1,1),acceleration(1,2)] = pol2cart(acc(i,1),acc(i,2));%�����ٶȵļ�����ת��Ϊֱ������
    %�����ٶȻ�����λ������ϵ
    truth_point = [pre_point(1,1)+acceleration(1,1)*0.12^2*0.5 pre_point(1,2)+acceleration(1,2)*0.12^2*0.5];%���ݵ�ǰʱ�̵ļ��ٶ������ʵ�켣�㣻
    Vio = [Vio(1,1)+acceleration(1,1)*0.12 Vio(1,2)+acceleration(1,2)*0.12];%���µļ��ٶȸ�����һ���������ٶ�
    disp(Vio)
%     truth_point = extract_trajectory(index_in+18,4:5);%�鿴��ʵ�켣��������
    truth_Risk = Risk_calculation(truth_point,extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,M_b,k1,k3,char_intrusion,char_end,index_end);%���㵱ǰ��ķ��գ�
    [All_Risk] = risk_3D(pre_point,extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,M_b,k1,k3,char_intrusion,char_end,index_end);%pre_point �����ٶȵ�һ����Χ�ڵķ��շֲ�
    hold on
    scatter3(truth_point(1,1),truth_point(1,2),10,'*','r')%��ʵ�켣��
    hold on
%     scatter3(acceleration(1,1)*0.12+base_point(1,1),acceleration(1,2)*0.12+base_point(1,2),10,'*','r')%��ʵ����ٶ�
%     hold on
    scatter3([base_point(1,1);pre_point(1,1)],[base_point(1,2);pre_point(1,2)],[10,10],'*','b')%��һ����ͻ�׼��
    hold on 
    [~] = cycle_draw(pre_point,0.12);
%       scatter3(base_point(1,1),base_point(1,2),10,'*','r')%��׼�켣��
%       hold on
%     ���������ˣ���������ͼ
    Risk = [Risk;norm(truth_Risk)];%��¼��ǰ��ķ���ֵ
    dis = Vio(1,1)*0.12;
    %�ж��Ƿ�����Լ������
    if norm(truth_Risk)>threshold_Risk%������ֵ������ֵ����һЩ�������������Ͻ��ܿ���
       dis = 2;
    end
    if norm(Vio)>(15/3.6*0.12)
       dis = 2;
    end
    prediction_point = [prediction_point;truth_point];%��Ԥ��켣��ŵ�������
    standard_point = [standard_point;pre_point];%ÿһ�������ı�׼��
    diss = [diss;dis];%����ǰʱ�̵�ǰ�������λ�Ƽӽ�ȥ
%     scatter(truth_point(1,1),truth_point(1,2),'*','r');
%     hold on
%     scatter(pre_point(1,1),pre_point(1,2),'*','b');
    base_point = truth_point ; %��Ԥ��㸳���׼��
end
output = sum(diss);%����λ��֮��
disp(output)
% disp(norm(truth_Risk))
output1 = prediction_point;%���Ԥ���
output2 = Risk;%���Ԥ�����
end

