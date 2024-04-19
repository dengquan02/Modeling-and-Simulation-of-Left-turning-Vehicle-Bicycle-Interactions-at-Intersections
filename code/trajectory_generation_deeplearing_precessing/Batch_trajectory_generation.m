function [possible_points,status ] = Batch_trajectory_generation(extract_one,perception_time,resolution,mmax,mmin)
%% ������������������֪���������£�����һ��pyhon�ļ�����������Ǳ�ڹ켣���Ա����ֱ��ȡ�ã�
% resolution = 0.4;
% Horizontal_range = 3;
Perception_interval = resolution/(2^0.5);  %0.4��ʾ��ɢ���ķֱ���
perception_Radius = resolution;
V_cos = 15; %����ٶ�Լ��

%% ָ�����������������ٶ�
if extract_one(1,14)==2%����2����Ϊ�綯��  ǰ������
    a_limit_border = 0.74;%20211018ʹ�õ���0.36  %���ֵ��3.8   %0.259����õ���0.2703��Ч���õ�ʱ����ƽ��ֵ0.4��ȡ����ƽ��ֵ�͵�ǰֵ�����ֵ  ��Ŀǰ�ڳ��԰ٷ�λ��0.74����λ��0.31������0.03
elseif extract_one(1,14)==1%����1����Ϊ���г�
    a_limit_border = 0.5;%20211018ʹ�õ���0.22   %���ֵ��1.58   0.259����õ���0.05934Ч���õ�ʱ����ƽ��ֵ0.26��ȡ����ƽ��ֵ�͵�ǰֵ�����ֵ��Ŀǰ�ڳ��԰ٷ�λ��0.5����λ��0.2������0.01
end
a_limit_border = max(a_limit_border,abs(extract_one(1,8)));%��ǰǰ��������ٶȺ��Ҹ���Լ����ȡƽ��ֵ   a_limit_border = mean([a_limit_border;abs(extract_one(1,8))])+0.05;%��ǰǰ��������ٶȺ��Ҹ���Լ����ȡƽ��ֵ
if extract_one(1,14)==2%����2����Ϊ�綯��   ����
    a_limit_Horizontal = 0.4;%20211018ʹ�õ���0.189   1217֮ǰ�õ���0.4��% %���ֵ��3.8   %0.259����õ���0.2703��Ч���õ�ʱ����ƽ��ֵ0.4��ȡ����ƽ��ֵ�͵�ǰֵ�����ֵ  ��Ŀǰ�ڳ��԰ٷ�λ��0.74����λ��0.31������0.03
elseif extract_one(1,14)==1%����1����Ϊ���г�
    a_limit_Horizontal = 0.15;%20211018ʹ�õ���0.15    1217֮ǰ�õ���0.4��% %���ֵ��1.58   0.259����õ���0.05934Ч���õ�ʱ����ƽ��ֵ0.26��ȡ����ƽ��ֵ�͵�ǰֵ�����ֵ��Ŀǰ�ڳ��԰ٷ�λ��0.5����λ��0.2������0.01
end
a_limit_Horizontal = max(a_limit_Horizontal,abs(extract_one(1,9)));%��ǰǰ��������ٶȺ��Ҹ���Լ����ȡƽ��ֵ    a_limit_Horizontal = mean([a_limit_Horizontal;abs(extract_one(1,9))])+0.1;%��ǰǰ��������ٶȺ��Ҹ���Լ����ȡƽ��ֵ

%% ����ǰ������ķ�Χ
V_max = extract_one(1,10)+(perception_time*0.12)*a_limit_border*3.6;  %   ������ܵ�����ٶȣ�������һ��ֵ��Լ��ס  ����km/h
border_near = ceil((min(0,((extract_one(1,6)*(perception_time*0.12)+0.5*a_limit_border*((perception_time*0.12)^2)))+3))/Perception_interval);%����Զ��,�����������Ÿ���Ϊ��Ԥ��ֵx����ӽ���ʵֵ�����ڳ����˽ӽ�ֵ������Ҫ���̾��룬���Լ�2��
border_far = ceil((min((extract_one(1,6)*(perception_time*0.12)-0.5*a_limit_border*((perception_time*0.12)^2)))+3)/Perception_interval);%border_far = ceil((min(-4.6,(extract_one(1,6)*(perception_time*0.12)-0.5*a_limit_border*((perception_time*0.12)^2))))/Perception_interval);     %����Զ�磬�����������Ÿ���  -4.6���������ٶ�  border_near = ceil((max(extract_one(1,6)*(perception_time*0.12)-0.5*a_limit*((perception_time*0.12)^2),0))/Perception_interval);%��
if V_max > V_cos  %km/h���ٶȴ���15����Լ��ס
    border_far = ceil((((-V_cos/3.6)*(perception_time*0.12))/Perception_interval));% ����ٶȹ�ȥ����
