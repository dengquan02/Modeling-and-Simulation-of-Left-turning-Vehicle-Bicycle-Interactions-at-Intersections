function [sample] = data_expand(input) 
%%������չ%%%%
%�ú�����Ŀ���ǰѹ켣���ָ�Ϊ�������ֱ���3��5....
% input = data_train_ver;%����ѵ������

%% ���¿�ʼ������չ
N_test = unique(input(:,1));
sample = [];%�������
index = 1;
for i = 1:size(N_test,1)
    
    exter_trajectory = input(input(:,1)==N_test(i),:);
    ID_index = 2:2:16; %���ɲ�ͬ��ѭ��ȡ������         ID_index = 2:2:size(exter_trajectory,1); %���ɲ�ͬ��ѭ��ȡ������
    for j = 1:size(ID_index,2)
        for z = 1:ID_index(j):size(exter_trajectory,1) - ID_index(j)
%             portion_point_x = (exter_trajectory(z+(ID_index(j))/2,4)-exter_trajectory(z,4))/(exter_trajectory(z+ID_index(j),4)-exter_trajectory(z,4));%ÿ���м��ռ���յ�ı���  x����
%             portion_point_y = (exter_trajectory(z+(ID_index(j))/2,5)-exter_trajectory(z,5))/(exter_trajectory(z+ID_index(j),5)-exter_trajectory(z,5));%ÿ���м��ռ���յ�ı���  x����
            sample_1 = [[index exter_trajectory(z,:)] ; [index exter_trajectory(z+(ID_index(j))/2,:)]; [index exter_trajectory(z+ID_index(j),:)]];%���յ���м��
            sample = [sample; sample_1];%ÿ�����������У������ȥ
            index = index + 1;
            disp(['  i��',num2str(i),'  j��',num2str(j),'  z��',num2str(z),])
        end
    end
end
% sample_train_ver = sample;
end
    