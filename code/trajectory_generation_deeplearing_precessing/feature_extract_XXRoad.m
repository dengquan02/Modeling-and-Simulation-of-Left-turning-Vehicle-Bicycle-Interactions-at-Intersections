%% ���ű���Ŀ���Ƕ����ݽ���Ԥ���������ѵ����������֤�����Լ���������
tic;
%% ��ȡ���ݣ��������
%��ÿ���켣���Ӧ�Ļ������ͷǻ���������ŵ�ͬһ����,14��
[E1]=xlsread('M:\New_try\����������ݣ�T=0.12s��.xlsx',1);%������ֱ�зǻ�����
[E1V]=xlsread('M:\New_try\����������ݣ�T=0.12s��.xlsx',2);%������ֱ�л�����
[W1V]=xlsread('M:\New_try\����������ݣ�T=0.12s��.xlsx',3);%��������ת������
id_amount=max(E1(:,12))
endPoints=zeros(id_amount,2);
count=1;
len1=length(E1(:,12));
for i=1:len1-1
    if(E1(i+1,13)<E1(i,13))
        endPoints(count,1)=E1(i,2);
        endPoints(count,2)=E1(i,3);
        count=count+1;
    end
end
endPoints(id_amount,1)=E1(len1,2);
endPoints(id_amount,2)=E1(len1,3);
global endpoint_x
endpoint_x=median(endPoints(:,1));
global endpoint_y
endpoint_y=median(endPoints(:,2));
E1(:,14) = [];
E1V(:,14) = [];
W1V(:,14) = [];
E1= [E1(:,1:11) E1(:,13) E1(:,12) E1(:,14)];
E1V= [E1V(:,1:11) E1V(:,13) E1V(:,12) E1V(:,14)];
W1V= [W1V(:,1:11) W1V(:,13) W1V(:,12) W1V(:,14)];

% scatter(E1(:,16),E1(:,17),'.','r');%��ͼ
% scatter(E1V(:,16),E1V(:,17),'.','r');%��ͼ
% scatter(W1V(:,16),W1V(:,17),'.','r');%��ͼ

%% ������Ҫ���켣����֤������ǰ�������Ǵ�������
[E1] = change_rad(E1,90);
[E1V] = change_rad(E1V,90);
[W1V] = change_rad(W1V,90);
%%  �������
Num_No=1;%�����ķǻ���������ĸ�����Ŀǰ�ǰ��վ�����̵ļ���,�ο�����6����
Num_V=0;%�����Ļ���������
perception_time = 17;%����Ԥ�ⲽ��  17/33
generating_lengh = perception_time;
n_input=generating_lengh;%����������켣�����
% csvwrite('intrusion_cood_EXXRoad.csv',intrusion_cood_EXXRoad)
global intrusion_cood_E
intrusion_cood_EXXRoad = csvread('intrusion_cood_EXXRoad.csv');%��ȡ����������׼��Ϣ����ʾ��׼�����꣬���������Ӧ�����ĸ��㣬����·��������ʱ���ֱ�Ϊ���¡����¡����ϡ�����
intrusion_cood_E = intrusion_cood_EXXRoad;



%%%ȥ����ͬ����
[E1] = same_out(E1);
[E1V] = same_out(E1V);
[W1V] = same_out(W1V);


%%%�ҵ�ֱ�зǻ�����
[E_straight] = [E1(:,1:12) E1(:,14) E1(:,13)];%find_straight(E1,35,60,15,40,-10,10,20,40);


%% ����������������  ���E_trajectory
%%%%%%%��E��N�����������������%%%%%%%
[NVinterract,Vinterract] = DATA_merge (E1,[],E1V,W1V,[]);%%DATA merge
%����ȫ�ֱ���
% global trajectory_block;
global E_trajectory;
[E_trajectory] = data_handle(E_straight,NVinterract,Vinterract,Num_No,Num_V,1);%��ԭʼ���ݴ����Ū���������� ,���һ�����ֱ�ʾ�켣��0�ĸ������ܳ���������

% scatter(E_trajectory(:,4),E_trajectory(:,5),'.','b')
%������ͼ
benchmark_EXXRoad = csvread('benchmark_EXXRoad.csv');%��ȡ��׼��Ϣ
% csvwrite('benchmark_EXXRoad.csv',benchmark_EXXRoad);%��ȡ��׼��Ϣ


%% ȥ����Ч��������Ĺ켣����
N_eist = [];
N_zeros = find(E_trajectory(:,25)==0);
for i = 1:size(N_zeros,1)
    N_eist = [N_eist;E_trajectory(N_zeros(i),1)];
end
N_eist = unique(N_eist);
for j = 1:size(N_eist,1)
    E_trajectory(find(E_trajectory(:,1)==N_eist(j)),:)=[];%ȥ��ȱʡֵ
end

%%%% ���ϵõ�E_trajectory���������������������ȷ���������֮����Ա�������������ģ��ֻ�漰����� data_dividing����


%%
%%%%%���ݷָ����ѵ�����ݡ���֤���ݺͲ�������%%%%  �������ǻ������ݼ������������ݴ�����һ������׼��֮���
[mmin,mmax,x_train,y_train,x_ver,y_ver,x_test,y_test,sample_test] = data_dividing(E_trajectory,generating_lengh);%minE��ʾÿ���켣�Ĺ켣������� n_input��ʾ����ĸ��� ,start_point_test,ratio_test,mmin,mmax



%% ɾ��һ�������õ�����  ��Ҫ���յ���ٶȺͼ��ٶ�����  �����ᵼ���յ�������м��ĳ��Ȳ�ͬ  ÿ������������һ��ʱ����
% x_train(:,17:size(x_train,2)) = [];%ɾ���յ�ĳ�λ�������������
% x_ver(:,17:size(x_ver,2)) = [];%ɾ���յ�ĳ�λ�������������
% x_test(:,17:size(x_test,2)) = [];%ɾ���յ�ĳ�λ�������������

%% д������%%%
csvwrite('x_train.csv',x_train);%���¶����浽��ǰĿ¼����
csvwrite('y_train.csv',y_train);
csvwrite('x_ver.csv',x_ver);
csvwrite('y_ver.csv',y_ver);
csvwrite('x_test.csv',x_test);
csvwrite('y_test.csv',y_test);

testdividing(x_test,'M:\New_try\trajectory_generation_deeplearingModel\data_test');  %��ַ�Ǳ�����������ĵ�ַ

%% ȥpythonѵ��ģ�ͺ�Ԥ�⣬���õ����ɹ켣�㣬ת��ű����ӻ���֤Visualization_TG��
save data_new;

toc
disp('The job is done!!!')



