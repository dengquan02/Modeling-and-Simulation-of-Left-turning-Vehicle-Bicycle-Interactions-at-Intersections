function [Parameter_cal,FVAL,EXITFLAG,OUTPUT] = Parameter_calibration(E_trajectory)
%% ���¼���һ�¸��������
E_trajectory_reCur = E_trajectory;
Cur = [];
for i =1:E_trajectory(size(E_trajectory,1),1)%��680���켣
    [reCur] = Curvature_calculation(E_trajectory(find(E_trajectory(:,1)==i),4),E_trajectory(find(E_trajectory(:,1)==i),5));  %����켣��x��y������ÿ���������
    figure(1)
    bar(reCur)
    figure(2)
     scatter(E_trajectory(find(E_trajectory(:,1)==i),4),E_trajectory(find(E_trajectory(:,1)==i),5),'*','r');
    reCur = E_trajectory_reCur(find(E_trajectory(:,1)==i),13) ;
    Cur = [Cur;mean(reCur)];%��¼��ÿ���켣��ƽ������
end
Cur(find(abs(Cur)>0.2),:) = [];%ȥ�����ʴ���0.2�ķ��������ݣ�
hist(Cur,100);

%% ����ͻ����Ϊ�������ݵ�ƽ������
global data_test
Cur_intruse = [];
for i =1:(1+perception_time):size(data_test,1)%ÿ26��Ϊһ��
%     [reCur] = Curvature_calculation(E_trajectory(find(E_trajectory(:,1)==i),4),E_trajectory(find(E_trajectory(:,1)==i),5));  %����켣��x��y������ÿ���������
%     figure(1)
%     bar(reCur)
%     figure(2)
%      scatter(E_trajectory(find(E_trajectory(:,1)==i),4),E_trajectory(find(E_trajectory(:,1)==i),5),'*','r');
    reCur_intruse = data_test(i:(i+perception_time),13) ;
    Cur_intruse = [Cur_intruse;mean(reCur_intruse)];%��¼��ÿ���켣��ƽ������
end
min(abs(Cur_intruse))%ͻ����Ϊ����Сƽ������  ���0.0044���ң�
size(Cur(find(abs(Cur)>0.0044),:),1)/size(Cur,1)%�鿴����0.002��ƽ���������������еİٷֱ�  �������ǰ1/3���ң�
%% �ҵ�ƫ�ƱȽϴ����Ϊѵ����Ԥ�����
dis_abrupt = [];
perception_time = 25;  %Excur_predict_1,Excur_predict_2�ж���
% global data_test
% input_abrupt = data_test;%�ò��Թ켣�����ͻ����Ϊ

input_abrupt = E_trajectory_reCur;%��ȫ���켣�����ͻ����Ϊ
data_wash = [];%���ͻ����Ϊ����
% test_result_no
index_i = 1;
area_line_all = [];
for i = 1:input_abrupt(size(input_abrupt,1),1)
    drow = input_abrupt(find((input_abrupt(:,1)==i)),:);%��ȡ����ǰ�����켣���켣˳����켣��˳��
    j = 1;
    while j <size(drow,1)-perception_time
        drow_1 = drow(j:j+perception_time,:);%��ȡ����ǰ�ж϶���켣
        %������ͨ���������Һ����ٶȵ�ռ�Ⱥ�ƫ�Ƴ̶Ƚ�����ȡͻ����Ϊ
%         V_zeros = ((sum(sign(drow_1(:,7))>0))/size(drow_1,1));%���Һ����ٶȵ�ռ��
%         dis_S_E = abs(max(drow_1(:,5))-min(drow_1(:,5)));%����ƫ�Ƴ̶�
%         dis_abrupt = [dis_abrupt;dis_S_E];
%         dis_head = [];
%         for h = 1:perception_time
%             dis_head = [dis_head;(drow_1(h,4)-drow_1(h+1,4))];
%         end
        %������ͨ���������Һ����ٶȵ�ռ�Ⱥ�ƫ�Ƴ̶Ƚ�����ȡͻ����Ϊ
        
        %������ͨ������켣��Χ�ɵ�����Ĵ�С������ȡͻ����Ϊ
%         area_line =  polyarea(drow_1(:,4),drow_1(:,5))/(max(drow_1(:,4))-min(drow_1(:,4)));
        %������ͨ������켣��Χ�ɵ�����Ĵ�С������ȡͻ����Ϊ
        
        %������ͨ�����ʼ�����ȡͻ����Ϊ
        curvat = max(drow_1(:,13));%����ƽ������
        area_line = curvat;%�����ʼ���������area_line
        %���������ʼ������
        

        %����������������ݣ�
        dis_x = [];
        dis_y = [];
        for h = 1:perception_time
            dis_x = [dis_x;(drow_1(h,4)-drow_1(h+1,4))];
            dis_y = [dis_y;(drow_1(h,5)-drow_1(h+1,5))];
        end
        if sum(sign(dis_x))==perception_time&&sum(sign(dis_y))==perception_time
            error = 1;%������ȷ����
        else
            error = 0;%���Ǵ�������
        end
        if error == 1%������ȷ����
            area_line_all = [area_line_all;area_line];
        end
        if area_line>0.2&&error==1           %dis_S_E>2&&sum(sign(dis_head))==perception_time  %V_zeros >0.4&&V_zeros <0.6&&dis_S_E>2
            data_wash = [data_wash ; drow_1];
