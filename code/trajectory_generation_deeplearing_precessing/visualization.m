function [path] = visualization(extract_trajectory,path,index_in,perception_Radius)
%���ӻ�
% extract_one����ʵ�켣
% path��Ԥ��켣
truth = extract_trajectory(index_in:min((index_in+20),size(extract_trajectory,1)),4:5);
scatter(truth(:,1),truth(:,2),'*','b')
hold on 
%%
%draw a cycle at the points
for i = 1:size(path,1)
r=perception_Radius;                                                    %���ð뾶Ϊ20
theta=0:pi/100:2*pi;                             %��pi/100ΪԲ�Ľǻ�Բ
x=path(i,1)+r*cos(theta);                              %Բ�ĺ�����Ϊ40
y=path(i,2)+r*sin(theta);  
hold on%Բ��������Ϊ40
plot(x,y,'r');  
pause(0.1);
end



end

