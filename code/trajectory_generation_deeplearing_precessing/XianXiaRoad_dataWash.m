%% ��������
[input_NV]=xlsread('E:\Prediction_of_BIM\DataSet\MyData\����·��ϼ��·������\������ֱ�зǻ�����\������ֱ�зǻ�����.xlsx',1);%��ȡ��ϼ·�Ķ�����ֱ�зǻ�����
[input_V_east]=xlsread('E:\Prediction_of_BIM\DataSet\MyData\����·��ϼ��·������\������ֱ�л�����\������ֱ�л�����.xlsx',1);%��ȡ��ϼ·�Ķ�����ֱ�л�����
[input_V_westLeft]=xlsread('E:\Prediction_of_BIM\DataSet\MyData\����·��ϼ��·������\��������ת������\��������ת������ԭʼ����.xlsx',1);%��ȡ��ϼ·����������ת������

%% datdawash ������ֱ�зǻ�����
%ȥ����������
input_NV(:,1)=[];
% scatter(input_NV(:,2),input_NV(:,3),'.','r');%��ͼ
N=sum(isnan(input_NV(:,1)));%����켣����
n=0;
for i=1:size(input_NV,1)%��ͬһ���켣���Ϻ�
    s=isnan(input_NV(i,1));
    if s==1
       n=n+1;
       input_NV(i,12)=n;
    else
       input_NV(i,12)=n;
    end
end
data = [];
index = 1;%����
for i=1:input_NV(size(input_NV,1),size(input_NV,2))%�޳������
    exter = input_NV(find(input_NV(:,size(input_NV,2))==i),:);%��ȡ��ǰ�켣
    exter(find(isnan(exter(:,2))),:) = [];%ȥ��nan��
    if isempty(exter) == 1
        continue
    end
    v_conu = sum(sign(exter(size(exter,1)-10:size(exter,1),4)));
    if sum(exter(:,2)>25)&&(v_conu>8)||sum((exter(:,2)<10))%�޳���������·�ұ��뿪�ǻ�����û�л����ģ�����δ����ֱ�еĹ켣�����������25�����11����ĺ�����ٶ���8����ȥ�ľ��޳�����
        continue
    else
        exter(:,size(exter,2)) = index;%���������
        data = [data ; exter];
        index = index +1;
    end 
end
data = [data zeros(size(data,1),1)];
index_in = 2;%������ʼ
data(1,13) = 1;%�����ϵ�һ����Ű�
for i=2:size(data,1)%��ͬһ�켣��ÿ���켣����
    if data(i,12) == data(i-1,12)%�����ǰ�켣����ǰһ���켣������ͬһ���켣������
       data(i,13) = index_in;
       index_in = index_in + 1;
    else
       data(i,13) = 1;
       index_in = 2;
    end
end



for i=1:size(data,1)%�ж��ǵ綯���������г�
     if data(i,8)>=18%�ж��ٶ��Ƿ����18
         aaa18=data(i,12);%��ȡ�켣���
         for i1=1:size(data,1)%�ҵ��켣�����յ�
             if data(i1,12)==aaa18
                data(i1,16)=2;%���Ϻ�2��ʾ�ǵ綯��
             end
         end
     else
         aaa18=data(i,12);%��ȡ�켣���
         for i1=1:size(data,1)%�ҵ��켣�����յ�
             if data(i1,12)==aaa18
                data(i1,16)=1;%���Ϻ�1��ʾ�����г�
             end
         end
     end
end       
figure(1)
scatter(data(:,2),data(:,3),'.','r');%��ͼ
output=data(~any(isnan(data),2),:);%ɾ��nan
output(:,14)=[];
%output(:,4:11)=[];
output_cell = num2cell(output); 
% title = {'GlobalTime', 'X[m]', 'Y[m]','ID','ID_in','ID_straight','type'}; 
title = {'GlobalTime', 'X[m]', 'Y[m]','Vx[m/s]','Vy[m/s]','Ax[m/s2]','Ay[m/s2]','Speed[km/h]','Acceleration[m/s2]','Space[m]','Curvature[1/m]','ID','ID_in','ID_straight','type'}; 
result = [title; output_cell];
s = xlswrite('data_XXRoad.xlsx',result,1);  


