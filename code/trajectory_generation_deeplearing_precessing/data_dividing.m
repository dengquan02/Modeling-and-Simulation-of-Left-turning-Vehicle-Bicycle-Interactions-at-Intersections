%%���ݷָ�%%%%
function [mmin,mmax,x_train,y_train,x_ver,y_ver,x_test,y_test,sample_test] = data_dividing(input,generating_lengh) %start_point_test,ratio_test,mmin,mmax
% input=E_trajectory;
% ������������Ϊ����ʱʹ�ã�
%% �������ȿ�ʼ�������ݼ�������ѵ��������֤���Ͳ��Լ���
% ָ������
p_test=0.1;%���Լ�ռ�������ݵı������������ݻ�Ҫ����������չ������������ȡСһЩ��
p_train=0.7;%ѵ����ռѵ��������֤���ı�����


%n_inputΪ����켣��������֪�Ĺ켣������
%ѵ��������֤�������Լ��Ļ��ְ���0.6 0.2 0.2����  20��x��1��y  input=(2160,1681)
%x_train=(27216*180) y_train=(27216*9)
%x_ver=(11664*180) y_ver=(11664*9)
%x_test=(216*180) y_test=(216*189)


%% ���Ƚص����Լ�

%%%%%���Լ���ѵ��+��֤���ֿ�%%%%%%

