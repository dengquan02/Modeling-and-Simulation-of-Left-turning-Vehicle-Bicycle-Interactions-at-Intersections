function [aim_danger,Nu_part] = Monte_Carlo_NV(long,short,M,char,frequency,NV_index)
% tic
%ͨ�����ؿ���ģ�����Σ�նȾۼ��̶ȣ����ø��ʵ����Σ�նȼ���
% x = extract(1,1);%x����
% y = extract(1,2);%y����
% angle = extract(1,10);%�Ƕȣ��ýǶ������Ӧ���Ǿ��ԽǶȣ����Ǹ�������ĽǶȣ�������������ϸ���ĽǶ�

index = 1;
Nu_part = [];
% while index<20

%���������ؿ��������
% %����
% long = 5;%����Ȧ�ĳ����ᣬ�Զ�����������;
% short = 3;%����Ȧ�Ķ���
% M = 100;%�㹻��������������ϵĿ�����
% NV_index = 0.2;%Σ�նȶ���ָ����0-1֮��
% char = 1;%�궨�Ĳ���,�Ƕ�Ϊ0ʱ�Ĳ���
% frequency = 10^8;%ʵ�����
ecc = (long^2-short^2)^0.5/(long);%�����ʣ�ͨ����������м���

%���������
RandData = rand(frequency,3);%������ά�����������frequency��
RandData(:,1) = (RandData(:,1)*2*long)-long;%x����
RandData(:,2) = (RandData(:,2)*2*short)-short;%y����
RandData(:,3) = RandData(:,3)*M;%Z����

%ɸѡ
ell = zeros(size(RandData,1),2);
for i = 1:size(RandData,1)%�����Ƿ����Ҫ��
    ell(i,1) = ((RandData(i,1)^2)/(long^2))+((RandData(i,2)^2)/(short^2));%�����Ƿ�����Բ��,��ʱ��Բ����������ԭ��
    [a,r] = cart2pol((RandData(i,1)+(abs(long^2-short^2))^0.5),(RandData(i,2)));%ֱ������ת��Ϊ������,������ԭ��ת�����󽹵��� ((long_V^2-short_V^2)^0.5)��ָc
    ell(i,2) = char*(((1-ecc^2)/(r*(1-ecc*cos(a))))^NV_index);%����ÿ��λ�õ�Σ�ն�ֵ     
end
aim = RandData(find((ell(:,1)<=1)&RandData(:,3)<=ell(:,2)),:);%��ȡ����Ҫ��ĵ�

% scatter3(aim(:,1),aim(:,2),aim(:,3),'.','r');%��ͼ
Nu_part = [Nu_part;[size(aim,1) frequency]];
% index = index + 1;
% end
% toc
%�õ����������Σ�նȷֲ��㣬��ʵ��������еĸ߶��Ѿ�ûʲô���ˣ���Ϊֻ������ȷ����һ�»��������Ժ�ֻ����ƽ�����ڽ�������ĵ�Ϳ���
% aim_danger(:,1) = aim(:,1)+x;%������㻻������ʵλ��
% aim_danger(:,2) = aim(:,2)+y;
% aim_danger(:,3) = aim(:,3);%�߶�ֱ�ӷ���ȥ
aim_danger = aim;

end