%% datdawash ������ֱ�л�����
%ȥ����������,Ťת�Ƕȣ�ƫ��3.76��
input_V_east(:,1)=[];
% figure(2)
% scatter(input_V_east(:,2),input_V_east(:,3),'.','r');%��ͼ
for i = 1:size(input_V_east,1)%�����д�������ʽ��ֵ��ƫ��3.76��
    for j = 2:2:7
        [theta,r] = cart2pol(input_V_east(i,j),input_V_east(i,j+1));
        [input_V_east(i,j),input_V_east(i,j+1)] = pol2cart(deg2rad(rad2deg(theta)+3.76),r);
    end
end
        
N=sum(isnan(input_V_east(:,1)));%����켣����
n=0;
for i=1:size(input_V_east,1)%��ͬһ���켣���Ϻ�
    s=isnan(input_V_east(i,1));
    if s==1
       n=n+1;
       input_V_east(i,12)=n;
    else
       input_V_east(i,12)=n;
    end
end
data = [];
index = 1;%����
for i=1:input_V_east(size(input_V_east,1),size(input_V_east,2))%�޳������
    exter = input_V_east(find(input_V_east(:,size(input_V_east,2))==i),:);%��ȡ��ǰ�켣
    exter(find(isnan(exter(:,2))),:) = [];%ȥ��nan��
    if isempty(exter) == 1
        continue
    end
    v_conu = sum(sign(exter(size(exter,1)-10:size(exter,1),4)));
    if sum(exter(:,2)>21)&&(v_conu>8)||sum((exter(:,2)<10))%�޳���������·�ұ��뿪�ǻ�����û�л����ģ�����δ����ֱ�еĹ켣�����������25�����11����ĺ�����ٶ���8����ȥ�ľ��޳�����
        continue
    else
        exter(:,size(exter,2)) = index;%���������
        data = [data ; exter];
        index = index +1;
    end 
end
data = [data zeros(size(data,1),1)];
index_in = 2;%������ʼ
data(1,13) = 1;%�����ϵ�һ����Ű�
for i=2:size(data,1)%��ͬһ�켣��ÿ���켣����
    if data(i,12) == data(i-1,12)%�����ǰ�켣����ǰһ���켣������ͬһ���켣������
       data(i,13) = index_in;
       index_in = index_in + 1;
    else
       data(i,13) = 1;
       index_in = 2;
    end
end



for i=1:size(data,1)%�ж��ǵ綯���������г�
     if data(i,8)>=18%�ж��ٶ��Ƿ����18
         aaa18=data(i,12);%��ȡ�켣���
         for i1=1:size(data,1)%�ҵ��켣�����յ�
             if data(i1,12)==aaa18
                data(i1,16)=3;%���Ϻ�3��ʾȫ�ǻ�����
             end
         end
     else
         aaa18=data(i,12);%��ȡ�켣���
         for i1=1:size(data,1)%�ҵ��켣�����յ�
             if data(i1,12)==aaa18
                data(i1,16)=3;%���Ϻ�3��ʾȫ�ǻ�����
             end
         end
     end
end       
figure(2)
scatter(data(:,2),data(:,3),'.','r');%��ͼ
output=data(~any(isnan(data),2),:);%ɾ��nan
output(:,14)=[];
%output(:,4:11)=[];
output_cell = num2cell(output); 
% title = {'GlobalTime', 'X[m]', 'Y[m]','ID','ID_in','ID_straight','type'}; 
title = {'GlobalTime', 'X[m]', 'Y[m]','Vx[m/s]','Vy[m/s]','Ax[m/s2]','Ay[m/s2]','Speed[km/h]','Acceleration[m/s2]','Space[m]','Curvature[1/m]','ID','ID_in','ID_straight','type'}; 
result = [title; output_cell];
s = xlswrite('data_XXRoad.xlsx',result,2);  