end
border = [border_near;border_far];
border = sortrows(border);%˳������

%% �������ķ�Χ
Horizontal_range_1  = ceil(((extract_one(1,7)*(perception_time*0.12)+0.5*a_limit_Horizontal*((perception_time*0.12)^2)+1))/(Perception_interval));   %���
Horizontal_range_0 = ceil(((extract_one(1,7)*(perception_time*0.12)-0.5*a_limit_Horizontal*((perception_time*0.12)^2)+1))/Perception_interval);   %�ҽ�
    
%% ɾ���ļ��У����ؽ�
delet_file1 = ' D:\File\Received File\����������\�ǻ�������Ϊ��ģ���루TOPS��\�ǻ�������Ϊ��ģ���루TOPS��\New_try\Data_processing\ ';
delet_file_1 = rmdir(delet_file1,'s');  % ɾ����ǰ·������Ϊfile���ļ���
delet_file_2 = mkdir('D:\File\Received File\����������\�ǻ�������Ϊ��ģ���루TOPS��\�ǻ�������Ϊ��ģ���루TOPS��\New_try\Data_processing', 'data_test');  % �ڵ�ǰ·��������Ϊfile���ļ���

delet_file2 = ' D:\File\Received File\����������\�ǻ�������Ϊ��ģ���루TOPS��\�ǻ�������Ϊ��ģ���루TOPS��\New_try\Data_processing\result_test\ ';
delet_file_11 = rmdir(delet_file2,'s');  % ɾ����ǰ·������Ϊfile���ļ���
delet_file_22 = mkdir('D:\File\Received File\����������\�ǻ�������Ϊ��ģ���루TOPS��\�ǻ�������Ϊ��ģ���루TOPS��\New_try\Data_processing', 'result_test'); 

%% �ɷ���  �����ǶԸ�������зֱ�����д��
% possible_points = [];%��ʼ������
% % optimal_solution = [];
% % SET_Complete_Data_odPoints_output = []; %���������֪�����յ���Ϣ
% index = 1;
% for i = border(1) : border(2)   %��Ÿ���
%     for j =  min(Horizontal_range_1,Horizontal_range_0) : max(Horizontal_range_1,Horizontal_range_0)  %������������½���Ÿ���
%         %% ����Ǳ�����յ㣬������ɹ켣���ɵ��������ʽ
%         start_point = extract_one(1,4:5);%�������
%         end_point = [i j]*Perception_interval+start_point;%���ϳ��յ㣬 [ x, y]
%         [Complete_Data_odPoints] = Complete_feature_ODpoints(start_point,end_point,extract_one,perception_time);%������֪���յ�λ�õõ�������ѧϰ��������  Complete_Data_odPoints����״�� 1*14
% %         hold on
% %         scatter(end_point(1),end_point(2))
%         [Complete_Data_odPoints_output] = Normalizating_NEW(Complete_Data_odPoints,2,mmax,mmin);%����ѵ�����ѧϰģ�͵����ֵ����Сֵ��һ������
%         dlmwrite(['E:\Prediction_NV\New_try\Data_processing\data_test\x_test_',num2str(index),'.txt'],Complete_Data_odPoints_output);
% %         disp(Complete_Data_odPoints_output(1:2))
%         possible_points = [possible_points;[i j]]; 
%         index = index +1;
% %         ����Ҫ�ĸ��Ե�����dlmwrite('E:\Prediction_NV\New_try\Data_processing\data_test\Complete_Data_odPoints.txt',Complete_Data_odPoints_output);%д������  text��ʽ
%    end
% end

%% �·��� �������ֻ������һ��   �����ǶԸ�������зֱ�����д��
possible_points = [];%��ʼ������
% optimal_solution = [];
% SET_Complete_Data_odPoints_output = []; %���������֪�����յ���Ϣ
index = 1;
disp(min(Horizontal_range_1,Horizontal_range_0) : max(Horizontal_range_1,Horizontal_range_0)) %����Χ
border_all = border(1) : border(2);%ǰ������  
Horizontal_rangeAll = min(Horizontal_range_1,Horizontal_range_0) : max(Horizontal_range_1,Horizontal_range_0); %����   min(Horizontal_range_1,Horizontal_range_0) : max(Horizontal_range_1,Horizontal_range_0) 
start_point = extract_one(1,4:5);%�������
[perception_point] = search_discretization(perception_Radius,start_point,border_all,Horizontal_rangeAll);%���������յ�

