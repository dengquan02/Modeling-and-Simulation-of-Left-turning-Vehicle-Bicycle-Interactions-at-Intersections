function [Risk] = Risk_calculation(input,extract,intrusion_cood_E,G,R_b,k1,k3,char_intrusion,char_end,index_end,char_intrusion_right,char_end_right,index_end_right)
%% ˫��ģ�͵Ĵ���
%�������Ƕ�̬�������󡢺���ƫ�ƾ��롢�����յ����Σ�ն�
%intrusion_cood_E�ǻ�׼����
%extract = extract_time_i(2,:)%�ǻ�����������
%input�Ƿ��ռ�������λ��shap = ��1,2��
% input=truth_point;
% extract=extract_time_i(2:size(extract_time_i,1),:);
% extract=extract_time_i(2:size(extract_time_i,1),:);
%%�������
G=0.12;%ԭ����0.1 ����С  0.12   %%%%%%%%%%%%%%���ﻻ����
% R_b = 1;
% M_b = 2000;
k1 = 1;%Parameter(1)  ԭ����1  ��ʾ�����Ĺ�ϵ
k3 = 0.05;%%Parameter(2) 0.5  ��ʾ���ٶȽǶȵĹ�ϵ
% char_intrusion = 1;%�������ǻ���������Ĳ���  %Parameter(3)   1 0.8 1 5 0.2
char_end = 6;  %Parameter(4) 5   6   %%%%%%%%%%%%%%���ﻻ����
index_end = 0.1;  %Parameter(5)  0.4   0.1    %%%%%%%%%%%%%%���ﻻ����
% char_intrusion_right = 2;%�����������˷���Ĳ���
char_end_right = 5;
index_end_right = 0.4;
index_int = 2.2;  %2.2
char_int = 0.1;%0.1
%% ��ʼ�������ֵ
% k4=%Parameter(6)
%���ַ���  ����������
int_dis = (intrusion_cood_E(1,2)-input(1,2));%���־���
if int_dis<0%�����־���С��0�������0
    int_dis = 0;
end
% R_int = log(int_dis*char_intrusion+1)*[0 1];%[0 -1]��ʾ�䷽��  ln����
R_int = char_int*(int_dis.^(index_int))*[0 1];%[0 -1]��ʾ�䷽��  ָ������
% R_int = char_int*(int_dis.^(index_int));%[0 -1]��ʾ�䷽��  ָ������
% scatter(int_dis,R_int)
%% �޶����ֵ
if norm(R_int)>=100
   R_int = 100;%�����մ���10�������10
end
%%
%���ڵ�����  ����������
end_dis = (input(1,1)-intrusion_cood_E(3,1));%������ڵ��ķ���
R_end = char_end*(end_dis.^(index_end))*[-1 0];%[-1 0]��ʾ�䷽��    R_end = char_end*(index_end.^(-end_dis))*[-1 0];%[-1 0]��ʾ�䷽��
R_end = norm(R_end) - norm((char_end*((45+10).^(index_end))*[-1 0]));%��ȥ��͵�
% if norm(end_dis)<=1
%    R_end = inf;%������С��0.2������������
% end
if input(1,2)>intrusion_cood_E(1,2)%��Ŀ��δ���֣������
    R_end = [0,0];
end



% intrusion_cood_E_right = [47.43 39; 47.43 35.5; 3 39; 3 32.5];
%�������˲��ֵķ��ճ���С��39��ʾ�����к����λ�ã����Ƿ������ĵط���ī��·����������

intrusion_cood_E_right = [10 35; 10 26; -45 35; -45 26];
%�������˲��ֵķ��ճ���С��39��ʾ�����к����λ�ã����Ƿ������ĵط�����ϼ·����������

%���ַ���  ���˷���
int_dis_right = (input(1,2) - intrusion_cood_E_right(2,2));%���־���
if int_dis_right<0%�����־���С��0�������0
    int_dis_right = 0;
end
% R_int_right = log(int_dis_right*char_intrusion_right+1)*[0 -1];%[0 -1]��ʾ�䷽�������������������ķ������෴�ģ�
R_int_right = char_int*(int_dis_right.^(index_int))*[0 -1];%[0 -1]��ʾ�䷽��  ָ������
%% �޶����ֵ
if norm(R_int_right)>=100
   R_int_right = 100;%�����մ���10�������10,ԭ����5
end

%% ���ڵ�����  ���˷���
end_dis_right = (input(1,1)-intrusion_cood_E_right(3,1));%������ڵ��ķ���
R_end_right = char_end_right*(end_dis_right.^(-index_end_right))*[-1 0];%[-1 0]��ʾ�䷽��
R_end_right = norm(R_end_right) - norm((char_end_right*((10+45).^(-index_end_right))*[-1 0]));%��ȥ��͵�
% if norm(end_dis_right)<=1
%    R_end_right = inf;%������С��0.2������������
% end
if input(1,2)<intrusion_cood_E_right(2,2)%��Ŀ��δ���֣������
    R_end_right = [0,0];
