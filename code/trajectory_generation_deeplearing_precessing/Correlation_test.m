function [outputArg1,outputArg2] = Correlation_test(inputArg1,inputArg2)
global E_trajectory;
%����ͨ��������ͬʱ�̵ĸ��壬ͨ��λ�������ʶ�𽻻�����
%% ���������һ��������һ�½�����ϵ����ʵûɶ�ã���Ϊ������������ҲҪ������������ǵĳ�ͻ���л�������һ��֮��ʧȥ����������Ϣ
index = 1;
while index <=E_trajectory(size(E_trajectory,1),1)
    operation = E_trajectory(E_trajectory(:,1)==index,:);
    %����һ�½�����λ�Ķ�̬ͼ
    for i = 1:size(operation,1)
        postion = operation(i,:);%��ȡһ��ʱ��Ƭ��
        postion(:,1:3) = [];%ȥ��ǰ����û�õĶ���
        postion = reshape(postion',11,[])';
        postion(all(postion==0,2),:)=[];%ȥ��ȫ0��
        postion_zero = postion(:,1:2);
        postion_zero(:,1) = postion(:,1)-postion(1,1);%���������һ��
        postion_zero(:,2) = postion(:,2)-postion(1,2);
        clf
        scatter(postion_zero(:,1),postion_zero(:,2),'*','b')
        axis([-25 25 -10 10]); % ������������ָ��������
        hold on 
        scatter(postion_zero(1,1),postion_zero(1,2),'*','r')
        axis([-25 25 -10 10]); % ������������ָ��������
        pause(0.1)
    end
end

%% ����������ʱ��ͼ������ͨ������Թ�ϵ�ҵ����ǵĽ�������ȷ����������
end
index = 55;
while index <=E_trajectory(size(E_trajectory,1),1)
    operation = E_trajectory(E_trajectory(:,1)==index,:);
    for i = 1:11
        scatter(operation(:,2),operation(:,11),'r','*')%������ʱ��ͼ
        hold on 
        scatter(operation(:,2),operation(:,11+(i)*11),'b','*')%������ʱ��ͼ
        hold on 
    end
end
