function [output] = find_straight(E1,start_x_0,start_x_1,start_y_0,start_y_1,end_x_0,end_x_1,end_y_0,end_y_1)
%��������ֱ��ʾ�����������Լ�����յ���������Լ��
input = E1;
add = zeros(size(E1,1),2);
input = [input add];
AA=0;
AAA=0;
for i=1:size(input,1)%�ҵ��켣�����յ�
    if input(i,12)==1&&start_x_0<input(i,2)&&input(i,2)<start_x_1&&start_y_0<input(i,3)&&input(i,3)<start_y_1%�ж�����Ƿ���ָ������input(i,12)==1��ʾ��һ����
        sp=i;
        AAA=AAA+1;
           while input(sp,12)<input(sp+1,12)%�ҵ���Ӧ���յ�(ֻҪ��һ�����С��ǰһ����ţ�˵�����켣�ˣ���ʱ��sp��Ӧ�ľ����յ�)
               if (sp+1)>=size(input,1)
                   break
               else
                   sp=sp+1; 
               end
           end
        if end_x_0<input(sp,2)&&input(sp,2)<end_x_1&&end_y_0<input(sp,3)&&input(sp,3)<end_y_1%�ж��յ��Ƿ���ָ������
           AA=AA+1;
             aaa=input(i,13);%��ȡ�켣���
               for i1=1:size(input,1)%�ҵ��켣�����յ�
                   if input(i1,13)==aaa
                       input(i1,15)=1;%���Ϻ�1��ʾ��ֱ�зǻ�����
                       input(i1,16)=AA;
                   end
               end
        end
    end
end

for i=1:size(input,1)%������ֱ�еĹ켣��Ū��nan
    if input(i,15)~=1
        input(i,:)=nan;
    end
end
% scatter(input(:,2),input(:,3),'.','r');%��ͼ
% scatter(E1(:,2),E1(:,3),'.','r');%��ͼ
output=input(~any(isnan(input),2),:);%ɾ��nan
output(:,15)=[];%ɾ����ʾֱ�еı��
output(:,13)=[];%ɾ���ɱ��ID
end