end


%��̬����������գ�û�зֻ��ǣ�ֻ�ǰ����ٶȷ���
% R_inter = zeros(1,2);
R_inter = 0;
for i = 1:size(extract,1)
    inter_direction =- input + extract(i,1:2);%����֮������  ����λ��-��̬��������
    if norm(inter_direction)==0
        disp(input)
        disp(extract(i,1:2))
        disp('������NaN')
    end
    if extract(i,11)==1%������һ�������г�20kg
        M_b = 150;
    elseif extract(i,11)==2
        M_b = 200;%�綯��50kg
    elseif extract(i,11)==3
        M_b = 1000;%����2000kg
    end
%     co =( ((extract(i,3:4)/norm(extract(i,3:4)))-(inter_direction/norm(inter_direction))));%���������ٶ�����߷�λ֮��Ƕ�����
    co = dot(extract(i,3:4),inter_direction)/((norm(extract(i,3:4))*norm(inter_direction)));
    if isnan(co)%������ֵ�����ڣ�˵����ʱ�ٶ�Ϊ0���Ǵ������ݣ�ֱ�Ӹ���coΪ1��������ֵΪ1���Ƕ�Ϊ0��
        co = 1;
    end
%     disp(co)
    R_inter_i = ((G*R_b*M_b)/(norm(inter_direction)^k1))*((inter_direction)/(norm(inter_direction)))*(exp(k3*extract(i,7)/3.6*(co(1,1))));%�ٶȴ���ȥ�õ���m/s   
% disp('kaile')
% disp(((G*R_b*M_b)/(norm(inter_direction)^k1)))
%         disp(((inter_direction)/(norm(inter_direction))))
% disp((exp(k3*extract(i,7)/3.6*(co(1,1)/norm(co)))))
    R_inter = R_inter+norm(R_inter_i);
%     disp(R_inter_i)
%     if norm(inter_direction)<=0.5
%     disp(R_inter_i)
%     R_inter = R_inter+norm(R_inter_i);
end
%% �޶����ֵ
if norm(R_inter)>=100  %ԭ����20
   R_inter = 100;%((inter_direction)/(norm(inter_direction)))*10;%ԭ����inf  Ϊ����ͼ���10��֮ǰ��100
end
% norm(R_inter)
% norm(inter_direction)

% Risk = norm(R_end)+norm(R_inter)+norm(R_int)+norm(R_int_right) +norm(R_end_right);%�����Ǳ����ͣ�Ҫ���ӵģ�%Risk = norm(R_end)+norm(R_inter)+norm(R_int)

Risk = norm(R_inter);
% disp(Risk)
% if isnan(Risk)
%    disp(input)
% end
% disp(R_inter)

