function [ext_time] = envir_pre(ext,perception_time)
%ʹ�ú��ٶȵ�Ԥ�ⷽ������Χ��������Ԥ��
% ����ֵ�ǿ����λ��1-2��ʾxy��3-4��ʾVxVy���Դ�����
time_step = perception_time;%Ԥ�ⲽ��
% ��ʼԤ��
point_index = 1;%�ӵ�point_index���㿪ʼԤ�⣻
ext_time = [];%Ԥ��õ�δ������λ��
while point_index <=size(ext,1)
   Vx = [ext(point_index,3)/(1/0.12),ext(point_index,4)/(1/0.12)];%��ȡpoint_index���ٶ� ����һ��ϵ������Ϊ�ٶȵ�λ��m/s�����㵽һ������
   traj_pre = [ext(point_index,1),ext(point_index,2)];%��point_index����
   for i = 1:time_step
       traj_pre = [traj_pre;[(traj_pre(i,1)+Vx(1,1)),(traj_pre(i,2)+Vx(1,2))]];%���ٶ�Ԥ��
   end
%    clf
%    scatter(traj_pre(:,1),traj_pre(:,2),'*','r');
%    hold on
%    scatter(ext(point_index:(point_index+time_step),1),ext(point_index:(point_index+time_step),2),'*','b');
%    pause(0.5)
   ext_time = [ext_time traj_pre];%��ȡÿ�������δ����Ԥ��ֵ
   point_index = point_index+1;
end
end

