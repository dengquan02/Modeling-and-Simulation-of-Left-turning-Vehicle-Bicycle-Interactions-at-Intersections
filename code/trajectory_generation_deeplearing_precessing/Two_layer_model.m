%% �ýű���˫��켣Ԥ��ģ�͵�������
% ����Ϊ�������֣��ֱ��ǣ�
%% ����������ѡһ�¹켣
% ID_out = [];
% for i = 22%1:E_trajectory(size(E_trajectory,1),1)   size(ID_out,2)
%     index= i;%ID_out(1,i);
%     figure(1)
%     clf
%     OPtertion = E_trajectory((E_trajectory(:,1)==index),:);
% %     if min(OPtertion(:,5))<=22
% %         ID_out = [ID_out,i];
% %     end
%     for j = 1:size(OPtertion,1)
%         inter_OBJ = reshape(OPtertion(j,4:size(OPtertion,2))',11,[])';
%         inter_OBJ(all(inter_OBJ==0,2),:) = [];%ɾ������
%         hold on
%         scatter(inter_OBJ(1,1),inter_OBJ(1,2),'o','b','linewidth',1);
%         if size(inter_OBJ,1)>1
%             hold on
%            scatter(inter_OBJ(2:size(inter_OBJ,1),1),inter_OBJ(2:size(inter_OBJ,1),2),'+','black','linewidth',1);
%         end
% %         pause(0.5)
%     end
% %     pause(1)
%     disp(index)
%     i = i +1;
% end
%
tic
%% �ò���������Ԥ�������յõ�E_trajectory
%%% �ٶ�ȡ֮ǰ�Ĳ����������
load('data_new.mat');%load('result(ADE=0.08����δ֪��������3.6ѵ��0929_2).mat');%load('data_precessing(0831_1)ADE=0.0358).mat')
load('data_new2.mat');
csvwrite('mmax(20211124_1).csv',mmax);
csvwrite('mmin(20211124_1).csv',mmin);
% clearvars -except sample_test
mmax = csvread('mmax(20211124_1).csv');%�����ֵ����   %mmax = csvread('mmax(20210831_1).csv');%�����ֵ����
mmin = csvread('mmin(20211124_1).csv');%����Сֵ����   %mmin = csvread('mmin(20210831_1).csv');%����Сֵ����

Mytest_ID = sample_test(:,1:3);%��ȡ���������в������ݵ����   sample_test����ǰ���������֮��
% csvwrite('ID_mutation.csv',ID_mutation);%д��ͻ����ΪID
% csvwrite('ID_mutation_small.csv',ID_mutation_small);%д��ͻ����ΪID 17��������
% ID_mutation_small = ID_mutation; % 17��������
% ID_mutation = csvread('ID_mutation.csv');%��ȡͻ����ΪID
% ID_mutation = csvread('ID_mutation_small.csv');%��ȡͻ����ΪID
%%%  ������һЩ����
benchmark_EXXRoad = csvread('benchmark_EXXRoad.csv');%��ȡ��׼��Ϣ
% csvwrite('benchmark_EXXRoad.csv',benchmark_EXXRoad);%��ȡ��׼��Ϣ
global intrusion_cood_E
intrusion_cood_E= csvread('intrusion_cood_EXXRoad.csv');%��ȡ����������׼��Ϣ����ʾ��׼�����꣬���������Ӧ�����ĸ��㣬����·��������ʱ���ֱ�Ϊ���¡����¡����ϡ�����


perception_time = 17;%����Ԥ�ⲽ��   17/33
generating_lengh = perception_time;
n_input=generating_lengh;%����������켣�����
Num_No=6;%�����ķǻ���������ĸ�����Ŀǰ�ǰ��վ�����̵ļ���,�ο�����6����
Num_V=6;%�����Ļ���������

% %%% ������Ԥ����
% [E1]=xlsread('M:\New_try\�����ദ��������ݣ�T=0.12s��.xlsx',1);%������ֱ�зǻ�����
% [E1V]=xlsread('M:\New_try\�����ദ��������ݣ�T=0.12s��.xlsx',2);%������ֱ�л�����
% [W1V]=xlsread('M:\New_try\�����ദ��������ݣ�T=0.12s��.xlsx',3);%��������ת������
% global E_trajectory;
% [E_trajectory] = input_data_XianXiaRoad(E1,E1V,W1V,Num_No,Num_V);%����Ԥ��
%
% %%% ����Ԥ�������  ���յ�Ŀ���ǵõ�E_trajectory

%% Ԥ��켣  ��Mytest_ID����Ž���Ԥ��
%%% ��ʼ���㣬�ȸ�ֵ

test_result_no = [];%��¼������
data_EXITFLAG = [];%��¼GA���˳�����
where_best = [];%��¼��ʵֵ��Ŀ��ֵ����ĵڼ�λ��0��ʾ������Լ������3��һ��5�֣�����
where_const = [];
where_OPT = [];%��¼����ֵ����ʵֵ����ĵڼ�λ
% Parameter_cal = csvread('Parameter_cal_store.csv');%���ѱ��������ж�ȡ��׼��Ϣ

%% ��ȡ��������
%   ���ݲ���ȫ������
input = E_trajectory;
test_ID = Mytest_ID(1:generating_lengh:size(Mytest_ID,1),:); % �õ��������ݵ�ID

%% ��test_ID�����34��������
ID_set_dele = [];
for i = 1:size(test_ID,1)-1
    see_ID = test_ID(i,2:3);%��ȡ��ǰID
    End_ID = see_ID(1,2) + perception_time ;
    if End_ID > test_ID(i+1,3)&&see_ID(1,1)==test_ID(i,2)
        ID_set_dele = [ID_set_dele;i+1];
    end
end
test_ID(ID_set_dele,:) = [];%ɾ�������ܻ�ʹ���������غϵĲ�������
%% �����￪ʼ  ��������50������
for ID = 1:size(test_ID,1)%����ÿ���켣   %for ID = 1:size(test_ID,1)%����ÿ���켣    ����ͻ����Ϊ%for ID = 1:size(ID_mutation,1)%
    index = test_ID(ID,2);%�켣ID
    index_in = test_ID(ID,3); %�켣��ID
    %     index = ID_mutation(ID,1);
    %     index_in = ID_mutation(ID,2);
    %         index = 272; %78;%90
    %     index_in = 32;%20; %86
    %%% ��ȡ����������%������������ʱ_ʹ��
    %    index = 196;
    %    index_in = 1;
    extract_trajectory = input((input(:,1) == index),:);%��ȡ�켣���Ϊindex�Ĺ�
    if index_in+perception_time > size(extract_trajectory,1) %��ʣ��켣�㲻������Ԥ�ⲽ���ڣ��������ô�ѭ��
        continue
    end
    extract_trajectory = extract_trajectory(index_in:index_in+perception_time-1,:);%��ȡԤ��켣
    
    %% ��ʼ����
    global extract_one
    extract_one = extract_trajectory(1,:);%��ǰʱ�̵�״̬����
    %     try
    tic
    global Parameter
    %       Parameter = Parameter_cal;%�궨�Ĳ���
    Parameter = [1 0.8 1 5 0.2 0.12 1 5 0.2 0.03]; %�ֶ���Ĳ���(10��)  Parameter = [1 0.8 1 5 0.2 0.12 1 5 0.2 0.03];%�����ʱ����Ĳ�����202107022��
    %       ���������й켣����ȥѡ��
    [possible_points,status ] = Batch_trajectory_generation(extract_one,perception_time,0.4,mmax,mmin);%һ���Ե���py�ļ����������п�ѡ�켣   0.4��Ǳ���յ�ֱ���  3�Ǻ���Χ�����
    disp(status)
    if status ~= 0 %�ж�һ���Ƿ���óɹ��������ɹ��������ô�ѭ��
        continue
    end
    %������������һ��ѡ��������õ�������1�������޸�
    [OPT,EXITFLAG,optimal_solution,const_output,ID_best_inOPT,ID_best_inDis] = Exhaustion_Method(perception_time,possible_points,1,mmax,mmin);% �������ѧϰ���������켣������ٷ��������
    where_best = [where_best;ID_best_inOPT];%��ʵֵ�ڵڼ�λ
    where_OPT = [where_OPT;ID_best_inDis];%��ѡֵ����ֵ�ĵڼ�λ
    where_const = [where_const const_output];%ÿ�������������У�-1��ʾ����Լ����1��ʾ������Լ��
    data_EXITFLAG =[data_EXITFLAG;EXITFLAG  ];%-2��ʾδ�ҵ����е�
    toc
    %     catch
    %           continue
    %     end
    %     test_result_precessing = [[floor(ID/(perception_time+1)) index index_in OPT]];
    test_result_no = [test_result_no;[size(where_best,1) index index_in OPT sum(sign(const_output))]];%index�ǹ켣��ţ�index_in�ǹ켣��Ԥ���ı�ţ� OPT���Ż���ļ��ٶȼ���
    disp(['�����',num2str(ID/size(test_ID,1)*100),'%'])
end


%%  �������
% ID_check = find(test_result_no(:,2)==497)%&test_result_no(:,3)==40)