%% ֮ǰ��TRB����
% %�������Ƕ�̬�������󡢺���ƫ�ƾ��롢�����յ����Σ�ն�
% %intrusion_cood_E�ǻ�׼����
% %extract = extract_time_i(2,:)�ǻ�����������
% %input�Ƿ��ռ�������λ��shap = ��1,2��
% % input=extract_trajectory(index_in,4:5);
% % extract=extract_time_i(2:size(extract_time_i,1),:);
% %%�������
% G=0.1;%ԭ����0.001 ����С
% % R_b = 1;
% % M_b = 2000;
% k1 = 1;%Parameter(1)  1.5  ��ʾ�����Ĺ�ϵ
% k3 = 0.05;%%Parameter(2) 0.5  ��ʾ���ٶȽǶȵĹ�ϵ
% % char_intrusion = 1;%�������ǻ���������Ĳ���  %Parameter(3)   1 0.8 1 5 0.2
% char_end = 5;  %Parameter(4) 15
% index_end = 0.4;  %Parameter(5)  0.15
% % char_intrusion_right = 2;%�����������˷���Ĳ���
% % char_end_right = 0.2;
% % index_end_right = 2;
% index_int = 2.2;  %2
% char_int = 0.1;%0.1
% %%��ʼ�������ֵ
% % k4=%Parameter(6)
% %���ַ���  ����������
% int_dis = (intrusion_cood_E(1,2)-input(1,2));%���־���
% if int_dis<0%�����־���С��0�������0
%     int_dis = 0;
% end
% % R_int = log(int_dis*char_intrusion+1)*[0 1];%[0 -1]��ʾ�䷽��  ln����
% R_int = char_int*(int_dis.^(index_int))*[0 1];%[0 -1]��ʾ�䷽��  ָ������
% 
% if norm(R_int)>=10
%    R_int = 10;%�����մ���10�������10
% end
% 
% %���ڵ�����  ����������
% end_dis = (input(1,1)-intrusion_cood_E(3,1));%������ڵ��ķ���
% R_end = char_end*(end_dis.^(index_end))*[-1 0];%[-1 0]��ʾ�䷽��    R_end = char_end*(index_end.^(-end_dis))*[-1 0];%[-1 0]��ʾ�䷽��
% R_end = norm(R_end) - norm((char_end*((45+10).^(index_end))*[-1 0]));%��ȥ��͵�
% % if norm(end_dis)<=1
% %    R_end = inf;%������С��0.2������������
% % end
% if input(1,2)>intrusion_cood_E(1,2)%��Ŀ��δ���֣������
%     R_end = [0,0];
% end
% 
% 
% 
% % intrusion_cood_E_right = [47.43 39; 47.43 35.5; 3 39; 3 32.5];
% %�������˲��ֵķ��ճ���С��39��ʾ�����к����λ�ã����Ƿ������ĵط���ī��·����������
% 
% intrusion_cood_E_right = [10 35; 10 26; -45 35; -45 26];
% %�������˲��ֵķ��ճ���С��39��ʾ�����к����λ�ã����Ƿ������ĵط�����ϼ·����������
% 
% %���ַ���  ���˷���
% int_dis_right = (input(1,2) - intrusion_cood_E_right(2,2));%���־���
% if int_dis_right<0%�����־���С��0�������0
%     int_dis_right = 0;
% end
% % R_int_right = log(int_dis_right*char_intrusion_right+1)*[0 -1];%[0 -1]��ʾ�䷽�������������������ķ������෴�ģ�
% R_int_right = char_int*(int_dis_right.^(index_int))*[0 -1];%[0 -1]��ʾ�䷽��  ָ������
% if norm(R_int_right)>=10
%    R_int_right = 10;%�����մ���10�������10,ԭ����5
% end
% 
% %���ڵ�����  ���˷���
% end_dis_right = (input(1,1)-intrusion_cood_E_right(3,1));%������ڵ��ķ���
% R_end_right = char_end_right*(end_dis_right.^(-index_end_right))*[-1 0];%[-1 0]��ʾ�䷽��
% R_end_right = norm(R_end_right) - norm((char_end_right*((10+45).^(-index_end_right))*[-1 0]));%��ȥ��͵�
% % if norm(end_dis_right)<=1
% %    R_end_right = inf;%������С��0.2������������
% % end
% if input(1,2)<intrusion_cood_E_right(2,2)%��Ŀ��δ���֣������
%     R_end_right = [0,0];
% end
% 
% 
% %��̬����������գ�û�зֻ��ǣ�ֻ�ǰ����ٶȷ���
% % R_inter = zeros(1,2);
% R_inter = 0;
% for i = 1:size(extract,1)
%     inter_direction =- input + extract(i,1:2);%����֮������  ����λ��-��̬��������
%     if norm(inter_direction)==0
%         disp(input)
%         disp(extract(i,1:2))
%         disp('������NaN')
%     end
%     if extract(i,11)==1%������һ�������г�20kg
%         M_b = 150;
%     elseif extract(i,11)==2
%         M_b = 200;%�綯��50kg
%     elseif extract(i,11)==3
%         M_b = 1000;%����2000kg
%     end
% %     co =( ((extract(i,3:4)/norm(extract(i,3:4)))-(inter_direction/norm(inter_direction))));%���������ٶ�����߷�λ֮��Ƕ�����
%     co = dot(extract(i,3:4),inter_direction)/((norm(extract(i,3:4))*norm(inter_direction)));
% %     disp(co)
%     R_inter_i = ((G*R_b*M_b)/(norm(inter_direction)^k1))*((inter_direction)/(norm(inter_direction)))*(exp(k3*extract(i,7)/3.6*(co(1,1))));%�ٶȴ���ȥ�õ���m/s   
% % disp('kaile')
% % disp(((G*R_b*M_b)/(norm(inter_direction)^k1)))
% %         disp(((inter_direction)/(norm(inter_direction))))
% % disp((exp(k3*extract(i,7)/3.6*(co(1,1)/norm(co)))))
%     R_inter = R_inter+norm(R_inter_i);
% %     disp(R_inter_i)
% %     if norm(inter_direction)<=0.5
% %     disp(R_inter_i)
% %     R_inter = R_inter+norm(R_inter_i);
% end
% if norm(R_inter)>=20
%    R_inter = 20;%((inter_direction)/(norm(inter_direction)))*10;%ԭ����inf  Ϊ����ͼ���10��֮ǰ��100
% end
% % norm(R_inter)
% % norm(inter_direction)
% 
% Risk = norm(R_end)+norm(R_inter)+norm(R_int);%+norm(R_int_right) +norm(R_end_right);%�����Ǳ����ͣ�Ҫ���ӵģ�%Risk = norm(R_end)+norm(R_inter)+norm(R_int)
% 
% % Risk = norm(R_inter);
% % disp(Risk)
% % if isnan(Risk)
% %    disp(input)
% % end
% % disp(R_inter)
end
