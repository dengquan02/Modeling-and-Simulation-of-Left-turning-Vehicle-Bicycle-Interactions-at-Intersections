
%% ���Լ���
tic
result_0724= [];%��¼������
%���ݲ���ȫ������
%  input = E_trajectory;

%���ݲ��ò�������
% global data_test
input = data_test;%���ݲ��ò���ͻ����Ϊ����

% �����￪ʼ
% input = Truth_no;%�������ѡ�е�һ���켣��

%���ݲ���ȫ��ͻ������
%   global data_cal
%   input = data_cal;%���ݲ��ò���ͻ����Ϊ����
  
%input = trajectory_block;%���ݲ���ȫ������
% index_all = randperm(input(size(input,1),1),round(input(size(input,1),1)*0.3));%�����������ѡ��30%�Ĺ켣�����м���
% index_test = 1:(size(data_test,1)/perception_time);%����ͻ����Ϊ���ݵ����
Parameter_cal = csvread('Parameter_cal_store.csv');%���ѱ��������ж�ȡ��׼��Ϣ
data_EXITFLAG = [];%��¼GA���˳�����
% for ID = 1:(perception_time+1):size(input,1)%����ÿ���켣   %for ID = 1:size(index_test,2)%����ÿ���켣
   
    %% ����
  for index_0 = 1:size(test_result_no,1)
   index = test_result_no(index_0,2);
   index_in = test_result_no(index_0,3);
   extract_trajectory = E_trajectory((E_trajectory(:,1)==index),:);%��ȡ�켣���Ϊindex�Ĺ�
   extract_trajectory = extract_trajectory (index_in:index_in+perception_time,:);%��ȡ�켣���Ϊindex�Ĺ�
   
   %% ��ʼ����
    global extract_one
    extract_one = extract_trajectory(1,:);%ÿ֡����
    try
       tic
       global Parameter
%        Parameter = Parameter_cal;%�궨�Ĳ���
      Parameter = [1 0.8 1 5 0.2 0.12 1 5 0.2 0.03];%�ֶ���Ĳ���(10��)  Parameter = [1 0.8 1 5 0.2 0.12 1 5 0.2 0.03];%�����ʱ����Ĳ�����202107022��
       MyGA;%���Ŵ��㷨���
%        MyGa_Moeth3;%����3���
        data_EXITFLAG =[data_EXITFLAG;EXITFLAG  ];%-2��ʾδ�ҵ����е�
       toc
    catch
          continue
    end
%     test_result_precessing = [[floor(ID/(perception_time+1)) index index_in OPT]];
    result_0724 = [result_0724;[floor(ID/(perception_time+1)) index index_in OPT]];%index�ǹ켣��ţ�index_in�ǹ켣��Ԥ���ı�ţ� OPT���Ż���ļ��ٶȼ��� 
    disp(['�����',num2str(ID/size(input,1)*100),'%'])
end
toc
save('result���ҳ�����Ϊ�ɹ���(20210725_1)')
disp('the jag will been done!!!')
%% 
% ID_check = find(test_result_no(:,2)==497)%&test_result_no(:,3)==40)
MDE_no = [];%��¼ƽ���������
ILP = [];
FDE_no = [];%����������
dele_j = [];
ang_dis_all = [];%���������ʲ�,Խ��Խ��
accuracy_if_all = [];%���׼ȷ��
accuracy_all = [];%������
test_result_precessing = result_0724;
type_input=[];
for i =1:size(test_result_precessing,1)  %i =1%:size(test_result_precessing,1)  % 
    index_ce = find(input(:,1)==test_result_precessing(i,2)&(input(:,2)==test_result_precessing(i,3)));
    Truth_no = input(index_ce : index_ce + perception_time,:);%��ʵ�켣 
    [inter_extract,output,output1,output2] = Excur_predict_2(test_result_precessing(i,4:size(test_result_precessing,2)),Truth_no(1,:),Truth_no,perception_time);%%output��Ŀ��ֵ��output1�������Ԥ��㣻output2������ķ���ֵ��
