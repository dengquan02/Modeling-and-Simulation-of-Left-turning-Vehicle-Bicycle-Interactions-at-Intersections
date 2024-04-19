function [output] = LIP_cal(input_trajectory_1,input_trajectory_2,ARG)
%�ú����Ǽ���LIP���룬input1��ʾ��������1��input2��ʾ��������2��wight��ʾȨ��ȡֵ�����wight=1��ʾ������Ϊ���ƣ�wight=2��ʾ����켣�غ϶ȣ�
%�ú���������LIP�����ҳ�������ʵ�켣���ȣ�����������ֵ�������ȽϹ켣��Ϊ���Ƶ����ӣ�
% tic
%��ʵ�켣��������
% input_trajectory_1 = Truth_no(:,4:5);%��ʾ��ʵ���ݣ���ʽ�ǣ�1+Ԥ�ⲽ����*2    x��y
% input_trajectory_2 = output1_part;%��ʾԤ�����ݣ���ʽ�ǣ�1+Ԥ�ⲽ����*2    x��y
% ARG = 0;%ȡ1������1��-1��ȡ0�Ƕ���1��
%��������
% input_trajectory_1 = [0 0; 1 1; 2 0; 3 1; 4 0 ];
% input_trajectory_2 = [0 0; 1 0; 2 1; 3 0; 4 1 ];
%%
% %��ͼ������һ��
% plot(input_trajectory_1(:,1),input_trajectory_1(:,2),'b');
% hold on 
% scatter(input_trajectory_1(:,1),input_trajectory_1(:,2),'*','b');
% hold on 
% plot(input_trajectory_2(:,1),input_trajectory_2(:,2),'r');
% hold on 
% scatter(input_trajectory_2(:,1),input_trajectory_2(:,2),'*','r');

%% �ҵ��������ߵ��ཻ�㣬���������㣬���������յ㡣
cro_point = [];%����ཻ��
ID_dele = [];%�����Ҫɾ�����ཻ�㣬���ǵ������߶���ȫ�غϵ�ʱ��
for i = 1:size(input_trajectory_1,1)-1
    for j = 1:size(input_trajectory_2,1)-1
    [output_cro_point] = CrossPoint(input_trajectory_1(i:i+1,:),input_trajectory_2(j:j+1,:));
    cro_point = [cro_point ; output_cro_point];%��¼�ཻ��
    end
end
%ɾ���غ��߶ε��µ��ཻ�����
for i = 2:size(cro_point,1)
    if_same = abs(cro_point(i,:) - input_trajectory_1) <0.0001 & abs(cro_point(i,:) - input_trajectory_2) <0.0001;
    if max(sum(if_same,2))>=2
        ID_dele = [ID_dele;i];
    end
end
cro_point(ID_dele,:) = [];
% hold on
% scatter(cro_point(:,1),cro_point(:,2),'black','*')

%% ��ԭʼ�켣���в������ӵ�
lip_piont_truth = [];%���ÿ����������ӵ�
lip_piont_predict = [];%���ÿ����������ӵ�
%����ʵ�켣����
for j = 1 : size(input_trajectory_1,1)-1 %�����ӵ�ŵ���ʵ�켣���棬����˳��
    %�ж�ÿ�����ӵ��Ƿ�����ʵ����
    %���ĸ����ӵ��ڸ�����
    ID_ARG = [];%���ÿ�����ӵ��Ƿ������ϵļ���
    for i = 1:size(cro_point,1)
        [outputArg_1] = check_point_line(cro_point(i,:),input_trajectory_1(j,:),input_trajectory_1(j+1,:));
        ID_ARG = [ID_ARG; outputArg_1];
        if outputArg_1 == 1
            ID_Arg = i;%�������ӵ����
        end
    end
    if sum(ID_ARG) == 1 %���������ϣ����ǰһ��������ӵ㶼�ŵ������ӵĵ㼯����
        lip_piont_truth = [lip_piont_truth; [input_trajectory_1(j,:); cro_point(ID_Arg,:)]];
%         disp('�в�ֵ')
    else
        lip_piont_truth = [lip_piont_truth; input_trajectory_1(j,:)];
%         disp('�޲�ֵ')
    end
end
lip_piont_truth = [lip_piont_truth; input_trajectory_1(j+1,:)];%�����һ�����ȥ

%��Ԥ��켣����
for j = 1 : size(input_trajectory_2,1)-1 %�����ӵ�ŵ�Ԥ��켣���棬����˳��
    %�ж�ÿ�����ӵ��Ƿ���Ԥ������
    %���ĸ����ӵ��ڸ�����
    ID_ARG = [];%���ÿ�����ӵ��Ƿ������ϵļ���
    for i = 1:size(cro_point,1)
        [outputArg_2] = check_point_line(cro_point(i,:),input_trajectory_2(j,:),input_trajectory_2(j+1,:));
        ID_ARG = [ID_ARG; outputArg_2];
        if outputArg_2 == 1
            ID_Arg = i;%�������ӵ����
        end
    end
    if sum(ID_ARG) == 1 %���������ϣ����ǰһ��������ӵ㶼�ŵ������ӵĵ㼯����
        lip_piont_predict = [lip_piont_predict; [input_trajectory_2(j,:); cro_point(ID_Arg,:)]];
