function [precessing_train_ver_output,precessing_test_output] = Replace_feature_ODpoints(precessing_train_ver,precessing_test,generating_lengh)
% ��������Ŀ���ǽ�ѵ���Ͳ����������յ�������滻�ɻ����˶�ѧ��ʽ����ģ���Ϊ��ʵ�ʲ�������Щ����ֵ��δ֪����
%�����ã���ȡ����
precessing_train_ver1 = precessing_train_ver;
precessing_test1 = precessing_test;
n = 11;

%% �ȱ任һ����״����һ�������ŵ�һ��
ID_Data_train_ver = precessing_train_ver1(:,1:4);  %�Ȱ�ǰ4�е�ID�����õ�������ٲ���ȥ
ID_Data_test = precessing_test1(:,1:4);  %�Ȱ�ǰ4�е�ID�����õ�������ٲ���ȥ
precessing_train_ver1(:,1:4) = [];
precessing_test1(:,1:4) = [];
precessing_train_ver1 = reshape(precessing_train_ver1',3*n*2,[])';  %�ԣ�2*n��Ϊһ���㣬��Ϊ������һ�������Ķ���㣻
precessing_test1 = reshape(precessing_test1',generating_lengh*n*2,[])';

%% ��ѵ�����ݴ���  ֻ���յ���� 
%�о�����
timestep = 0.12;    %��E_trajectory(2,3)-E_trajectory(1,3)�������
T_start = precessing_train_ver((1:3:size(precessing_train_ver,1)-2),4);%����������
T_end = precessing_train_ver((1:3:size(precessing_train_ver,1)-2)+1,4);%��������յ�
T = 0.12*((T_end-T_start)/timestep);

Host_S_start =  precessing_train_ver1(:,1:2);  %���λ��
Host_V_start =  precessing_train_ver1(:,3:4);%����ٶ�
Host_A_start =  precessing_train_ver1(:,5:6);%��λΪm/s^2
Host_C_start =  precessing_train_ver1(:,10);%����!!

Host_S_end =  precessing_train_ver1(:,45:46);  %�յ�λ��
Host_V_end = (2 .*(Host_S_end - Host_S_start)./T) - Host_V_start; %�õ������ٶȾ���
A_mean = (Host_V_end - Host_V_start)./T;%������ٶȣ���һ���ϵ�ƽ�����ٶ�
Host_A_end = A_mean*2 - Host_A_start;%����õ����յļ��ٶ�
Host_C_end =  Host_C_start;%��ֵ�յ�����!!


%��������  ������о�����  ����Ϊ+n  ����ٶ�ģ��
Inter_S_start =  precessing_train_ver1(:,(n+1):(n+2));  %���λ��
Inter_V_start =  precessing_train_ver1(:,(n+3):(n+4));%�����m/s
Inter_A_start =  precessing_train_ver1(:,(n+5):(n+6));

Inter_C_start =  precessing_train_ver1(:,n+10);%!!

Inter_A_end = Inter_A_start;%���ٶȲ���
Inter_V_end = Inter_V_start + T.*Inter_A_start;%����ٶȼ��������ٶ�
Inter_S_end = Inter_S_start + Inter_V_start.*T + 0.5.*Inter_A_start.*T.^2;%����ٶ�ģ�ͼ���λ��

Inter_C_end = Inter_C_start;%!!
%��ֵ
precessing_train_ver1_output = precessing_train_ver1;
precessing_train_ver1_output(:,47:48) = Host_V_start;%�����о������յ���ٶ�
precessing_train_ver1_output(:,49:50) = Host_A_start;%�����о������յ�ļ��ٶ�   ԭ����Host_A_end

precessing_train_ver1_output(:,54) = Host_C_start;%�����о������յ������!!

precessing_train_ver1_output(:,n+45:n+46) = Inter_S_end;%���轻�������λ��
precessing_train_ver1_output(:,n+47:n+48) = Inter_V_end;%���轻��������ٶ�
precessing_train_ver1_output(:,n+49:n+50) = Inter_A_end;%���轻������ļ��ٶ�

precessing_train_ver1_output(:,n+54) = Inter_C_end;%���轻�����������!!


%% �Բ������ݴ���  ֻ���յ����
%�о�����
t = (generating_lengh - 1)*0.12;%��������ʱ��
Host_S_start_test =  precessing_test1(:,1:2);  %���λ��
Host_V_start_test =  precessing_test1(:,3:4);  %����ٶ�
Host_A_start_test =  precessing_test1(:,5:6);%�����m/s   �����ٶ�
Host_C_start_test =  precessing_test1(:,10);%����!! 

Host_S_end_test =  precessing_test1(:,(2*n*16+1):(2*n*16+2));  %�յ�λ��
Host_V_end_test = (2 .*(Host_S_end_test - Host_S_start_test)./t) - Host_V_start_test; %�õ������ٶȾ���
A_mean_test = (Host_V_end_test - Host_V_start_test)./t;%������ٶȣ���һ���ϵ�ƽ�����ٶ�
Host_A_end_test = A_mean_test*2 - Host_A_start_test;%����õ����յļ��ٶ�
Host_C_end_test = Host_C_start_test;%!!

%��������  ������о�����  ����Ϊ+n
Inter_S_start_test =  precessing_test1(:,(n+1):(n+2));  %���λ��
Inter_V_start_test =  precessing_test1(:,(n+3):(n+4));%�����m/s
Inter_A_start_test =  precessing_test1(:,(n+5):(n+6));
Inter_C_start_test =  precessing_test1(:,n+10);%!!

Inter_A_end_test = Inter_A_start_test;%���ٶȲ���
Inter_V_end_test = t.*Inter_V_start_test;%�ٶȰ��պ���ٶȼ���
Inter_S_end_test = Inter_S_start_test + Inter_V_start_test * t+ 0.5.*Inter_A_end_test.*t.^2;%���ٶ�ģ�ͼ���
Inter_C_end_test = Inter_C_start_test;%!!
%��ֵ
precessing_test_output1 = precessing_test1;
precessing_test_output1(:,(2*n*16+3):(2*n*16+4)) = Host_V_start_test;%�����о�������ٶ�,���ǳ��ٶ�  3:4��ʾ�ٶ�    
precessing_test_output1(:,(2*n*16+5):(2*n*16+6)) = Host_A_start_test;%�����о�����ļ��ٶȣ����ǳ����ٶ�
precessing_test_output1(:,(2*n*16+11+1):(2*n*16+11+2)) = Inter_S_end_test;%���轻�������λ��
precessing_test_output1(:,(2*n*16+11+3):(2*n*16+11+4)) = Inter_V_end_test;%���轻��������ٶ�
precessing_test_output1(:,(2*n*16+11+5):(2*n*16+11+6)) = Inter_A_end_test;%���轻������ļ��ٶ�
precessing_test_output1(:,2*n*16+11+10) = Inter_C_end_test;%��ԣ�����������ʣ���


%% �ָ���״�����֮ǰ��ID
precessing_train_ver_output = reshape(precessing_train_ver1_output',n*2,[])';  %�ԣ�2*n��Ϊһ���㣬��Ϊ������һ�������Ķ���㣻
precessing_test_output = reshape(precessing_test_output1',n*2,[])';

precessing_train_ver_output = [ID_Data_train_ver precessing_train_ver_output];%���֮ǰ��ID
precessing_test_output = [ID_Data_test precessing_test_output];
end