%     [ILP_single] = LIP_cal(Truth_no(:,4:5),output1,0);
    [MDE_no] = [MDE_no ; ADE(Truth_no(:,4:5),output1)];%����ƽ���������   
    [FDE_no] = [FDE_no ; ADE(Truth_no(size(Truth_no,1),4:5),output1(size(Truth_no,1),:))];%����ƽ���������   
    type_input = [type_input;Truth_no(1,14)];
    figure(2)
    clf
    for j =1:perception_time
        scatter(Truth_no(j+1,4),Truth_no(j+1,5),50,'+','b')  %��ʵ�켣
        hold on
        scatter(output1(j+1,1),output1(j+1,2),50,'*','r')  %o v *   %Ԥ��켣
    end
    hold on
    scatter(inter_extract(:,1),inter_extract(:,2),'*','black');%��������
    title(['i����',num2str(i)]) 
%     i = i + 1;
%     set(gcf,'color','none')
%     set(gca,'color','none')
%     axis([-50 -20 15 25]);
%     legend('trurth behavior','prediction behavior','prediction behavior','prediction behavior')
%     set(gca,'FontSize',15,'LineWidth',0.5,'FontName','Times New Roman')
%     title(['i����',num2str(i),'  ƽ���������Ϊ',num2str(ADE(Truth_no(:,4:5),output1)),'  ILPΪ',num2str(ILP_single),'  ��״��Ϊ',num2str(ang_dis)]);
%     pause(3)
% % %     disp(ADE(Truth_no(:,4:5),output1))
%     disp('������')
%     disp(max(output2(:,1)));
%     disp(max(output2(:,2)));
    %����켣�ǹ���������ȷ
%     abs(max(Truth_no(:,5))-min(Truth_no(:,5)))
     %��������
    dis_head = [];
    for h = 1:perception_time
        dis_head = [dis_head;(Truth_no(h,4)-Truth_no(h+1,4))];
    end
    if sum(sign(dis_head))~=perception_time
       dele_j = [dele_j i];
    end
    [MDE_no] = [MDE_no ; ADE(Truth_no(:,4:5),output1)];%����ƽ���������   
    [FDE_no] = [FDE_no ; ADE(Truth_no(size(Truth_no,1),4:5),output1(size(Truth_no,1),:))];%����ƽ���������   
%     ILP = [ILP;ILP_single];
%     ang_dis_all = [ang_dis_all;ang_dis];
%     accuracy_if_all = [accuracy_if_all;accuracy_if];
%     accuracy_all = [accuracy_all;accuracy];
end
save('result���ҳ�����Ϊ�ɹ���(20210725_1)')
disp('the jag has been done!!!')
%% % % %ɾ��һЩ��������
% dele_i = find(MDE_no(:,1)>1.5);
dele_i = dele_j;
MDE_no(dele_i,:) = [];
ILP(dele_i,:) = [];
FDE_no(dele_i,:) = [];
ang_dis_all(dele_i,:) = [];
result_0724(dele_i,:) = [];
test_result_precessing(dele_i,:) = [];
data_EXITFLAG(dele_i,:) = [];
% %ɾ������

save('resultȡ��·���Ż�(20210720_1)')
disp('the job is done��!!')
����������

%% �ҵ�һЩ��������  ������  i=261
inde = 1;
type_input = [];
for i = 1 :26: size(input,1)
%     scatter(input(i:i+25,4),input(i:i+25,5),'r','*');
%     title(['i����',num2str(inde),'������',num2str(input(i,14))]);
%     inde = inde + 1;
%     pause(3);
    type_input  = [type_input ; input(i,14)];
end
% find((ang_dis_all<0.01))%�ҵ������������ͳ������ض����Ĺ켣
%% �ּ�������������͡��ǻ��������ڲ��Լ����˲����͵�����
ID_intruse_V = [];%��Ż����������͸���ID
ID_intruse_P = [];%������˲����͸���ID
ID_in_NV = [];%��ŷǻ������ڲ�����ID
for i =1:size(test_result_precessing,1)
    index_ce = find(input(:,1)==test_result_precessing(i,2)&(input(:,2)==test_result_precessing(i,3)));
    Truth_no = input(index_ce : index_ce + perception_time,:);%��ʵ�켣
    dis_line = min(Truth_no(:,5))-22;
    if dis_line<0
        ID_intruse_V = [ID_intruse_V; i];
    elseif (min(Truth_no(:,5))-22)>=0&&(max(Truth_no(:,5))-26)<=0
        ID_in_NV = [ID_in_NV; i];
    elseif (max(Truth_no(:,5))-26)>0
        ID_intruse_P = [ID_intruse_P; i];
    end