%         disp('�в�ֵ')
    else
        lip_piont_predict = [lip_piont_predict; input_trajectory_2(j,:)];
%         disp('�޲�ֵ')
    end
end
lip_piont_predict = [lip_piont_predict; input_trajectory_2(j+1,:)];%�����һ�����ȥ

%% �������
lip = [];%��Ÿ������
for i = 1:size(cro_point,1)
    if i==size(cro_point,1)
        area_truth_0 = find((abs(lip_piont_truth(:,1)-cro_point(i,1))<0.001)&(abs(lip_piont_truth(:,2)-cro_point(i,2))<0.001));%�ҵ�����������ʵ�켣���ID
%         ���������ˣ��������Ĵ���
        area_truth_1 = size(lip_piont_truth,1);%�ҵ�����յ�����ʵ�켣���ID
        area_predict_0 = find((abs(lip_piont_predict(:,1)-cro_point(i,1))<0.001)&(abs(lip_piont_predict(:,2)-cro_point(i,2))<0.001));%�ҵ���������Ԥ��켣���ID
        area_predict_1 = size(lip_piont_predict,1);%�ҵ�����յ���Ԥ��켣���ID
    else
        area_truth_0 = find((abs(lip_piont_truth(:,1)-cro_point(i,1))<0.001)&(abs(lip_piont_truth(:,2)-cro_point(i,2))<0.001));%�ҵ�����������ʵ�켣���ID
        area_truth_1 = find((abs(lip_piont_truth(:,1)-cro_point(i+1,1))<0.001)&(abs(lip_piont_truth(:,2)-cro_point(i+1,2))<0.001));%�ҵ�����յ�����ʵ�켣���ID
        area_predict_0 = find((abs(lip_piont_predict(:,1)-cro_point(i,1))<0.001)&(abs(lip_piont_predict(:,2)-cro_point(i,2))<0.001));%�ҵ���������Ԥ��켣���ID
        area_predict_1 = find((abs(lip_piont_predict(:,1)-cro_point(i+1,1))<0.001)&(abs(lip_piont_predict(:,2)-cro_point(i+1,2))<0.001));%�ҵ�����յ���Ԥ��켣���ID
    end
    lip_sigle = [lip_piont_truth(area_truth_0:area_truth_1,:); flipud(lip_piont_predict(area_predict_0:area_predict_1,:))];%��Ÿ�����������ӵ�  ����Ԥ��켣���˵�������ΪҪΧ��һ��ȦȦ
    area_1 = polyarea(lip_sigle(:,1),lip_sigle(:,2));%���㵱ǰΧ�ϵ����
    %�ж�˳��ʱ�룬����Ȩ��
    if i == 1
        start_truth = lip_piont_truth(area_truth_0+1,:)-lip_piont_truth(area_truth_0,:);%ȡ�������һ����������ʵֵ������һ���������
        start_predict = lip_piont_predict(area_predict_0+1,:)-lip_piont_predict(area_predict_0,:);%ȡһ���������һ��������Ԥ��ֵ
        [start_truth_theta,~] = cart2pol(start_truth(1,1),start_truth(1,2));%����ɼ�����
        [start_predict_theta,~] = cart2pol(start_predict(1,1),start_predict(1,2));
        if start_truth_theta < start_predict_theta%����ʵֵ��Ԥ��ֵ�Ƕ�С������Ȩ��-1������1
            up_down_wight = -1;
        else
            up_down_wight = 1;
        end
    else
        up_down_wight = up_down_wight*-1;%ÿ�ξ���һ�����ӵ�ͻ�ת���෴Ȩ��
    end
    if ARG == 1%����������Ȩ�ط�ʽ
        wight = up_down_wight;
    elseif ARG == 0
        wight = 1;
    end
%     %��ͼ
%     if up_down_wight == 1
%         clor = 'r';
%     elseif up_down_wight == -1
%         clor = 'b';
%     end
%     hold on
%     figure(2)
%     fill(lip_sigle(:,1),lip_sigle(:,2),clor);%��������������ͼ��һ��
    %��¼�����������
    lip = [lip; wight*area_1];
end
output_area = sum(lip);%������ڼӺ͵����
%% ͨ����ʵ�켣�������������ֵ
dist = squareform(pdist(input_trajectory_1));
di = [];
for i = 1:size(input_trajectory_1,1)-1
    di = [di;dist(i,i+1)];
end
output = output_area/(sum(di));

% toc
end