function [output] = chose(input,perception_Radius)
%input��һ��λ��
%�������ҵ�input������ѡ��λ��
output = zeros(3,2); %output���������еķ�ʽ����
%left
output(1,1) = input(1,1) - perception_Radius;%��ߣ�������-�뾶
output(1,2) = input(1,2) - (perception_Radius*3^0.5);%��ߣ�������-3^0.5*�뾶
%right
output(2,1) = input(1,1) - perception_Radius;%y�ұߣ�������-�뾶
output(2,2) = input(1,2) + (perception_Radius*3^0.5);%�ұߣ�������-3^0.5*�뾶
%next
output(3,1) = input(1,1) -(perception_Radius*2);%�м䣬��������������뾶
output(3,2) = input(1,2);%�м䣬���������
end

