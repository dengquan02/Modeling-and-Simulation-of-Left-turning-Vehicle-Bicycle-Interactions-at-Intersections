[input]=xlsread('E:\Prediction_NV\Data_preprocessing\������ϴ����\ԭʼ����\������·ī��·�ǻ�����.xlsx',1);
%datdawash
%Ѱ�����յ����ض�����Ĺ켣
%�ýű�û���޳������㲽�裬��N2����
input(:,1)=[];
scatter(input(:,2),input(:,3),'.','r');%��ͼ
N=sum(isnan(input(:,1)));%����켣����
n=0;
for i=1:size(input,1)%��ͬһ���켣���Ϻ�
    s=isnan(input(i,1));
    if s==1
       n=n+1;
       input(i,12)=n;
    else
       input(i,12)=n;
    end
end
for i=1:size(input,1)%��ͬһ�켣��ÿ���켣����
    s2=isnan(input(i,1)); 
    if s2==1
       n_in=0;
    else
       n_in=n_in+1;
    end
    input(i,13)=n_in;
end
% AA=0;
% AAA=0;
% for i=1:size(input,1)%�ҵ��켣�����յ�
%     if input(i,13)==1&&5<input(i,2)&&input(i,2)<25&&40<input(i,3)&&input(i,3)<55%�ж�����Ƿ���ָ������
%         AAA=AAA+1;
%         sp=i;
%            while input(sp+1,13)~=0%�ҵ���Ӧ���յ�
%                if (sp+1)>=size(input,1)
%                    break
%                else
%                    sp=sp+1; 
%                end
%            end
%         if 0<input(sp,2)&&input(sp,2)<15&&0<input(sp,3)&&input(sp,3)<20%�ж��յ��Ƿ���ָ������
%            AA=AA+1;
%              aaa=input(i,12);%��ȡ�켣���
%                for i1=1:size(input,1)%�ҵ��켣�����յ�
%                    if input(i1,12)==aaa
%                        input(i1,14)=1;%���Ϻ�1��ʾ��ֱ�зǻ�����
%                        input(i1,15)=AA;
%                    end
%                end
%         end
%     end
% end
% 
% for i=1:size(input,1)%������ֱ�еĹ켣��Ū��nan
%     if input(i,14)~=1
%         input(i,:)=nan;
%     end
% end
for i=1:size(input,1)%�ж��ǵ綯���������г�
     if input(i,8)>=18%�ж��ٶ��Ƿ����18
         aaa18=input(i,12);%��ȡ�켣���
         for i1=1:size(input,1)%�ҵ��켣�����յ�
             if input(i1,12)==aaa18
                input(i1,16)=2;%���Ϻ�2��ʾ�ǵ綯��
             end
         end
     else
         aaa18=input(i,12);%��ȡ�켣���
         for i1=1:size(input,1)%�ҵ��켣�����յ�
             if input(i1,12)==aaa18
                input(i1,16)=1;%���Ϻ�1��ʾ�����г�
             end
         end
     end
end   
scatter(input(:,2),input(:,3),'.','r');%��ͼ
output=input(~any(isnan(input),2),:);%ɾ��nan
output(:,14)=[];%��14�б��Ϊ1��ʾֱ��
%output(:,4:11)=[];%��ʾ���������������ٶ�xy�����ٶ�xy��ת��ǣ������
output_cell = num2cell(output); 
% title = {'GlobalTime', 'X[m]', 'Y[m]','ID','ID_in','ID_straight','type'};
title = {'GlobalTime', 'X[m]', 'Y[m]','Vx[m/s]','Vy[m/s]','Ax[m/s2]','Ay[m/s2]','Speed[km/h]','Acceleration[m/s2]','Space[m]','Curvature[1/m]','ID','ID_in','ID_straight','type'}; 
result = [title; output_cell];
s = xlswrite('data.xlsx',result,1);  