%% datdawash ��������ת������
%ȥ����������
input_V_westLeft(:,1)=[];
input_V_westLeft(:,12:size(input_V_westLeft,2))=[];
% figure(2)
% scatter(input_V_westLeft(:,2),input_V_westLeft(:,3),'.','r');%��ͼ
% for i = 1:size(input_V_westLeft,1)%�����д�������ʽ��ֵ��ƫ��3.76��
%     for j = 2:2:7
%         [theta,r] = cart2pol(input_V_westLeft(i,j),input_V_westLeft(i,j+1));
%         [input_V_westLeft(i,j),input_V_westLeft(i,j+1)] = pol2cart(deg2rad(rad2deg(theta)-3.76),r);
%     end
% end
        
N=sum(isnan(input_V_westLeft(:,1)));%����켣����
n=0;
for i=1:size(input_V_westLeft,1)%��ͬһ���켣���Ϻ�
    s=isnan(input_V_westLeft(i,1));
    if s==1
       n=n+1;
       input_V_westLeft(i,12)=n;
    else
       input_V_westLeft(i,12)=n;
    end
end
data = [];
index = 1;%����
for i=1:input_V_westLeft(size(input_V_westLeft,1),size(input_V_westLeft,2))%�޳������
    exter = input_V_westLeft(find(input_V_westLeft(:,size(input_V_westLeft,2))==i),:);%��ȡ��ǰ�켣
    exter(find(isnan(exter(:,2))),:) = [];%ȥ��nan��
    if isempty(exter) == 1
        continue
    end
    v_conu = sum(sign(exter(size(exter,1)-10:size(exter,1),4)));
    if 0>1%�޳������������ʾȫ��Ҫ
        continue
    else
        exter(:,size(exter,2)) = index;%���������
        data = [data ; exter];
        index = index +1;
    end 
end
data = [data zeros(size(data,1),1)];
index_in = 2;%������ʼ
data(1,13) = 1;%�����ϵ�һ����Ű�
for i=2:size(data,1)%��ͬһ�켣��ÿ���켣����
    if data(i,12) == data(i-1,12)%�����ǰ�켣����ǰһ���켣������ͬһ���켣������
       data(i,13) = index_in;
       index_in = index_in + 1;
    else
       data(i,13) = 1;
       index_in = 2;
    end
end



for i=1:size(data,1)%�ж��ǵ綯���������г�
     if data(i,8)>=18%�ж��ٶ��Ƿ����18
         aaa18=data(i,12);%��ȡ�켣���
         for i1=1:size(data,1)%�ҵ��켣�����յ�
             if data(i1,12)==aaa18
                data(i1,16)=3;%���Ϻ�3��ʾȫ�ǻ�����
             end
         end
     else
         aaa18=data(i,12);%��ȡ�켣���
         for i1=1:size(data,1)%�ҵ��켣�����յ�
             if data(i1,12)==aaa18
                data(i1,16)=3;%���Ϻ�3��ʾȫ�ǻ�����
             end
         end
     end
end         
figure(3)
scatter(data(:,2),data(:,3),'.','r');%��ͼ
output=data(~any(isnan(data),2),:);%ɾ��nan
output(:,14)=[];
%output(:,4:11)=[];
output_cell = num2cell(output); 
% title = {'GlobalTime', 'X[m]', 'Y[m]','ID','ID_in','ID_straight','type'}; 
title = {'GlobalTime', 'X[m]', 'Y[m]','Vx[m/s]','Vy[m/s]','Ax[m/s2]','Ay[m/s2]','Speed[km/h]','Acceleration[m/s2]','Space[m]','Curvature[1/m]','ID','ID_in','ID_straight','type'}; 
result = [title; output_cell];
s = xlswrite('data_XXRoad.xlsx',result,3);  

        