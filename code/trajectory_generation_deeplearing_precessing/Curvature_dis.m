function [output] = Curvature_dis(input1,input2)
%�������������켣������Ӧ�������֮��
% input1 = Truth_no(:,4:5);
% input2 = output1;
index_size = size(input1,1);%��ȡ�켣�Ĺ켣����
cos_ang_all = [];%��Ÿ�����Ӧ��ĽǶȲ������ֵ
dis_all = [];
for i = 1:index_size-1
    new_1 = input1(i:i+1,:);
    new_2 = input2(i:i+1,:) - (input2(i,:) - input1(i,:));%���յ�һ���߶ε�����һ��
    ang_dis = polyarea([new_1(2:size(new_1,1),1);new_2(:,1)],[new_1(2:size(new_1,1),2);new_2(:,2)])/norm(new_1(1,:)-new_1(2,:))*100;
    cos_ang_all = [cos_ang_all;ang_dis];
    dis = norm(input1(i,:)-input2(i,:));%����켣��֮��ľ������
    dis_all = [dis_all;dis];
%     disp(dis)
%     disp(ang_dis)
end
cos_dis = mean(cos_ang_all);%��Ϊ����ֵ�Ǽ�����������������ֵ����ȡ�Ƕȵ���Сֵ  
output = cos_dis + mean(dis_all);
end

% scatter([new_1(:,1);new_2(:,1)],[new_1(:,2);new_2(:,2)],'*','r')