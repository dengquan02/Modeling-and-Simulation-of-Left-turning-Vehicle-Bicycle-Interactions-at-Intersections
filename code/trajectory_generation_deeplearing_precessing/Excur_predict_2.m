function [extract,output,output1,output2] = Excur_predict_2(OPT,extract_one,Truth_block,perception_time,generating_lengh)
%Excur_predict_1�������Ż��Ĺ켣��Excur_predict_2��OPT������
% Truth_block = Truth_no;
% extract_one = Truth_no(1,:);%����Ԥ���֡
% perception_time = 25;

%% 
%output��Ŀ��ֵ��output1�������Ԥ��㣻output2������ķ���ֵ��
%acc�Ǽ��ٶȼ��ϣ��Ǽ����ꣻ[�Ƕȣ�����]������Ľ⣬20*2   �������ԭ����Ϊ����Լ���������
% acc = [3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;3 0.1;];
% OPT=truth_input;%����ʵ�켣����ȥ��
% OPT=test_result_precessing(i,4:size(test_result_precessing,2));%��Ԥ��ֵ����ȥ��
acc = OPT;
timess = round(size(acc,2)/2);
acc =[acc(1:timess)' acc(timess+1:timess*2)'];%һ�л�������


%% ���ò�ֵ���Լ��ٶȲ�������
generating_lengh = 2;%����ֵ֮�������Ҫ����  %��ֵ֮������͵���2��
[current_acc(1,1), current_acc(1,2)] = cart2pol(Truth_block(1,8),Truth_block(1,9));%����ǰ���ٶȻ���֮�����
[complete_acc] = acc_interpolation(acc,current_acc,timess,perception_time,generating_lengh);%��ֵ�õ��������ٶȼ���
acc = complete_acc;

interval = 0:generating_lengh-1:perception_time-1;%Ԥ�������
%% 
%��ʵ�켣
%��������Ǹ������׸����ı궨�������������char_end��char_intrusion��index_end
% threshold_Risk = 2;G=0.01;R_b = 1;k1 = 1;k3 = 0.05;char_intrusion = 2;char_end = 0.2;index_end = 2;%��궨
% M_b = 2000;
% k4=1.2;%Ŀ�꺯����Ȩ��
R_b = 1;%��·����

%��ȡ�궨��Ľ��
global Parameter
%threshold_Risk = Parameter(1);
G=Parameter(10);%G=0.01;
k1=Parameter(1);k3=Parameter(2);char_intrusion=Parameter(3);char_end=Parameter(4);index_end=Parameter(5);k4=Parameter(6);
%
char_intrusion_right=Parameter(7);char_end_right=Parameter(8);index_end_right=Parameter(9);

% char_end=5;index_end=0.2;

% extract_one = Truth_no(1,:);
% Truth_block = Truth_no;
%intrusion_cood_E�ǻ�׼����
global intrusion_cood_E
% intrusion_cood_E = [47.43 27;47.43 23.5;3 27;3 23.5];

extract = extract_one;%Ԥ���֡
if extract_one(1,14) == 1%��̬��������ƫ��ϵ��
    k4 = 5;  %PPT�ϵĽ�����õ���3  4
elseif extract_one(1,14) == 2
    k4 = 3;  %PPT�ϵĽ�����õ���2  3
end
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
position_nearInter = [];%���ÿһ������Ľ�������
interval(:,1) = [];
time_interv = 0.12 * (generating_lengh-1);%�µ�ʱ����

