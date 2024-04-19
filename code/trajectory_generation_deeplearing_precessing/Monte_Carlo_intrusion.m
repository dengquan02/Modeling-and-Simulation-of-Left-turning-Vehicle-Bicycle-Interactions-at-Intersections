function [aim_danger,Nu_part] = Monte_Carlo_intrusion(intrusion_cood_E,char_intrusion,M,frequency_NV,long,short)
% tic
%ͨ�����ؿ���ģ���������Σ�նȾۼ��̶ȣ����ø��ʵ����Σ�նȼ���
%intrusion_cood_E��ʾ��׼�����꣬���������Ӧ�����ĸ��㣬����·��������ʱ���������£��ֱ������ϡ����¡����ϡ����µ�˳�򣬺�����-������
% csvwrite('intrusion_cood_E.csv',intrusion_cood_E);%д���׼��Ϣ
index = 1;
Nu_part = [];
% while index<20

%���������ؿ�������֣���ס��ʱ��ʵ�������֮ǰ���йأ�Ӧ������ʵ�����������
% %����
% long = 5;%NV�ĳ��������;
% short = 3;%NV�Ķ̰������
% M = 100;%�㹻��������������ϵĿ�����
% char_intrusion = 100;%�궨�Ĳ���,����ĳ̶�
% frequency_NV = 10^6;%��̬������ʵ�����,���ݴ˴����������ʵ���������ʵ������й�
frequency_intrusion = round(frequency_NV*((abs((intrusion_cood_E(1,1)-intrusion_cood_E(3,1))*(intrusion_cood_E(1,2)-intrusion_cood_E(2,2)))*M)/((2*long)*(2*short)*(M))));%��ȡ�����ʵ�����

%���������
RandData = rand(frequency_intrusion,3);%������ά�����������frequency_intrusion��
RandData(:,1) = (RandData(:,1)*(abs(intrusion_cood_E(3,1)-intrusion_cood_E(1,1))));%����Χ
RandData(:,2) = (RandData(:,2)*(abs(intrusion_cood_E(1,2)-intrusion_cood_E(2,2))));%����Χ
RandData(:,3) = RandData(:,3)*M;%Z����

%ɸѡ
ell = zeros(size(RandData,1),1);
for i = 1:size(RandData,1)%�����Ƿ����Ҫ��
    ell(i,1) = (RandData(i,3)<=(log((RandData(i,2)*char_intrusion+1)))) ; %;%ֻɸѡ��z������ں�����ֵ������yֵ���㣩���У�x���겻�ù�
end
aim = RandData(find(ell(:,1)==1),:);%��ȡ����Ҫ��ĵ�

% scatter3(aim(:,1),aim(:,2),aim(:,3),'.','r');%��ͼ
Nu_part = [Nu_part;[size(aim,1) frequency_intrusion]];
% index = index + 1;
% end
% toc
%�õ����������Σ�նȷֲ��㣬��ʵ��������еĸ߶��Ѿ�ûʲô���ˣ���Ϊֻ������ȷ����һ�»��������Ժ�ֻ����ƽ�����ڽ�������ĵ�Ϳ���
% aim_danger(:,1) = aim(:,1)+x;%������㻻������ʵλ��
% aim_danger(:,2) = aim(:,2)+y;
% aim_danger(:,3) = aim(:,3);%�߶�ֱ�ӷ���ȥ
aim_danger = aim;

end

