%% ��ȡ��Ŀ¼�µ�����txt�ļ�
path = 'M:\New_try\trajectory_generation_deeplearingModel\result_test\';%python��Ԥ������ַ
namelist = dir('M:\New_try\trajectory_generation_deeplearingModel\result_test\*.txt');%��ȡ����txt�ļ���  %python��Ԥ������ַ
file_list = sort_nat({namelist.name}); %���ļ����������� ԭ���������
leng = length(file_list);%��ȡ������
P = cell(1,leng);%����һ��ϸ�����飬���ڴ������txt�ļ�
for i = 1:leng
    file_name{i}=file_list(1,i);
    file_name_1 = strcat(file_name{i});
    file_name_curent = strcat(path,file_name_1);
    P{1,i} = load(cell2mat(file_name_curent));
end
   
x_test = csvread('x_test.csv');%����������
%x_test = [x_test zeros(size(x_test,1),(28-16))];

y_test = csvread('y_test.csv');%����������
N_lengh_point = size(x_test,2)/2;%�̾���Ŀ��  ����22
truth_data_test = [x_test(:,1:N_lengh_point) y_test x_test(:,N_lengh_point+1:2*N_lengh_point)];%�ϳ���ʵ�Ĳ�������





%%  ����Ԥ����

prediction = P;

% generating_lengh = 17;