all_ID=unique(input(:,1));%��ȡ�켣��ID
t=round(p_test*size(all_ID,1));%���Լ�����
nu=randperm(size(all_ID,1));%����ֿ���ȡǰt��Ϊ���Լ����ݣ��������ѵ��������֤����
all_ID = all_ID(nu',:);%����������������
data=input;%����һ����������Ⱦ���ݣ�
data_test = [];
data_train_ver = [];
for i = 1:size(all_ID,1)
    if i <= t
        data_test = [data_test;data(find(data(:,1)==all_ID(i)),:)];
    else
        data_train_ver = [data_train_ver;data(find(data(:,1)==all_ID(i)),:)];
    end
end

%% ���濪ʼ���������ݼ���׼������һ���Լ�������չ��ѭ��ȡ����

%%%���·ֱ���������ݼ�������%%%%%

%% ������չ
[sample_test] = data_expand_test(data_test,generating_lengh) ;%��չ���Լ�
[sample_train_ver] = data_expand(data_train_ver) ;%��չѵ������֤��

%������չ����ñ���һ�½��̣���Ϊ��������ݴ���ȽϺ�ʱ�����ҶԺ���ûʲôӰ�죬�����ظ�ʹ�ý��к���ĳ���
% ���е�������
%% ������������д���
N_lengh_point = size(sample_test,2);%��ȡ������һ����һ���ж��ٸ�����
N_lengh_train = 3*N_lengh_point;%��ȡÿ������һ���ж��ٸ�����
N_lengh_test = N_lengh_point * generating_lengh;%test�Ŀ�����ȣ���һ��������������


%%%��ѵ����_��֤���Ͳ��Լ����¸�����״,��ɿ����
precessing_test=reshape(sample_test',N_lengh_test,[])';%N_lengh��ʾһ�������ĳ��ȣ�
precessing_train_ver=reshape(sample_train_ver',N_lengh_train,[])';%N_lengh��ʾѵ�������ĳ��ȣ�

%%%%%%��ѵ�������ݴ���%%%%%%%
rrnu=randperm(size(precessing_train_ver,1));   %�����������������
precessing_train_ver = precessing_train_ver(rrnu, :); %����r��������н�����������

% ���е��ڶ����㣻
%%%�������ݷ�����ÿ���������Ϊ���仯�����Ժ��ٳ�������֮��ľ��롣��֤�����ڲ��Ĳ����Ժ�����֮��������ԣ���׼��Ϣ�������������
% [ratio_test,start_point_test,data_train_ver,data_test] = scal(data_test,data_train_ver,t,minE,fe,n_input);

%%%%�任��״��׼���������ݹ�һ��%%%%% �任��״��������N_lengh_point�����խ����
precessing_test=reshape(precessing_test',N_lengh_point,[])';%minE*fe��ʾ���Լ�ÿ���켣�ĵ���*ÿ�������������
precessing_train_ver=reshape(precessing_train_ver',N_lengh_point,[])';%fe��ʾ���Լ�ÿ�������������

%% �������һ�����ݣ��ǰ��յ��δ֪���滻���������˶�ѧ��ʽ����������
[precessing_train_ver_output,precessing_test_output] = Replace_feature_ODpoints(precessing_train_ver,precessing_test,generating_lengh);
% precessing_train_ver_output=precessing_train_ver;
% precessing_test_output=precessing_test;
%% ������й�һ��
char_all=[precessing_train_ver_output;precessing_test_output];%�ŵ�һ����������й�һ����



%% ����������ݴ��ң���ʼ���ݹ�һ��  �����￪ʼ������char_all����
%%%%%���ݹ�һ�������ÿ������ֵ��һ������Сֵ�����ֵ���������խ����%%%%
char_all(:,1:4) = [];%ɾ��ǰ���е����


% �����������Դ����￪ʼ

%%% �û�����һ������ֵ
char_all_handle = char_all;%
char_all_handle(:,7:9) = [];   %ADE=0.046��ʱ���ǣ�char_all_handle(:,7:10) = [];
char_all_handle(:,15:17) = [];   %ADE=0.046��ʱ���ǣ�char_all_handle(:,14:17) = []; 

char_all_handle_copy=char_all_handle;

[output,mmin,mmax] = Normalizing(char_all_handle);
%output=char_all;


% output(:,7)=char_all_handle(:,7);
% output(:,15)=char_all_handle(:,15);
%% ��ÿ���������ӱ�����Ϣ



lin_train_ver=size(precessing_train_ver,1);%��ȡѵ����֤������(������N_lengh_point)
N_lengh_point = size(output,2);%��ȡ������һ����һ���ж��ٸ�����
N_lengh_train = 3*N_lengh_point;%��ȡÿ������һ���ж��ٸ�����
N_lengh_test = N_lengh_point * generating_lengh;%test�Ŀ�����ȣ���һ��������������

% ��ѵ����֤������ ���ɿ����ÿ����һ������
data_train_ver_Nor=output(1:lin_train_ver,:);
data_train_ver_Nor=reshape(data_train_ver_Nor',N_lengh_train,[])';%���ɳ����󣬼�ÿ����һ��������


% �Բ��Լ�����  ���ɿ����ÿ����һ������
data_test_Nor=output(lin_train_ver+1:size(output,1),:);
data_test_Nor=reshape(data_test_Nor',N_lengh_test,[])';


tr=round(p_train*size(data_train_ver_Nor,1));%��ȡѵ����������������N_lengh��




%% ��ֵ%%%%%%%%
x_test = [data_test_Nor(:,1:N_lengh_point) data_test_Nor(:,N_lengh_test-N_lengh_point+1:N_lengh_test)];%ȡǰ����������Ϊx
y_test = data_test_Nor(:,N_lengh_point+1:N_lengh_test-N_lengh_point);%ȡ�м�ĵ���Ϊy

x_train = [data_train_ver_Nor(1:tr,1:N_lengh_point) data_train_ver_Nor(1:tr,2*N_lengh_point+1:N_lengh_train)];%ȡǰ����������Ϊx
y_train = data_train_ver_Nor(1:tr,N_lengh_point+1:2*N_lengh_point);%ȡ�м�ĵ���Ϊy

x_ver = [data_train_ver_Nor((tr+1):size(data_train_ver_Nor,1),1:N_lengh_point) data_train_ver_Nor((tr+1):size(data_train_ver_Nor,1),2*N_lengh_point+1:N_lengh_train)];%ȡǰ����������Ϊx
y_ver = data_train_ver_Nor((tr+1):size(data_train_ver_Nor,1),N_lengh_point+1:2*N_lengh_point);%ȡ�м�ĵ���Ϊy


%% ��һ������ y
[y_train,x_train] = handle_Y(y_train,x_train) ;
[y_ver,x_ver] = handle_Y(y_ver,x_ver) ;
save data_new2;
end