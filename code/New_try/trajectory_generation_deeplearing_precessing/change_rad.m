function [output] = change_rad(E1,VAL)
%��תһ���ĽǶȣ���ʱ��
%VAL�Ƕ���
for i = 1:size(E1,1)%�����д�������ʽ��ֵ��ƫ��3.76��
    for j = 2:2:7
        [theta,r] = cart2pol(E1(i,j),E1(i,j+1));
        [E1(i,j),E1(i,j+1)] = pol2cart(deg2rad(rad2deg(theta)+VAL),r);
    end
end
output = E1;
end

