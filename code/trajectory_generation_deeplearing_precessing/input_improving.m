%%���ݷָ�%%%%
function [x_train_output,y_train_output] = input_improving(x_train,y_train,N_lengh_point) %start_point_test,ratio_test,mmin,mmax
% ���ý�֪ͨʶ������ֵ�Ľ�һЩ�������ܸ��õĵ�רע��ѧϰ���ɹ켣����ص㣻
% ������λ�þ���ȥ�����λ�ã�
%% ��x����
x_train_processing = x_train;
for i = 1:N_lengh_point:size(x_train,2)
    x_train_processing(:,i:i+1) = x_train(:,i:i+1)-x_train(:,1:2);
end
x_train_output = x_train_processing;
x_train_output(:,1:2) = x_train(:,1:2);%ԭʼ��㸳�账���ľ���
% x_train_output = [x_train_output(:,1:i-1) zeros(size(x_train,1),2) x_train_output(:,i:size(x_train,2)) ones(size(x_train,1),2)];

%% ��y����
y_train_output = y_train;
y_train_output(:,1:2) = y_train(:,1:2)-x_train_processing(:,1:2);%��������һ��
proportion_1 = (y_train_output(:,1) - x_train(:,1))./(x_train_output(:,i+2));
proportion_2 = (y_train_output(:,2) - x_train(:,2))./(x_train_output(:,i+3));
proportion = [proportion_1 proportion_2];
y_train_output = [y_train_output proportion];%�������ŵ�����м��ռ���յ�ı���
end