end
%% �������ֺͷ��طּ�
ID_intruse_V_in = [];%�������
ID_intruse_V_out = [];%��ŷ���
for i = 1:size(ID_intruse_V,1)
    if data_test((ID_intruse_V(i)*26-20),5)-data_test((ID_intruse_V(i)*26-5),5)>=0%�ҵ���Ӧ�Ĺ켣,��>=0����˵��������
        ID_intruse_V_in = [ID_intruse_V_in;ID_intruse_V(i)];
    else
        ID_intruse_V_out = [ID_intruse_V_out;ID_intruse_V(i)];
    end
end
disp(['������������ƽ��MLIP���Ϊ',num2str(mean(ILP(ID_intruse_V_in,:)))])
disp(['�������෵��ƽ��MLIP���Ϊ',num2str(mean(ILP(ID_intruse_V_out,:)))])
% hist(ILP(ID_intruse_V_in,:))%������������MLIP��histͼ  
% title('�����������ַǻ�����ƽ��MLIP���ֲ�')
% hist(ILP(ID_intruse_V_out,:))%�������෵�ص�MLIP��histͼ
% title('�������෵�طǻ�����ƽ��MLIP���ֲ�')

%%
disp(['��������ƽ��MLIP���Ϊ',num2str(mean(ILP(ID_intruse_V,:)))])
disp(['���˲�ƽ��MLIP���Ϊ',num2str(mean(ILP(ID_intruse_P,:)))])
disp(['�ǻ������ڲ�ƽ��MLIP���Ϊ',num2str(mean(ILP(ID_in_NV,:)))])
disp(['��������׼ȷ��Ϊ',num2str(sum(accuracy_if_all(ID_intruse_V,:))/(size(accuracy_if_all(ID_intruse_V,:),1)))])%�����������ͻ����Ϊ�ĵ�ģ��Ԥ��׼ȷ�ԣ�ͨ�����Һ������ȷ����
disp(['��������������Ϊ׼ȷ��Ϊ',num2str(sum(accuracy_if_all(ID_intruse_V_in,:))/(size(accuracy_if_all(ID_intruse_V_in,:),1)))])%   %ID_intruse_V_in
disp(['�������෵����Ϊ׼ȷ��Ϊ',num2str(sum(accuracy_if_all(ID_intruse_V_out,:))/(size(accuracy_if_all(ID_intruse_V_out,:),1)))])%   %ID_i
hist(accuracy_all);%������Ϊ�����
title('ͻ����Ϊ�¼����ֲ�')
hist(accuracy_all(ID_intruse_V_in));%������Ϊ�����
title('������Ϊ�¼����ֲ�')
hist(accuracy_all(ID_intruse_V_out));%������Ϊ�����
title('������Ϊ�¼����ֲ�')


effet = ID_intruse_V(find((ILP(ID_intruse_V,:)<=0.4)&(ILP(ID_intruse_V,:)>0.0)),:)%�ҵ������������ͳ������ض����Ĺ켣
size(effet,1)/size(ILP(ID_intruse_V,:),1)%MLIPС��0.2�ĸ��ʣ�
hist(ILP(ID_intruse_V,:))%���������MLIP��histͼ
title('�����������г���ƽ��MLIP���ֲ�')

%% ���ճ��������Էּ�
ID_intruse_V_EB = [];%��Ż�������ĵ綯�����
ID_intruse_V_RB = [];%��Ż�������������������

for i = 1:size(ID_intruse_V,1)
    if data_test((ID_intruse_V(i)*26-5),14)==2%�ҵ���Ӧ�Ĺ켣�Ĺ켣��,��==2����Ϊ�綯��
        ID_intruse_V_EB = [ID_intruse_V_EB;ID_intruse_V(i)];
    else
        ID_intruse_V_RB = [ID_intruse_V_RB;ID_intruse_V(i)];
    end