% truth_input = [extract_one(1,4:9) extract_one(1,14) extract_one(1,15:20) extract_one(1,25)];
% index_end = find((E_trajectory(:,1)==extract_one(1,1))&E_trajectory(:,2)==extract_one(1,2))+16;
% truth_input = [truth_input E_trajectory(index_end,4:9) E_trajectory(index_end,14) E_trajectory(index_end,15:20) E_trajectory(index_end,25)];

for i = 1:size(perception_point,1)
   %% ����Ǳ�����յ㣬������ɹ켣���ɵ��������ʽ
   end_point = perception_point(i,4:5);%��ȡ�յ㣬 [ x, y]
   [Complete_Data_odPoints] = Complete_feature_ODpoints(start_point,end_point,extract_one,perception_time)%������֪���յ�λ�õõ�������ѧϰ��������  Complete_Data_odPoints����״�� 1*14
%  hold on
%  scatter(end_point(1),end_point(2))
   [Complete_Data_odPoints_output] = Normalizating_NEW(Complete_Data_odPoints,2,mmax,mmin);%����ѵ�����ѧϰģ�͵����ֵ����Сֵ��һ������
   dlmwrite(['D:\File\Received File\����������\�ǻ�������Ϊ��ģ���루TOPS��\�ǻ�������Ϊ��ģ���루TOPS��\New_try\Data_processing\data_test\x_test_',num2str(index),'.txt'],Complete_Data_odPoints_output);
%  disp(Complete_Data_odPoints_output(1:2))
   possible_points = [possible_points;[perception_point(i,2:3)]]; 
   index = index +1;
%  ����Ҫ�ĸ��Ե�����dlmwrite('E:\Prediction_NV\New_try\Data_processing\data_test\Complete_Data_odPoints.txt',Complete_Data_odPoints_output);%д������  text��ʽ
end



 %% �����ǵ���python�ļ��Ը�������й켣����
status = system('code.bat');%�����ⲿ�̶�����python�ļ���ʵ�ֹ켣����   status�Ƿ���ֵ����Ϊ0��˵�����óɹ��� ����0929_02ģ��

	%�����Ƕ�ȡ�������ݣ���������Ǳ�ڹ켣���ο����ѧϰ�Ŀ��ӻ�
%% ��ȡ��Ŀ¼�µ�����txt�ļ��������������ɹ켣
path = 'D:\File\Received File\����������\�ǻ�������Ϊ��ģ���루TOPS��\�ǻ�������Ϊ��ģ���루TOPS��\New_try\Data_processing\result_test\';
namelist = dir('D:\File\Received File\����������\�ǻ�������Ϊ��ģ���루TOPS��\�ǻ�������Ϊ��ģ���루TOPS��\New_try\Data_processing\result_test\*.txt');%��ȡ����txt�ļ���
file_list = sort_nat({namelist.name}); %���ļ����������� ԭ���������
leng = length(file_list);%��ȡ������
P = cell(1,leng);%����һ��ϸ�����飬���ڴ������txt�ļ�
for i = 1:leng
    file_name{i}=file_list(1,i);
    file_name_1 = strcat(file_name{i});
    file_name_curent = strcat(path,file_name_1);
    P{1,i} = load(cell2mat(file_name_curent));
end
prediction = P;
pre_data_test = zeros(leng,perception_time*(size(Complete_Data_odPoints,2)/2));%yy��Ԥ��ֵ
for i = 1:leng %��Ԥ��ֵ�ŵ���ֵ��״
    pre_data_test(i,:)=(reshape(prediction{1,i}',[],1));%����  (size(Complete_Data_odPoints,2)/2)  ��14
end
possible_points = [possible_points pre_data_test];%����źʹ�ѡ�켣ƴ��һ��

%%  ����Ķ�ûɶ�ã����Դ���
% figure(9)
% for i = 1:leng
%     zuotu = reshape(pre_data_test(i,:)',[],perception_time)';
%     hold on
%     scatter(zuotu(:,1),zuotu(:,2),'*','r');
% %     i = i+1;
% end
% 
% %% 
% Possible_points = possible_points;
%  Potential_trajectory_allData = reshape(Possible_points(i,3:size(Possible_points,2)),perception_time,[]);%��һ�л�ԭ��17��*14��  possible_pointsǰ�����������
%         %% ���������һ��
%         [Potential_trajectory_allData_output] = Anti_normalizating_NEW(Potential_trajectory_allData,perception_time);%  ����һ��������֮ǰѵ��Ԥ�������ݵ�mmaxm��mmin
%         %% ��������
%         Potential_trajectory = Potential_trajectory_allData_output(:,1:2);%ֻȡǰ�������о�����λ��
% %        %��ͼ������һ��
%         hold on
%         scatter(Potential_trajectory(:,1),Potential_trajectory(:,2),50,'*','r')  %o v *   %Ԥ��켣
%         Potential_trajectory_1D = reshape(Potential_trajectory, 1 , []);%
end