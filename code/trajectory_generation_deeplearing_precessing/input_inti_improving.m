%%���ݷָ�%%%%
function [x_train_output,y_train_output] = input_inti_improving(x_train,y_train,N_lengh_point) %start_point_test,ratio_test,mmin,mmax
% ���ý�֪ͨʶ������ֵ�Ľ�һЩ�������ܸ��õĵ�רע��ѧϰ���ɹ켣����ص㣻
% ������λ�þ���ȥ�����λ�ã�

%  ɾ��������ģ�
x_train(:,N_lengh_point+1:N_lengh_point+2)=[];
x_train(:,size(x_train,2)-2:size(x_train,2))=[];
y_train(:,size(y_train,2)-2:size(y_train,2)) = [];

%% ��x����
x_train_processing = x_train;
for i = 1:N_lengh_point:size(x_train,2)
    x_train_processing(:,i:i+1) = x_train(:,i:i+1)+x_train(:,1:2);
end
x_train_output = x_train_processing;
x_train_output(:,1:2) = x_train(:,1:2);%ԭʼ��㸳�账���ľ���
y_train_output = y_train;
y_train_output(:,1:2) = y_train(:,1:2)+x_train_processing(:,1:2);



end