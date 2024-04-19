function [complete_acc] = acc_interpolation(acc,current_acc,timess,perception_time,generating_lengh)
%���ò�ֵ����ϡ����ٶȲ�������
acc_input = [current_acc;acc];%����ǰ���ٶȷ��������棻
% perception_time = 25;%���벽��+Ԥ�ⲽ��
% generating_lengh = 9; %�м��ֵ����+2
% timess = size(acc_input,1);%������ٶȵĸ���

%% ��ʼ��ֵ
acc_all = [];
for i = 1 : timess-1
    start_acc = acc_input(i,:);
    end_acc = acc_input(i+1,:);
    inter_x = (end_acc(1) - start_acc(1))/(generating_lengh-1);%��1�в�ֵ��λ����
    inter_y = (end_acc(2) - start_acc(2))/(generating_lengh-1);%��2�в�ֵ��λ����
    acc_i = start_acc;%�м�Ĳ�ֵ
    for j = 1:generating_lengh-2  %����Ӧ����-2
        acc_i = [acc_i;[start_acc(1)+j*inter_x,end_acc(2)+j*inter_y]];
    end
    acc_all = [acc_all;acc_i];
end
complete_acc = acc_all;
%% ����
end
        
        