end
disp(['��������綯����Ϊ׼ȷ��Ϊ',num2str(sum(accuracy_if_all(ID_intruse_V_EB,:))/(size(accuracy_if_all(ID_intruse_V_EB,:),1)))])%   %�ɿ���  �綯��
disp(['����������������Ϊ׼ȷ��Ϊ',num2str(sum(accuracy_if_all(ID_intruse_V_RB,:))/(size(accuracy_if_all(ID_intruse_V_RB,:),1)))])%   %�ɿ���  �������г�
hist(accuracy_all(ID_intruse_V_EB));%�綯�������
title('�綯��ͻ����Ϊ�¼����ֲ�')
hist(accuracy_all(ID_intruse_V_RB));%�����������
title('������ͻ����Ϊ�¼����ֲ�')
%%
disp(['��������綯��ƽ��MLIP���Ϊ',num2str(mean(ILP(ID_intruse_V_EB,:)))])
disp(['���������������г�ƽ��MLIP���Ϊ',num2str(mean(ILP(ID_intruse_V_RB,:)))])
hist(ILP(ID_intruse_V_EB,:))%��������綯����MLIP��histͼ  
title('��������綯���г�ƽ��MLIP���ֲ�')
hist(ILP(ID_intruse_V_RB,:))%���������������г���MLIP��histͼ
title('�������ೣ�����г���ƽ��MLIP���ֲ�')

size(ILP(ID_in_NV,:))
% nu_e = 0;%�綯������
% nu_h = 0;%�������г�����
% for i = 1:size(ID_intruse_V,1)
%     if data_test(i*26+2,14)==2%�綯��
%         nu_e = nu_e+1;
%     elseif data_test(i*26+2,14)==1%�������г�
%         nu_h = nu_h+1;
%     end
% end
        
        

% 
%% % %�ҵ�û�п��н�ģ����Ƿ������������������
% un_MDE_no = [];
% un_FDE_no = [];
% un_ILP = [];
% yes_MDE_no = [];
% yes_FDE_no = [];
% yes_ILP = [];
% for i = 1:size(data_EXITFLAG,1)
%     if data_EXITFLAG(i)==-2
%         un_MDE_no = [un_MDE_no;MDE_no(i)];
%         un_FDE_no = [un_FDE_no;FDE_no(i)];
%         un_ILP = [un_ILP;ILP(i)];
%     else
%         yes_MDE_no = [yes_MDE_no;MDE_no(i)];
%         yes_FDE_no = [yes_FDE_no;FDE_no(i)];
%         yes_ILP = [yes_ILP;ILP(i)];
%     end
% end
% disp(['���Ž�ͷǿ��н��ƽ���������Ϊ',num2str(mean(yes_MDE_no)),'��',num2str(mean(un_MDE_no))]);
% disp(['���Ž�ͷǿ��н��ƽ��ILPΪ',num2str(mean(yes_ILP)),'��',num2str(mean(un_ILP))]);
% disp(['���Ž�ͷǿ��н��ƽ���������Ϊ',num2str(mean(yes_FDE_no)),'��',num2str(mean(un_FDE_no))]);
% % %�鿴����
% ILP(find(isnan(ILP)),:)=[];
%% ����
save('resultȡ��������������������ʹ������(20210719_1)')
disp('the job is done��!!')
disp(['ƽ���������Ϊ',num2str(mean(MDE_no))])
disp(['MLIPֵΪ',num2str(mean(ILP))])
disp(['���վ������Ϊ',num2str(mean(FDE_no))])
MDE_sort = sort(MDE_no);
% hist(ILP)
% hist(MDE_no)
%% �ҵ�ƫ�ƱȽϴ��
ID_abrupt = [];
dis_abrupt = [];
% test_result_no
for i = 1:size(result_0724,1)
    ID_intr = find((E_trajectory(:,1)==result_0724(i,2))&(E_trajectory(:,2)==result_0724(i,3)));
    drow = E_trajectory(ID_intr:ID_intr+20,:);
    V_zeros = ((sum(sign(drow(:,7))>0))/size(drow,1));%���Һ����ٶȵ�ռ��
    dis_S_E = abs(max(drow(:,5))-min(drow(:,5)));
    dis_abrupt = [dis_abrupt;dis_S_E];
    if dis_S_E>2  %V_zeros >0.4&&V_zeros <0.6&&dis_S_E>2
        ID_abrupt = [ID_abrupt ; i];
    end
