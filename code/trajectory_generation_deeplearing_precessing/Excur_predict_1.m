function [output] = Excur_predict_1(acc)
%Excur_predict_1�������Ż��Ĺ켣��Excur_predict_2��OPT������
%��������Ŀ���Ǽ�������ֵ��
%acc�Ǽ��ٶȼ��ϣ�һ�������ļ��ٶȣ����Ǽ����ꣻ[�Ƕȣ�����]������Ľ⣬20*2   �������ԭ����Ϊ����Լ���������
% acc = [3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;];
% acc = OPT;
perception_time = 25;
generating_lengh = 9; %��ָ���ʾ��һ�������ı�ţ�����������2����7���������9��

timess = round(size(acc,2)/2);
acc =[acc(1:timess)' acc(timess+1:timess*2)'];%һ�л�������


%%
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
global extract_one

%% ���ò�ֵ���Լ��ٶȲ�������
[current_acc(1,1), current_acc(1,2)] = cart2pol(extract_one(1,8),extract_one(1,9));%����ǰ���ٶȻ���֮�����
[complete_acc] = acc_interpolation(acc,current_acc,timess,perception_time,generating_lengh);%��ֵ�õ��������ٶȼ���
acc = complete_acc;
generating_lengh = 2;%��ֵ֮������͵���2��
interval = 0:generating_lengh-1:perception_time-1;%Ԥ�������
%%
global intrusion_cood_E
if extract_one(1,14) == 1%��̬��������ƫ��ϵ��  ���г�
    k4 = 5;%PPT�ϵĽ�����õ���4
elseif extract_one(1,14) == 2  %�綯��
    k4 = 3;%PPT�ϵĽ�����õ���3
end
% intrusion_cood_E = [47.43 27;47.43 23.5;3 27;3 23.5];