%%%���ϰ�Ԥ�����ֵ�����ݸ�ʽŪ��һ���ģ����õ�yy��tt
pre_data_test=zeros(size(truth_data_test,1),size(truth_data_test,2));%yy��Ԥ��ֵ
for i = 1:size(x_test,1) %��Ԥ��ֵ�ŵ���ֵ��״
    pre_data_test(i,:)=(reshape(prediction{1,i}',[1,size(truth_data_test,2)]));%����
end


pre_data_test=reshape(pre_data_test',N_lengh_point,[])';%Ԥ��ֵ��N_lengh_point����������
truth_data_test=reshape(truth_data_test',N_lengh_point,[])';%��ʵֵ��N_lengh_point����������

% ������
[tt_t,yy_y] = Anti_normalizating(truth_data_test,pre_data_test,mmax,mmin); %����һ����tt_t��ʾ��ֵ��yy_y��ʾԤ�⣬���ȥ����խ����
tt_t=reshape(tt_t',(N_lengh_point*generating_lengh),[])';%�任��״,��ɿ����
yy_y=reshape(yy_y',(N_lengh_point*generating_lengh),[])';%�任��״,��ɿ����

prediction=yy_y;
T_V=tt_t;
    
%% %%�������  ����ͼ
%����Ԥ�����ݵ�MSE
ADE_all = [];
for i = 1:leng
    pre_one = reshape(prediction(i,:)',(N_lengh_point),[])';
    truth_one = reshape(T_V(i,:)',(N_lengh_point),[])';
%     figure(2)
%     clf
%     scatter(truth_one(:,1),truth_one(:,2),'*','b');
%     hold on
%     scatter(pre_one(:,1),pre_one(:,2),'*','r');
%     pause(0.5)
%     i = i+1;
    ADE_one = mean(((pre_one(:,1)-truth_one(:,1)).^2+(pre_one(:,2)-truth_one(:,2)).^2).^0.5);
    disp(ADE_one)
    
    ADE_all = [ADE_all;ADE_one];%���ADE
end
mean(ADE_all)%������Լ��ϵ�ƽ���������
hist(ADE_all)%���ֲ�ͼ
save data_new2
% %% 
% %�������˽�����������һЩ�����õĴ���
% ADE_all(find(ADE_all(:,1)>5),:) =[];%�������ȥ�������ߵĴ�����
% 
% 
% %% ���ӻ�ѵ�������鿴�����ѵ�����Ƿ�����
% for i = 1:1000
%     figure(1)
% %     clf
%     scatter(x_train(i,1),x_train(i,2),'b','*');%ѵ�������
%     hold on
%     scatter(x_train(i,14+1),x_train(i,14+2),'b','*');%ѵ�������
%     hold on
%     scatter(y_train(i,1),y_train(i,2),'r','*');%ѵ�������
% %     pause(1)
% %     i=i+1;
% end

% ��������
% MSE=zeros(generating_lengh,2);%����������ʾÿ���켣�ĵ�i�����ƽ����
% jj=1;
% MSE_di=zeros(size(x_test,1),n_input+2);
% for j =(size(x_test,2)+1):fe:size(prediction,2)
%     MSE(jj,2)=jj;%���
%     se=0;
%     for i=1:size(x_test,1)
%         se_di=((((prediction(i,j)-T_V(i,j))^2)+((prediction(i,j+1)-T_V(i,j+1))^2))^0.5);%ÿ������
%         se=se+se_di;%����ÿ��Ԥ����ƽ�����MSE
%         MSE_di(i,jj+1)=se_di;
%         MSE_di(i,1)=i;%���
%     end
%     MSE(jj,1)=se/size(x_test,1);
%     jj=jj+1;
% end
% MSE_1=MSE_di(:,1:2);%��һ���������һ���Ǳ�ţ��ڶ��п�ʼ�ǵ�һ����
% MSE_1=sortrows(MSE_1,2);%����
% 
% 
% AEE=zeros(size(x_test,1),2);%��ʾÿ���켣��21��Ԥ����ƽ�����
% for i=1:size(x_test,1)
%     AEE(i,2)=i;%���
%     binahao=0;
%     for j = (size(x_test,2)+1):fe:size(prediction,2)
%         AEE(i,1)= AEE(i,1)+((((prediction(i,j)-T_V(i,j))^2)+((prediction(i,j+1)-T_V(i,j+1))^2))^0.5);
%         binahao=binahao+1;
%     end
%     AEE(i,1)= AEE(i,1)/binahao;%��ƽ��ֵ��֮ǰ��������
% end
% AEE_SORT=sortrows(AEE,1);
% mean_AEE=mean(AEE_SORT(:,1));
% disp(['mean_AEE is ',num2str(mean_AEE) ]);
% 
% %%%�����ݷֿ����ֳ����ͺͷ����͹켣��
% [RMSE_swell,RMSE_non,GT_swell,GT_non,prediction_swell,prediction_non] = result_divide(AEE,prediction,T_V,fe);
% disp(['mean_RMSE_swell is ',num2str(mean(RMSE_swell(:,1))) ]);
% disp(['mean_RMSE_non is ',num2str(mean(RMSE_non(:,1))) ]);
% disp(['var_non is ',num2str(var(RMSE_non(:,1))) ]);
% disp(['var_swell is ',num2str(var(RMSE_swell(:,1))) ]);
% 
% 
% figure(7)
% RMSE_data = RMSE_non(:,1);%��ȡ���
% [M,M1] = hist(RMSE_data , (0:0.5:12));%��Ƶ��
% bar(M1,M);
% 
% %%%�����͹켣��ͼ%%%%%
% figure(5);
% for j = 1:fe:(size(x_test,2))
%     scatter(prediction_swell(:,j),prediction_swell(:,j+1),'x','b');%ԭʼ����
%     hold on
% end
% 
% for j = (size(x_test,2)+1):fe:size(GT_swell,2)
%     scatter(GT_swell(:,j),GT_swell(:,j+1),'+','g');%��ʵֵ�ĺ���
%     hold on
% end
% for j = (size(x_test,2)+1):fe:size(prediction_swell,2)
%     scatter(prediction_swell(:,j),prediction_swell(:,j+1),'x','r');%Ԥ������
%     hold on
% end
% 
% %%%�����й켣��ͼ%%%%%
% figure(1);
% for j = 1:fe:(size(x_test,2))
%     scatter(prediction(:,j),prediction(:,j+1),'x','b');%ԭʼ����
%     hold on
% end
% 
% for j = (size(x_test,2)+1):fe:size(T_V,2)
%     scatter(T_V(:,j),T_V(:,j+1),'+','g');%��ʵֵ�ĺ���
%     hold on
% end
% for j = (size(x_test,2)+1):fe:size(prediction,2)
%     scatter(prediction(:,j),prediction(:,j+1),'x','r');%Ԥ������
%     hold on
% end
% 
% 
% %%%%������һ���켣��ͼ%%%%%
% shunxu = 68;
% % while shunxu<=216
% i=AEE_SORT(shunxu,2);
% figure(2);
% clf %���ǰ���ͼ�õ�
% for j = (size(x_test,2)+1):fe:size(prediction,2)
%     scatter(prediction(i,j),prediction(i,j+1),'*','r');%Ԥ������
%     hold on
% end
% for j = 1:fe:(size(x_test,2))
%     scatter(prediction(i,j),prediction(i,j+1),'*','b');%ԭʼ����
%     hold on
% end
% for j = (size(x_test,2)+1):fe:size(T_V,2)
%     scatter(T_V(i,j),T_V(i,j+1),'*','g');%��ʵֵ�ĺ���
%     hold on
% end
% shunxu = shunxu+1;
% pause(0.5);
% % end
% 
% 
% 
% %%%��ѵ�����ݵ�ͼ%%%%%
% figure(3);
% for j = 1:fe:(size(x_train,2))
%     scatter(x_train(1:100,j),x_train(1:100,j+1),'x','b');%ԭʼ����
%     hold on
% end
% for j = 1:fe:9
%     scatter(y_train(1:100,j),y_train(1:100,j+1),'x','r');%ԭʼ����
%     hold on
% end
% %%%������ѵ�����ݵ�ͼ%%%%%
% i=1;
% % while i<1900
% figure(4);
% clf %���ǰ���ͼ�õ�
% for j = 1:fe:(size(x_train,2))
%     scatter(x_train(i,j),x_train(i,j+1),'x','b');%ԭʼ����
%     hold on
% end
% for j = 1:fe:(size(y_train,2))
%     scatter(y_train(i,j),y_train(i,j+1),'x','r');%ԭʼ����
%     hold on
% end
% i=i+1;
% pause(0.5);
% % end
% 
% 
% % i=1;
% % while i<=13
% %     figure(9)
% % [M,M1] = hist(x_train(:,i));%��Ƶ��
% % bar(M1,M);
% % figure(10)
% % [M,M1] = hist(x_ver(:,i));%��Ƶ��
% % bar(M1,M);
% % figure(11)
% % [M,M1] = hist(x_test(:,i));%��Ƶ��
% % bar(M1,M);
% % i=i+1;
% % pause(2)
% % end