end
hist(dis_abrupt)

MDE_no_abrupt = (MDE_no(ID_abrupt,:));%MDE_no_abrupt(12,:)=[];
FDE_no_abrupt = (FDE_no(ID_abrupt,:));%FDE_no_abrupt(12,:)=[];
ILP_abrupt = (ILP(ID_abrupt,:));%ILP_abrupt(12,:) = [];
mean(MDE_no_abrupt)
mean(FDE_no_abrupt)
mean(ILP_abrupt)
% hist(FDE_no_abrupt)
%% ������һ��socai-lstm�����
OUTPUT_socai_LSTM = csvread('output_social_LSTM.csv');
%���ϼ�����֮�����濪ʼ���������
social_LSTM_ILP = [];%��¼ILPֵ
social_LSTM_MDE = [];%��¼ƽ���������
social_LSTM_FDE = [];%��¼ƽ���������
for i=1:40:3880
    [ILP_single_social_LSTM] = LIP_cal([OUTPUT_socai_LSTM(i,5:6) ; OUTPUT_socai_LSTM(i+1:i+20,3:4)],OUTPUT_socai_LSTM(i:i+20,5:6),0);
    MDE_single_social_LSTM = ADE([OUTPUT_socai_LSTM(i,5:6) ; OUTPUT_socai_LSTM(i+1:i+20,3:4)],OUTPUT_socai_LSTM(i:i+20,5:6));
    FDE_single_social_LSTM = ADE( OUTPUT_socai_LSTM(i,3:4),OUTPUT_socai_LSTM(i,5:6));
    social_LSTM_ILP = [social_LSTM_ILP ; ILP_single_social_LSTM];
    social_LSTM_MDE = [social_LSTM_MDE; MDE_single_social_LSTM ];%��¼ƽ���������
    social_LSTM_FDE = [social_LSTM_FDE; FDE_single_social_LSTM ];%��¼���վ������
end
mean(social_LSTM_ILP)
mean(social_LSTM_MDE)
mean(social_LSTM_FDE)
% ����Ĵ���
% scatter(OUTPUT_socai_LSTM(i:i+20,3),OUTPUT_socai_LSTM(i:i+20,4))
%% ������һ��Conv-lstm�����
predictiton_Conv_LSTM = csvread('Conv_LSTM_prediction.csv');
truth_Conv_LSTM = csvread('Conv_LSTM_trutn.csv');
%���¿�ʼ���ݸ�ʽ�����������ֵ
Conv_LSTM_ILP = [];%��¼ILPֵ
Conv_LSTM_MDE = [];%��¼ƽ���������
Conv_LSTM_FDE = [];%��¼���վ������
for i = 1: size(predictiton_Conv_LSTM,1)
    pre_Conv_LSTM_sigle = reshape(predictiton_Conv_LSTM(i,:),9,[])';%����9�е�
    tru_Conv_LSTM_sigle = reshape(truth_Conv_LSTM(i,:),9,[])';%����9�е�
    [ILP_single_Conv_LSTM] = LIP_cal(pre_Conv_LSTM_sigle(20:41,1:2),tru_Conv_LSTM_sigle(20:41,1:2),0);
    MDE_single_Conv_LSTM = ADE(pre_Conv_LSTM_sigle(20:41,1:2),tru_Conv_LSTM_sigle(20:41,1:2));
    FDE_single_Conv_LSTM = ADE(pre_Conv_LSTM_sigle(41,1:2),tru_Conv_LSTM_sigle(41,1:2));%�������վ������
    Conv_LSTM_ILP = [Conv_LSTM_ILP ; ILP_single_Conv_LSTM];%��¼ILPֵ
    Conv_LSTM_MDE = [Conv_LSTM_MDE; MDE_single_Conv_LSTM ];%��¼ƽ���������
    Conv_LSTM_FDE = [Conv_LSTM_FDE; FDE_single_Conv_LSTM ];%��¼ƽ���������
end
mean(Conv_LSTM_ILP)
mean(Conv_LSTM_MDE)
mean(Conv_LSTM_FDE)