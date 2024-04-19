function [output] = Curvature_calculation(input1,input2)
%��������
% %% ԭʼ����
% % x0 = 0 : 0.1 : 2 * pi;
% % y0 = sin(x0).*cos(x0);
% % x0=input1;
% % y0=input2;
% 
% aplha=0:pi/40:2*pi;
% r=2;
% x0=r*cos(aplha);
% y0=r*sin(aplha);
% scatter(x0,y0);
% 
% h = abs(diff([x0(2), x0(1)]));
% 
% %%һ�׵�
% ythe1 = cos( x0 ) .^2 - sin(x0).^2; %����һ�׵�
% yapp1 = gradient(y0, h); %matlab��ֵ����
% 
% % hold on;
% % plot(x0, ythe1, '.');
% % plot(x0, yapp1, 'r');
% % legend('����ֵ', 'ģ��ֵ');
% % title('һ�׵�');
% 
% %%���׵�
% ythe2 = (-4) * cos(x0) .* sin(x0); %���۶��׵�
% yapp2 = 2 * 2 * del2(y0, h);       %matlab��ֵ����
% 
% % figure
% % hold on;
% % plot(x0, ythe2,'.');
% % plot(x0, yapp2,'r');
% % legend('����ֵ', 'ģ��ֵ');
% % title('���׵�');
% 
% %% ģ������
% syms x y
% y = sin(x) * cos(x);
% yd2 = diff(y, 2);
% yd1 = diff(y, 1);
% k = (yd2) / (1+yd1^2)^(3/2);  %% ���ʹ�ʽ   k = abs(yd2) / (1+yd1^2)^(3/2);  %% ���ʹ�ʽ
% cc1 = subs(k, x, x0);
% cc2 = (yapp2)./(1+yapp1.^2).^(3/2);  %ԭ���Ǿ���ֵ��cc2 = abs(yapp2)./(1+yapp1.^2).^(3/2);
% bar(cc2)
% % figure
% % hold on;
% % plot(x0, cc1, '.');
% % plot(x0, cc2, 'r');
% % legend('����ֵ', 'ģ��ֵ');
% % title('����');
% output = cc2;%�������ֵ

%% �´���
input1=[1;2;1;1]   ;             %traj_points(:,1);     %E_trajectory(find(E_trajectory(:,1)==1),4);
input2=[1;1;2;1] ;                  %traj_points(:,2);    %E_trajectory(find(E_trajectory(:,1)==1),5);
kappa_arr = [];
posi_arr = [];
norm_arr = [];

for num = 2:(length(input1)-1)
    x = input1(num-1:num+1,:)';
    y = input2(num-1:num+1,:)';
    [kappa,norm_l] = PJcurvature(x,y);
    posi_arr = [posi_arr;[x(2),y(2)]];
    kappa_arr = [kappa_arr;kappa];
    norm_arr = [norm_arr;norm_l];
end
kappa_arr = [0;kappa_arr;0];
output = kappa_arr ;%�������

end