MDE_no = [];%��¼ƽ���������
ILP = [];
FDE_no = [];%����������
dele_j = [];
accuracy_if_all = [];%���׼ȷ��
accuracy_all = [];%������
Type_All = [];%��ų�������
test_result_precessing = test_result_no;

for i = 1:size(test_result_precessing,1)
    index_ce = find(input(:,1)==test_result_precessing(i,2)&(input(:,2)==test_result_precessing(i,3)));
    Truth_no = input(index_ce : index_ce + perception_time-1,:);%��ʵ�켣
    predicted_trajectory = reshape(test_result_precessing(i,4:size(test_result_precessing,2)-1), [] , 2);%reshpe�����У���1����[1x��2x��3x]����2����[1y��2y��3y]
    predicted_trajectory(1,1:2) = Truth_no(1,4:5);%���������ִ��󣬽����ֱ�Ӹ���һ��Ԥ��㣻
    %      Type_All = [Type_All; E_trajectory(find((E_trajectory(:,1)==test_result_precessing(i,2))&(E_trajectory(:,2)==test_result_precessing(i,3))),14)];
    %     [ILP_single] = LIP_cal(Truth_no(:,4:5),output1,0);
    %     [ang_dis] = Curvature_dis(Truth_no(:,4:5),output1);%�µ���Ϊ���Ƽ��㷽����δ��ɣ���
    %     [accuracy_if,accuracy] = cross_dis(Truth_no(:,4:5),output1);%��Ի�������ļ������ƫ���Ƿ�Ԥ��׼ȷ����׼�ǳ���1.5��������0.5����
    %       interAll = Truth_no;
    %       interAll(:,1:14) = [];%ȥ��������ͽ�������
    %
    %       hold on
    figure(1)
    clf
    %     for j =1:perception_time
    %         inter_one = reshape(interAll(j,:)',11,[])';
    %         inter_one(all(inter_one==0,2),:)=[];
    %         hold on
    scatter(Truth_no(:,4),Truth_no(:,5),50,'*','b')  %��ʵ�켣
    hold on
    scatter(predicted_trajectory(:,1),predicted_trajectory(:,2),50,'*','black')  %o v *   %Ԥ��켣
    hold off
    %         axis([-50 -0 10 30]);
    %         hold on
    %         scatter(inter_one(:,1),inter_one(:,2),ones(size(inter_one,1),1)*50,50,'*','b')  %o v *   %�����켣
    pause(1)
    %     i = i+ 1;
    %         trend_points = Truth_no;%δ   trend_points = [Truth_no(9,4:5);Truth_no(17,4:5);Truth_no(25,4:5);Truth_no(size(Truth_no,1),4:5)];%δ������֪��
    %         output1_part = predicted_trajectory;%δ
    %         ADE(trend_points(2:size(trend_points,1),4:5),output1_part(2:size(output1_part,1),:))
    %     end
    %     set(gcf,'color','none')
    %     set(gca,'color','none')
    %     legend('trurth behavior','prediction behavior','prediction behavior','prediction behavior')
    %     set(gca,'FontSize',15,'LineWidth',0.5,'FontName','Times New Roman')
    %     title(['i����',num2str(i),'  ƽ���������Ϊ',num2str(ADE(Truth_no(:,4:5),output1)),'  ILPΪ',num2str(ILP_single),'  ��״��Ϊ',num2str(ang_dis)]);
    %     pause(2)
    %     disp(ADE(Truth_no(:,4:5),output1))
    %     disp('������')
    %     disp(max(output2(:,1)));
    %     disp(max(output2(:,2)));
    %����켣�ǹ���������ȷ
    %     abs(max(Truth_no(:,5))-min(Truth_no(:,5)))
    %��������
    dis_head = [];
    dis_head_pre = [];
    for h = 1:perception_time-1
        dis_head = [dis_head;(Truth_no(h,4)-Truth_no(h+1,4))];
        dis_head_pre = [dis_head_pre;(predicted_trajectory(h,1)-predicted_trajectory(h+1,1))];
    end
    if (sum(sign(dis_head))~=perception_time-1)||(sum(sign(dis_head_pre))~=perception_time-1)
        dele_j = [dele_j i];
    end
    trend_points = Truth_no;%δ   trend_points = [Truth_no(9,4:5);Truth_no(17,4:5);Truth_no(25,4:5);Truth_no(size(Truth_no,1),4:5)];%δ������֪��
    output1_part = predicted_trajectory;%δ
    [MDE_no] = [MDE_no ; ADE(trend_points(2:size(trend_points,1),4:5),output1_part(2:size(output1_part,1),:))];%����ƽ���������  % [MDE_no] = [MDE_no ; ADE(trend_points(2:size(trend_points,1),:),output1(2:size(output1,1),:))];%����ƽ���������
    [FDE_no] = [FDE_no ; ADE(trend_points(size(trend_points,1),4:5),output1_part(size(output1_part,1),:))];%����ƽ���������
    [ILP_single] = LIP_cal(trend_points(:,4:5),output1_part,0);   % [ILP_single] = LIP_cal(trend_points,output1,0);
    ILP = [ILP;ILP_single];
    %     accuracy_if_all = [accuracy_if_all;accuracy_if];
    %     accuracy_all = [accuracy_all;accuracy];
end
% mean(MDE_no(Type_All==1))
% mean(FDE_no(Type_All==1))
% mean(ILP(Type_All==1))

mean(MDE_no)
mean(FDE_no)
mean(ILP)
% �鿴Ч�ú����ĵ����ӣ���������ú�Ч�ú���ѡ����
figure(2)
hist(MDE_no)
where_best_hand = where_best;
where_best_hand(find(where_best_hand>100),:)=[];
E_trajectory(find(abs(E_trajectory(:,11))>2),:)=[];
figure(3)
hist(where_best_hand)  %��ʵֵ��fit����Ĵ���ֲ�
% size(find((1<=where_best_hand)&(where_best_hand<=1)),1)/63  %�鿴
figure(4)
hist(where_OPT,20)  %��ѡֵ����ʵֵ�Ĵ���ֲ�
% size(find(where_OPT==1),1)/63  %�鿴��ѡ�켣�ǵڼ�λ����ʵ�켣��
save('result˫��ģ��17������������Ϊ0_4�ֱ���(20211227_1)')
disp('the job is done!!!')
toc
%
% % ����
% %% һЩ����
% %�鿴Լ����������ĸ���
size(find(sign(where_const(5,:))==-1),2)/24
% %% �ҵ������ͻ����Ϊ
% MDE_no_mutation = [];
% FDE_no_mutation =[];
% ILP_mutation =[];
% curvature_Truth_all = [];
% Type_mutation =[];
% ID_mutation = [];  %�Դ�������ΪΪ��׼��ͻ����ΪID
% MDE_no_lateral = [];
% FDE_no_lateral =[];
% ILP_lateral =[];
% Type_lateral_displacement =[];
% ID_lateral_displacement =[];%�Ժ���ƫ��Ϊ��ע��ͻ����ΪID
% lateral_displacement_all =[];
% for i = 1:size(test_result_precessing,1)
%     index_ce = find(input(:,1)==test_result_precessing(i,2)&(input(:,2)==test_result_precessing(i,3)));
%     Truth_no = input(index_ce : index_ce + perception_time-1,:);%��ʵ�켣
%     predicted_trajectory = reshape(test_result_precessing(i,4:size(test_result_precessing,2)-1), [] , 2);%reshpe�����У���1����[1x��2x��3x]����2����[1y��2y��3y]
%     predicted_trajectory(1,1:2) = Truth_no(1,4:5);%���������ֳ��壬�����ֱ�Ӹ���һ��Ԥ��㣻
%     trend_points = Truth_no;%��ʵ�켣
%     output1_part = predicted_trajectory;%Ԥ��켣
%     % ��������ʵ�켣�ҵ�ͻ����Ϊ
%     curvature_Truth = mean(abs(trend_points(:,13)));%����Ϊƽ�����ʳ���һ���޶ȵĹ켣
%     [curvature_Truth_all] =[curvature_Truth_all; curvature_Truth];%���ÿ��ͻ����Ϊ��ƽ������
%     if curvature_Truth>=0.05 %���ƽ�����ʳ�������޶ȣ����ó���������ͻ����Ϊ
%         ID_mutation = [ID_mutation; test_result_precessing(i,2:3)];%��ȡͻ����Ϊ�����
%         Type_mutation = [Type_mutation; E_trajectory(find((E_trajectory(:,1)==test_result_precessing(i,2))&(E_trajectory(:,2)==test_result_precessing(i,3))),14)];
%         [MDE_no_mutation] = [MDE_no_mutation ; ADE(trend_points(2:size(trend_points,1),4:5),output1_part(2:size(output1_part,1),:))];%����ƽ���������  % [MDE_no] = [MDE_no ; ADE(trend_points(2:size(trend_points,1),:),output1(2:size(output1,1),:))];%����ƽ���������
%         [FDE_no_mutation] = [FDE_no_mutation ; ADE(trend_points(size(trend_points,1),4:5),output1_part(size(output1_part,1),:))];%����ƽ���������
%         [ILP_mutation] = [ILP_mutation; LIP_cal(trend_points(:,4:5),output1_part,0)];
% %         figure(2)
% %         clf
% %         scatter(trend_points(:,4),trend_points(:,5),50,'*','b')  %��ʵ�켣
% %         hold on
% %         scatter(output1_part(:,1),output1_part(:,2),50,'*','r')  %o v *   %Ԥ��켣
% %         pause(1)
%     end
%     lateral_displacement_Truth = (abs(max(trend_points(:,5))-min(trend_points(:,5))));%����Ϊ����ƫ�ƱȽϴ�Ĺ켣
%     [lateral_displacement_all] = [lateral_displacement_all; lateral_displacement_Truth];
%     if lateral_displacement_Truth>0.5
%         ID_lateral_displacement = [ID_lateral_displacement; test_result_precessing(i,2:3)];%��ȡ����ƫ����Ϊ�����
%         Type_lateral_displacement = [Type_lateral_displacement; E_trajectory(find((E_trajectory(:,1)==test_result_precessing(i,2))&(E_trajectory(:,2)==test_result_precessing(i,3))),14)];
%         [MDE_no_lateral] = [MDE_no_lateral ; ADE(trend_points(2:size(trend_points,1),4:5),output1_part(2:size(output1_part,1),:))];%����ƽ���������  % [MDE_no] = [MDE_no ; ADE(trend_points(2:size(trend_points,1),:),output1(2:size(output1,1),:))];%����ƽ���������
%         [FDE_no_lateral] = [FDE_no_lateral ; ADE(trend_points(size(trend_points,1),4:5),output1_part(size(output1_part,1),:))];%����ƽ���������
%         [ILP_lateral] = [ILP_lateral; LIP_cal(trend_points(:,4:5),output1_part,0)];
% %         figure(3)
% %         clf
% %         scatter(trend_points(:,4),trend_points(:,5),50,'o','b')  %��ʵ�켣
% %         hold on
% %         scatter(output1_part(:,1),output1_part(:,2),50,'o','r')  %o v *   %Ԥ��켣
% %         pause(1)
%     end
% %     i=i+1
% end
%
% %���㳵�������ԵĴ�������Ϊ
% mean(MDE_no_mutation(Type_mutation==1))%2�Ǽ���綯��   1�Ǽ���������
% mean(FDE_no_mutation(Type_mutation==1))
% mean(ILP_mutation(Type_mutation==1))
%
% %�����ܵĴ�������Ϊ
% mean(MDE_no_mutation)
% mean(FDE_no_mutation)
% mean(ILP_mutation)
% hist(curvature_Truth_all)
%
% %���㳵�������Եĺ���ƫ����Ϊ
% mean(MDE_no_lateral(Type_lateral_displacement==2))
% mean(FDE_no_lateral(Type_lateral_displacement==2))
% mean(ILP_lateral(Type_lateral_displacement==2))
%
% %�����ܵĺ���ƫ����Ϊ
% mean(MDE_no_lateral)
% mean(FDE_no_lateral)
% mean(ILP_lateral)
%
%
% %% ����ͻ����Ϊ��׼ȷ��
%
%
%
% %% % % %ɾ��һЩ��������
% % dele_i = find(MDE_no(:,1)>1.5);
% dele_i = dele_j;
% MDE_no(dele_i,:) = [];
% ILP(dele_i,:) = [];
% FDE_no(dele_i,:) = [];
% % ang_dis_all(dele_i,:) = [];
% test_result_no(dele_i,:) = [];
% test_result_precessing(dele_i,:) = [];
% data_EXITFLAG(dele_i,:) = [];
% % %ɾ������
% hist(MDE_no)
% toc
% mean(MDE_no)
% mean(FDE_no)
% mean(ILP)
%
% save('result˫��ģ��(20210917_2)')
% disp('the job is done��!!')
% % ����������
% % find((ang_dis_all<0.01))%�ҵ������������ͳ������ض����Ĺ켣
% %% �ּ�������������͡��ǻ��������ڲ��Լ����˲����͵�����
% ID_intruse_V = [];%��Ż����������͸���ID
% ID_intruse_P = [];%������˲����͸���ID
% ID_in_NV = [];%��ŷǻ������ڲ�����ID
% for i =1:size(test_result_precessing,1)
%     index_ce = find(input(:,1)==test_result_precessing(i,2)&(input(:,2)==test_result_precessing(i,3)));
%     Truth_no = input(index_ce : index_ce + perception_time,:);%��ʵ�켣
%     dis_line = min(Truth_no(:,5))-22;
%     if dis_line<0
%         ID_intruse_V = [ID_intruse_V; i];
%     elseif (min(Truth_no(:,5))-22)>=0&&(max(Truth_no(:,5))-26)<=0
%         ID_in_NV = [ID_in_NV; i];
%     elseif (max(Truth_no(:,5))-26)>0
%         ID_intruse_P = [ID_intruse_P; i];
%     end
% end
% %% �������ֺͷ��طּ�
% ID_intruse_V_in = [];%�������
% ID_intruse_V_out = [];%��ŷ���
% for i = 1:size(ID_intruse_V,1)
%     if data_test((ID_intruse_V(i)*26-20),5)-data_test((ID_intruse_V(i)*26-5),5)>=0%�ҵ���Ӧ�Ĺ켣,��>=0����˵��������
%         ID_intruse_V_in = [ID_intruse_V_in;ID_intruse_V(i)];
%     else
%         ID_intruse_V_out = [ID_intruse_V_out;ID_intruse_V(i)];
%     end
% end
% disp(['������������ƽ��MLIP���Ϊ',num2str(mean(ILP(ID_intruse_V_in,:)))])
% disp(['�������෵��ƽ��MLIP���Ϊ',num2str(mean(ILP(ID_intruse_V_out,:)))])
% % hist(ILP(ID_intruse_V_in,:))%������������MLIP��histͼ
% % title('�����������ַǻ�����ƽ��MLIP���ֲ�')
% % hist(ILP(ID_intruse_V_out,:))%�������෵�ص�MLIP��histͼ
% % title('�������෵�طǻ�����ƽ��MLIP���ֲ�')
%
% %%
% disp(['��������ƽ��MLIP���Ϊ',num2str(mean(ILP(ID_intruse_V,:)))])
% disp(['���˲�ƽ��MLIP���Ϊ',num2str(mean(ILP(ID_intruse_P,:)))])
% disp(['�ǻ������ڲ�ƽ��MLIP���Ϊ',num2str(mean(ILP(ID_in_NV,:)))])
% disp(['��������׼ȷ��Ϊ',num2str(sum(accuracy_if_all(ID_intruse_V,:))/(size(accuracy_if_all(ID_intruse_V,:),1)))])%�����������ͻ����Ϊ�ĵ�ģ��Ԥ��׼ȷ�ԣ�ͨ�����Һ������ȷ����
% disp(['��������������Ϊ׼ȷ��Ϊ',num2str(sum(accuracy_if_all(ID_intruse_V_in,:))/(size(accuracy_if_all(ID_intruse_V_in,:),1)))])%   %ID_intruse_V_in
% disp(['�������෵����Ϊ׼ȷ��Ϊ',num2str(sum(accuracy_if_all(ID_intruse_V_out,:))/(size(accuracy_if_all(ID_intruse_V_out,:),1)))])%   %ID_i
% hist(accuracy_all);%������Ϊ�����
% title('ͻ����Ϊ�¼����ֲ�')
% hist(accuracy_all(ID_intruse_V_in));%������Ϊ�����
% title('������Ϊ�¼����ֲ�')
% hist(accuracy_all(ID_intruse_V_out));%������Ϊ�����
% title('������Ϊ�¼����ֲ�')
%
%
% effet = ID_intruse_V(find((ILP(ID_intruse_V,:)<=0.4)&(ILP(ID_intruse_V,:)>0.0)),:)%�ҵ������������ͳ������ض����Ĺ켣
% size(effet,1)/size(ILP(ID_intruse_V,:),1)%MLIPС��0.2�ĸ��ʣ�
% hist(ILP(ID_intruse_V,:))%���������MLIP��histͼ
% title('�����������г���ƽ��MLIP���ֲ�')
%
% %% ���ճ��������Էּ�
% ID_intruse_V_EB = [];%��Ż�������ĵ綯�����
% ID_intruse_V_RB = [];%��Ż�������������������
%
% for i = 1:size(ID_intruse_V,1)
%     if data_test((ID_intruse_V(i)*26-5),14)==2%�ҵ���Ӧ�Ĺ켣�Ĺ켣��,��==2����Ϊ�綯��
%         ID_intruse_V_EB = [ID_intruse_V_EB;ID_intruse_V(i)];
%     else
%         ID_intruse_V_RB = [ID_intruse_V_RB;ID_intruse_V(i)];
%     end
% end
% disp(['��������綯����Ϊ׼ȷ��Ϊ',num2str(sum(accuracy_if_all(ID_intruse_V_EB,:))/(size(accuracy_if_all(ID_intruse_V_EB,:),1)))])%   %�ɿ���  �綯��
% disp(['����������������Ϊ׼ȷ��Ϊ',num2str(sum(accuracy_if_all(ID_intruse_V_RB,:))/(size(accuracy_if_all(ID_intruse_V_RB,:),1)))])%   %�ɿ���  �������г�
% hist(accuracy_all(ID_intruse_V_EB));%�綯�������
% title('�綯��ͻ����Ϊ�¼����ֲ�')
% hist(accuracy_all(ID_intruse_V_RB));%�����������
% title('������ͻ����Ϊ�¼����ֲ�')
% %%
% disp(['��������綯��ƽ��MLIP���Ϊ',num2str(mean(ILP(ID_intruse_V_EB,:)))])
% disp(['���������������г�ƽ��MLIP���Ϊ',num2str(mean(ILP(ID_intruse_V_RB,:)))])
% hist(ILP(ID_intruse_V_EB,:))%��������綯����MLIP��histͼ
% title('��������綯���г�ƽ��MLIP���ֲ�')
% hist(ILP(ID_intruse_V_RB,:))%���������������г���MLIP��histͼ
% title('�������ೣ�����г���ƽ��MLIP���ֲ�')
%
% size(ILP(ID_in_NV,:))
% % nu_e = 0;%�綯������
% % nu_h = 0;%�������г�����
% % for i = 1:size(ID_intruse_V,1)
% %     if data_test(i*26+2,14)==2%�綯��
% %         nu_e = nu_e+1;
% %     elseif data_test(i*26+2,14)==1%�������г�
% %         nu_h = nu_h+1;
% %     end
% % end
%
%
%
% %
% %% % %�ҵ�û�п��н�ģ����Ƿ������������������
% % un_MDE_no = [];
% % un_FDE_no = [];
% % un_ILP = [];
% % yes_MDE_no = [];
% % yes_FDE_no = [];
% % yes_ILP = [];
% % for i = 1:size(data_EXITFLAG,1)
% %     if data_EXITFLAG(i)==-2
% %         un_MDE_no = [un_MDE_no;MDE_no(i)];
% %         un_FDE_no = [un_FDE_no;FDE_no(i)];
% %         un_ILP = [un_ILP;ILP(i)];
% %     else
% %         yes_MDE_no = [yes_MDE_no;MDE_no(i)];
% %         yes_FDE_no = [yes_FDE_no;FDE_no(i)];
% %         yes_ILP = [yes_ILP;ILP(i)];
% %     end
% % end
% % disp(['���Ž�ͷǿ��н��ƽ���������Ϊ',num2str(mean(yes_MDE_no)),'��',num2str(mean(un_MDE_no))]);
% % disp(['���Ž�ͷǿ��н��ƽ��ILPΪ',num2str(mean(yes_ILP)),'��',num2str(mean(un_ILP))]);
% % disp(['���Ž�ͷǿ��н��ƽ���������Ϊ',num2str(mean(yes_FDE_no)),'��',num2str(mean(un_FDE_no))]);
% % % %�鿴����
% % ILP(find(isnan(ILP)),:)=[];
% %% ����
% save('resultȡ��������������������ʹ������(20210719_1)')
% disp('the job is done��!!')
% disp(['ƽ���������Ϊ',num2str(mean(MDE_no))])
% disp(['MLIPֵΪ',num2str(mean(ILP))])
% disp(['���վ������Ϊ',num2str(mean(FDE_no))])
% MDE_sort = sort(MDE_no);
% % hist(ILP)
% % hist(MDE_no)
% %% �ҵ�ƫ�ƱȽϴ��
% ID_abrupt = [];
% dis_abrupt = [];
% % test_result_no
% for i = 1:size(test_result_no,1)
%     ID_intr = find((E_trajectory(:,1)==test_result_no(i,2))&(E_trajectory(:,2)==test_result_no(i,3)));
%     drow = E_trajectory(ID_intr:ID_intr+20,:);
%     V_zeros = ((sum(sign(drow(:,7))>0))/size(drow,1));%���Һ����ٶȵ�ռ��
%     dis_S_E = abs(max(drow(:,5))-min(drow(:,5)));
%     dis_abrupt = [dis_abrupt;dis_S_E];
%     if dis_S_E>2  %V_zeros >0.4&&V_zeros <0.6&&dis_S_E>2
%         ID_abrupt = [ID_abrupt ; i];
%     end
% end
% hist(dis_abrupt)
%
% MDE_no_abrupt = (MDE_no(ID_abrupt,:));%MDE_no_abrupt(12,:)=[];
% FDE_no_abrupt = (FDE_no(ID_abrupt,:));%FDE_no_abrupt(12,:)=[];
% ILP_abrupt = (ILP(ID_abrupt,:));%ILP_abrupt(12,:) = [];
% mean(MDE_no_abrupt)
% mean(FDE_no_abrupt)
% mean(ILP_abrupt)