%             scatter(drow_1(:,4),drow_1(:,5),'*','r');
%             title(['�켣IDΪ',num2str(drow_1(1,1)),'�켣����Ϊ',num2str(drow_1(1,2))]);
%             pause(0.5)
            j = j+perception_time;%����ͻ����Ϊ�������perception_time�����ݵ��ų���
            index_i = index_i+1;
        else
            j = j+1;
        end
    end
end
% hist(input_abrupt(:,13),100) %��������
% hist(area_line_all,100) %�����������
size(data_wash,1)/(perception_time+1)%��ʾ��ȡ������������

%������ֱ���ò��Թ켣�е�ͻ����Ϊȥ�����Ԣ�
global data_test
data_test = data_wash;%reshape(data_wash',size(drow_1,2)*21,[])';
���������ˣ��൱��Ū���˲������ݣ�

%������Ҫ�ֿ�ѵ���Ͳ���������
% % data_test = data_cal;%ȫ��ͻ����Ϊ���ݸ�����Լ�
% data_wash = reshape(data_wash',size(drow_1,2)*21,[])';
% n_id = randperm(size(data_wash,1));
% data_wash_1 = [];
% data_wash_2 = [];
% for i = 1:round(size(data_wash,1)*0.6)%�ó�60%��ѵ����ʣ�µ�ȥ����
%     data_wash_1 = [data_wash_1;data_wash(n_id(i),:)];
% end
% for i = round(size(data_wash,1)*0.6):size(data_wash,1)%�ó�60%��ѵ����ʣ�µ�ȥ����
%     data_wash_2 = [data_wash_2;data_wash(n_id(i),:)];
% end
% global data_cal
% data_cal = reshape(data_wash_1',size(drow_1,2),[])';
% global data_test
% data_test = reshape(data_wash_2',size(drow_1,2),[])';
figure(2)
scatter(data_cal(:,4),data_cal(:,5),'r','.');
hold on
figure(1)
scatter(data_wash(:,4),data_wash(:,5),'b','.');
��������������
%% �궨���ݺ���֤���ݴ���ȫ���������ȡ��
input_trajectory = E_trajectory;%ʹ��ȫ�����ݼ���
%input_trajectory = trajectory_block;%ʹ���������ݼ���
%��������Ԥ����
% index_cal = 88;%����ֻ��һ���켣ȥ�궨���ټ����һ���켣����϶ȣ���֪���궨�����в�����
% index_test = 104;%���Լ�Ҳ�������켣

% ���ֱ궨���ݺ���֤����
index_cal = randperm(input_trajectory(size(input_trajectory,1),1),round(input_trajectory(size(input_trajectory,1),1)*1));%���ȡ0.6������ID
index_test = 1:input_trajectory(size(input_trajectory,1),1);%ʣ�µ��ǲ��Լ�
for i = 1:size(index_cal,2)
    index_test(:,index_test(1,:)==index_cal(i)) = [];
end
global data_cal%�ֹ�����ѵ�����ݹ켣
data_cal = [];
for i = 1:size(index_cal,2) 
    data_cal = [data_cal;input_trajectory(find(input_trajectory(:,1)==index_cal(i)),:)];%�궨������
end
global data_test%�ֹ������������ݹ켣
data_test = [];
for i = 1:size(index_test,2) 
    data_test = [data_test;input_trajectory(find(input_trajectory(:,1)==index_test(i)),:)];%���Ե�����
end
�ȼ���ȫ����ȥ����������һ��ÿ��ѭ����Ҫ�೤ʱ�䣬�ٿ�����������    

%%
%����GA������Բ������б궨

options = gaoptimset('PopInitRange',[;0,1;0,1],'PopulationSize',50, 'Generations', 500,'CrossoverFraction',0.8,'MigrationFraction',0.02','Display','iter'); % �Ŵ��㷨�������
tic
%���½�
lb = [0.001;0.001;0.001;0.001;0.001;0.001;0.001;0.001;0.001;0.001];%С��;%����0
ub = [10;10;10;10;10;10;10;10;10;10];%С��Լ��  [1;2;1;5;5;5];%С��Լ��
[Parameter_cal,FVAL,EXITFLAG,OUTPUT] =ga(@Myfitting,10,[],[],[],[],lb,ub,[],options);%�����Ŵ��㷨���в����궨
% [best_fitness, elite, generation, last_generation] = my_ga(9,@fitting,100,20,0.01,200,0);
toc

% csvwrite('Parameter_cal_store.csv',Parameter_cal);%��ȡ��׼��Ϣ
save('result(0224��ϼ·100%ѵ������ȫ�������궨caliration)')
disp('the job is done')
end

% [all_output] = Myfitting(X)