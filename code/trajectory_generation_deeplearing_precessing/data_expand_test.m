function [sample] = data_expand_test(input_test,generating_lengh) 
%%������չ%%%%
%�ú�����Ŀ���ǰѹ켣���ָ�Ϊ�������ֱ���3��5....
% input_test = data_test;%�����������
% generating_lengh = 17;%�������ɵĳ��ȣ������ǵ���  
% �Բ��Թ켣������չ����Ҫ�ǰѳ��켣�и�ɺ��ʵĳ��ȣ�

%% ���¿�ʼ������չ
N_test = unique(input_test(:,1));%��ȡ�켣���
sample = [];%�������
index = 1;
for i = 1:size(N_test,1)%��ÿ���켣���д���
    exter_trajectory = input_test(input_test(:,1)==N_test(i),:);
    start_point = randperm(generating_lengh,1)-1;%��1~generating_lengh�м������ʼ
    for j = start_point : generating_lengh : size(exter_trajectory,1)-generating_lengh  %���ɲ�ͬ�Ļ��ּ���
        sample_1 = [ones(generating_lengh,1)*index exter_trajectory(j+1:j+generating_lengh,:)];  %generating_lengh����
        sample = [sample; sample_1];%ÿ��������generating_lengh���㣨���У���
        index = index + 1;
        disp(index);
    end
end
% sample_test = sample;
end
    