extract = extract_one;%Ԥ���֡
extract(:,1:3) = [];
extract = reshape(extract',11,[])';%�����11�е�
extract(all(extract==0,2),:)=[];%ȥ��ȫ0��,ʣ�µ���ÿ����������ģ���һ��������
%�Կ�����һ��Ԥ��
[extract_pre] = envir_pre(extract,perception_time);%���ٶ�ģ��Ԥ��perception_time��������extract��һ�������� �����ʽ��Ԥ�ⲽ��*����x����y
base_point = extract(1,1:2);%��׼��
Vio = [extract(1,3) extract(1,4)];%ǰ������&������
prediction_point = base_point;%���Ԥ���ľ���
diss = [];%��¼�ľ���
Risk = [];%������ŷ���,��һ����Ԥ��㣬�ڶ�������ʵ��
hengxiang = [];
standard_point = [];
Dis_Path = [];%����·��

interval(:,1) = [];
time_interv = 0.12 * (generating_lengh-1);%�µ�ʱ����  %�����ñ�������������������Ͳ��øĳɴ�ʱ�����ˣ���û������Ҫ�仯


%% ����Ŀ��ֵ ���켣���Ƶ㣩
for i = 1:size(interval,2)%����ÿһ��������  
    extract_time_i = reshape(extract_pre(interval(i),:)',2,[])';%����i�������ָ���n*2��ģʽ  i=1�ǵ�ǰʱ��
    extract_time_i = [extract_time_i extract(:,3:size(extract,2))];%����Ĳ�������Ԥ��ֵ��ʹ�����������ǻ�����Ϣ������������
    %�ȼ��� ��Ҫ���ٶȵ��Ǹ��㣬ȷ��Լ����Χ��
    pre_point = [(base_point(1,1)+Vio(1,1)*time_interv) (base_point(1,2)+Vio(1,2)*time_interv)];%������ٶ��ƽ��ĵ㣬Ҳ��������ԭ�㣻
    [acceleration(1,1),acceleration(1,2)] = pol2cart(acc(i,1),acc(i,2));%�����ٶȵļ�����ת��Ϊֱ������
    %�����ٶȻ������ٶȲο�ϵ
    truth_point = [pre_point(1,1)+acceleration(1,1)*(time_interv)^2*0.5 pre_point(1,2)+acceleration(1,2)*(time_interv)^2*0.5];%���ݵ�ǰʱ�̵ļ��ٶ������ʵ�켣�㣻
    Vio = [Vio(1,1)+acceleration(1,1)*time_interv Vio(1,2)+acceleration(1,2)*time_interv];%���µļ��ٶȸ�����һ���������ٶ�  vt=v0+at
    truth_Risk = Risk_calculation(truth_point,extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,k1,k3,char_intrusion,char_end,index_end,char_intrusion_right,char_end_right,index_end_right);%���㵱ǰ��ķ��գ�
    %���������ʱctrl+r��,����12/24�ı������
%     real_Risk = Risk_calculation(extract_trajectory(index_in+i,4:5),extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,M_b,k1,k3,char_intrusion,char_end,index_end);%���㵱ǰ��ķ��գ�
%     Risk = [Risk;[norm(truth_Risk) norm(real_Risk)]];%��¼��ǰԤ������ʵ��ķ���ֵ
  
    Risk = [Risk;norm(truth_Risk)];
    dis = Vio(1,1)*time_interv;
    dis_path = abs(norm(Vio));%������������·��
    %�ж��Ƿ�����Լ������  �����ѭ��0103ע�͵��ģ���Ϊû�з�������ֵ
%     if norm(truth_Risk)>5%������ֵ������ֵ����һЩ�������������Ͻ��ܿ���
%        dis = 2;
%     end
%     if norm(Vio)>(25/3.6)%����ǰ�ٶȴ���25km/h�����ܸ�һ����ĳͷ�
%        dis = 2;
%     end
    prediction_point = [prediction_point;truth_point];%��Ԥ��켣��ŵ�������
    standard_point = [standard_point;pre_point];%ÿһ�������ı�׼��
    hengxiang = [hengxiang;abs(Vio(1,2)*time_interv)];
%     dis = [dis extract_trajectory(index_in+i,6)*0.12];%����ʵ�켣������Ž�ȥ
    diss = [diss;dis];%����ǰʱ�̵�ǰ�������λ�Ƽӽ�ȥ
    Dis_Path = [Dis_Path,dis_path];%·�̳���
    base_point = truth_point ; %��Ԥ��㸳���׼��
end

% %% ���ñ������������ɹ켣
% % ��ֵ
% all_points = [];%��������Ĺ켣�㣨�������ߵ�����ɵ㣩
% for j = 1:size(prediction_point,1)-1%��ÿ�β���
%     start_point = prediction_point(j,:);%���ϳ��յ㣬 [ x, y]
%     end_point = prediction_point(j+1,:);%���ϳ��յ㣬 [ x, y]
%     [traj_points] = Path_generation(start_point,end_point,generating_lengh-1);%�������perception_time���켣�㣬�������յ�����  generating_lengh-1
%     traj_points(size(traj_points,1),:) = [];%ɾ��ÿ�ε����㣬���¸�ѭ������㣻
%     all_points = [all_points;traj_points];%����Ϊһ���켣����Ӧ���������ľ��󣬰������ߵ�����ɵ�
% end
% 
% %% �ٴμ���Ŀ�꣨�����켣�㣩
% time_interv = 0.12 ;
% for i = 1:size(all_points,2)%����ÿһ��������  
%     extract_time_i = reshape(extract_pre(i,:)',2,[])';%����i�������ָ���n*2��ģʽ  i=1�ǵ�ǰʱ��
%     extract_time_i = [extract_time_i extract(:,3:size(extract,2))];%����Ĳ�������Ԥ��ֵ��ʹ�����������ǻ�����Ϣ������������
%     truth_Risk = Risk_calculation(all_points(i,:),extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,k1,k3,char_intrusion,char_end,index_end,char_intrusion_right,char_end_right,index_end_right);%���㵱ǰ��ķ��գ�
%     Risk = [Risk;norm(truth_Risk)];
%     %�����Ǽ�����գ������Ǽ������
%     dis = all_points(i+1,1)-all_points(i,1);%���������ǰ�������λ��,�����Ǹ�ֵ
%     dis_path = abs(norm(all_points(i:i+1,:)));%������������·��
%     %�ж��Ƿ�����Լ������  �����ѭ��0103ע�͵��ģ���Ϊû�з�������ֵ
% %     if norm(truth_Risk)>5%������ֵ������ֵ����һЩ�������������Ͻ��ܿ���
% %        dis = 2;
% %     end
% %     if norm(Vio)>(25/3.6)%����ǰ�ٶȴ���25km/h�����ܸ�һ����ĳͷ�
% %        dis = 2;
% %     end
% %     dis = [dis extract_trajectory(index_in+i,6)*0.12];%����ʵ�켣������Ž�ȥ
%     diss = [diss;dis];%����ǰʱ�̵�ǰ�������λ�Ƽӽ�ȥ
%     Dis_Path = [Dis_Path,dis_path];%·�̳���
% end

%% ���Ŀ��ֵ
% output = output + (sum(hengxiang));
% output = output + k4*(sum(Risk(size(Risk,1),1)));%����ֻ�������һ����ķ���ֵ
k4=0.1;  %k4=0.32;
output = (1-k4)*(sum(diss(:,1))) + (k4)*(mean(Risk(:,1)));%ǰ��    *sum(Dis_Path)
% disp('Ŀ��ֵ��')
% disp(output)
% disp((sum(diss(:,1))) );
% disp(((mean(Risk(:,1))))*2)
% disp(norm(truth_Risk))
output1 = prediction_point;%���Ԥ���
output2 = Risk;%���Ԥ�����
end

