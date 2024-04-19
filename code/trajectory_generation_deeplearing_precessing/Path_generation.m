function [output] = Path_generation(start_point,end_point,perception_time)
%����������������������֪�����յ�������,�����ߴα��������߲�ֵ���ɹ켣��
%�������յ�����꣬������й켣�������
%% ����
% start_point = [0.9 23.87];
% end_point=[-2.62 22.52];
%% �����ֵ���ɹ켣
step = abs(start_point(1,1)-end_point(1,1))/perception_time;
time_step = end_point(1,1):step:start_point(1,1);
alp = [0.0 0.0 0.2 0.8 1 1]*(start_point(1,2)-end_point(1,2));%������ֵ   alp = [0.1 0.3 0.2 0.5 0.1 0.1]*10;%������ֵ

s = [0:(1/perception_time):1];
dat = [];
for i = 1:size(s,2)
    dat = [dat;bezierPolynomials(s(i),alp)];%����
end
output = [time_step' (dat+end_point(1,2))];
output = flipud(output);
if size(output,2)<2
    if start_point(1,1)==end_point(1,1)
        output = [ones(size(output,1),1)*start_point(1,1) output];%�����յ����������һ������ֱ�Ӹ���
    end
end
% scatter(output(:,1),output(:,2),'*','r')
% hold on 
% scatter(Truth_no(:,4),Truth_no(:,5),'*','b')

% plot(dat);
end