%% ����Ŀ��ֵ ���켣���Ƶ㣩
for i = 1:size(interval,2)%����ÿһ��������     %for i = 1:size(acc,1)%����ÿһ��������
    extract_time_i = reshape(extract_pre(interval(i),:)',2,[])';%����i�������ָ���n*2��ģʽ  i=1�ǵ�ǰʱ��
    extract_time_i = [extract_time_i extract(:,3:size(extract,2))];%����Ĳ�������Ԥ��ֵ��ʹ�����������ǻ�����Ϣ������������
    %% �������һ����ʵλ�ú�����Ľ�������ľ���
    truth_position = Truth_block(interval(i),4:5);%��ȡ��ʵλ��
    dis_inter = [];
    for j = 2:size(extract_time_i,1)
        dis_inter = [dis_inter;[j (((extract_time_i(j,1)- truth_position(1,1)))^2+((extract_time_i(j,2)- truth_position(1,2)))^2)^0.5]];
    end
    id_near = 1;%dis_inter(find(dis_inter(:,2)==min(dis_inter(:,2))),1);%�ҵ������һ��������������
%     disp(id_near)
    position_nearInter = [position_nearInter;extract_time_i(id_near,1:2)];
    %�ȼ��� ��Ҫ���ٶȵ��Ǹ��㣬ȷ��Լ����Χ��
    pre_point = [(base_point(1,1)+Vio(1,1)*time_interv) (base_point(1,2)+Vio(1,2)*time_interv)];%������ٶ��ƽ��ĵ㣬Ҳ��������ԭ�㣻
    [acceleration(1,1),acceleration(1,2)] = pol2cart(acc(i,1),acc(i,2));%�����ٶȵļ�����ת��Ϊֱ������
    %�����ٶȻ������ٶȲο�ϵ
    truth_point = [pre_point(1,1)+acceleration(1,1)*time_interv ^2*0.5 pre_point(1,2)+acceleration(1,2)*time_interv ^2*0.5];%���ݵ�ǰʱ�̵ļ��ٶ������ʵ�켣�㣻
    Vio = [Vio(1,1)+acceleration(1,1)*time_interv  Vio(1,2)+acceleration(1,2)*time_interv ];%���µļ��ٶȸ�����һ���������ٶ�  vt=v0+at
    truth_Risk = Risk_calculation(truth_point,extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,k1,k3,char_intrusion,char_end,index_end,char_intrusion_right,char_end_right,index_end_right);%���㵱ǰ��ķ��գ�
    %���������ʱctrl+r��,����12/24�ı������
    real_Risk = Risk_calculation(Truth_block(interval(i),4:5),extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,k1,k3,char_intrusion,char_end,index_end,char_intrusion_right,char_end_right,index_end_right);%���㵱ǰ��ķ��գ�
%     [~] = risk_3D(pre_point,extract,intrusion_cood_E,G,R_b,k1,k3,char_intrusion,char_end,index_end,char_intrusion_right,char_end_right,index_end_right);%�����ճ���ͼ
    Risk = [Risk;[norm(truth_Risk) norm(real_Risk)]];%��¼��ǰԤ������ʵ��ķ���ֵ
%     Risk = [Risk;norm(truth_Risk)];
    dis = Vio(1,1)*time_interv ;
    dis_path = abs(norm(Vio*time_interv ));%������������·��
    %�ж��Ƿ�����Լ������  �����ѭ��0103ע�͵��ģ���Ϊû�з�������ֵ
%     if norm(truth_Risk)>threshold_Risk%������ֵ������ֵ����һЩ�������������Ͻ��ܿ���
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
%     [traj_points] = Path_generation(start_point,end_point,generating_lengh-1);%�������perception_time���켣�㣬�������յ�����
%     traj_points(size(traj_points,1),:) = [];%ɾ��ÿ�ε����㣬���¸�ѭ������㣻
%     all_points = [all_points;traj_points];%����Ϊһ���켣����Ӧ���������ľ��󣬰������ߵ�����ɵ�
% end
% 
% 
% %% �ٴμ���Ŀ�꣨�����켣�㣩
% time_interv = 0.12 ;
% for i = 1:size(all_points,2)%����ÿһ��������  
%     extract_time_i = reshape(extract_pre(i,:)',2,[])';%����i�������ָ���n*2��ģʽ  i=1�ǵ�ǰʱ��
%     extract_time_i = [extract_time_i extract(:,3:size(extract,2))];%����Ĳ�������Ԥ��ֵ��ʹ�����������ǻ�����Ϣ������������
%     pred_Risk = Risk_calculation(all_points(i,:),extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,k1,k3,char_intrusion,char_end,index_end,char_intrusion_right,char_end_right,index_end_right);%���㵱ǰ��ķ��գ�
%     %���������ʱctrl+r��,����12/24�ı������
%     real_Risk = Risk_calculation(Truth_block(i,4:5),extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,k1,k3,char_intrusion,char_end,index_end,char_intrusion_right,char_end_right,index_end_right);%���㵱ǰ��ķ��գ�
% %     [~] = risk_3D(pre_point,extract,intrusion_cood_E,G,R_b,k1,k3,char_intrusion,char_end,index_end,char_intrusion_right,char_end_right,index_end_right);%�����ճ���ͼ
%     Risk = [Risk;[norm(pred_Risk) norm(real_Risk)]];%��¼��ǰԤ������ʵ��ķ���ֵ
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
% output = output + k4*((Risk(size(Risk,1),1)));%����ֻ�������һ����ķ���ֵ    
k4=0.1;
output = (1-k4)*(sum(diss(:,1))) + (k4)*(((mean(Risk(:,1)))));%ǰ�������30��400�����ֵ���б궨��������Ȩ��   ȫ��·�����ն�����   %output = (1-k4)*(sum(diss(:,1))/3) + (k4)*(((mean(Risk(:,1)))*sum(Dis_Path))/4);%ǰ�������30��400�����ֵ���б궨��������Ȩ��   ȫ��·�����ն�����   %
% disp('Ŀ��ֵ��')
% disp(output)
% disp((sum(diss(:,1))/3) );
% disp(((mean(Risk(:,1)))*sum(Dis_Path))/4)
output1 = prediction_point;%���Ԥ���
% output1 = all_points;%���Ԥ���(������)
output2 = Risk;%���Ԥ�����
% extract_time_i(2:size(extract_time_i,1),:) %������ȡ����Ԥ���Ļ���    extract(2:size(extract,1),:)
% [~] = risk_3D(pre_point,extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,k1,k3,char_intrusion,char_end,index_end,char_intrusion_right,char_end_right,index_end_right);%�����ճ���ͼ

end

