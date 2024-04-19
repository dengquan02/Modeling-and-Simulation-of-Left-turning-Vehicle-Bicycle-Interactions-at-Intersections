function [output] = Risk_Perception(Risk,main,long_Per,short_Per)
%����Ԥ�������Σ�նȸ�ֵ֪
% main = extract(1,:);
Risk_all = Risk;
Risk_all(:,1) = Risk(:,1)-main(1,1);%�任����
Risk_all(:,2) = Risk(:,2)-main(1,2);
[Risk_pol(:,1),Risk_pol(:,2)] = cart2pol(Risk_all(:,1),Risk_all(:,2));%��ֱ������ת��Ϊ�����ꣻ ��1���ǽǶȣ���2���Ǽ���
Risk_pol(:,1) = Risk_pol(:,1) + 0;%�任�Ƕ�  Risk_pol(:,1) = Risk_pol(:,1) + main(1,10);%�任�Ƕ�
Nu = zeros(size(Risk_pol,1),1);%�Ƿ�����Բ��
ecc = (long_Per^2-short_Per^2)^0.5/(long_Per);%�����ʣ�ͨ����������м���

for i = 1:size(Risk_pol,1)%��ÿ������˵���鿴���Ƿ�����Բ��
    radius = long_Per*(1-ecc^2)/(1-ecc*cos(Risk_pol(i,1)));%���ڵ�ǰ�Ƕȣ�����Բ�İ뾶��radius
    if Risk_pol(i,2) <= radius  %������ĳ���С�����Ļ��㳤��
        Nu(i,1) = 1;%����Բ�ڵı�Ϊ1
    end
end
output = sum(Nu);
end
    
    

