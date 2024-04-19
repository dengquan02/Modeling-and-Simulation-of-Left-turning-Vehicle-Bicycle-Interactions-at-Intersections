function [EL_co] = elliptical_index(E_trajectory,e,angle)
%���������������֮�����Բ������룬���Ƿ���ָ���ֲ�
e=0.8;
ang = 5;
angle = 1;%��һ�ĽǶ�
input = E_trajectory;
%ȥ��������������
% for i = 1:30
%     input((input(:,2)==i),:)=[];
% end

input(:,1:3) = [];%ȥ������Ҫ�Ķ���
index = 1;%һ��һ�еļ���
NU = 100;%�������
d = [];
A = [];
R = [];
EU_co = [];
% figure(1)
while index <=size(input,1)
    extract = reshape(input(index,:)',11,[])';%�����11�е�
    extract(all(extract==0,2),:)=[];
    if size(extract,1)>1%�������1��˵���������н�������
       extract_except = extract;%�����ó���һ�������������弯
       extract_except(:,1) = extract_except(:,1)-extract(1,1);%x����������(��һ��)���й�һ
       extract_except(:,2) = extract_except(:,2)-extract(1,2);%y������������й�һ
       extract_except((extract_except(:,1)==0&extract_except(:,2)==0),:) = [];%��֮ǰ������ɾ������Ϊ����ԭ��
       EU_co = [EU_co;extract_except(:,1:2)];%����ŷʽ�����һ���
       for j = 1:size(extract_except,1)%��������d�Ľ���������˵
           [a,r] = cart2pol(extract_except(j,1),extract_except(j,2));%a��r�ֱ��ʾ������ĽǶȺͼ��� 
           R = [R;r];%��ż���
           A = [A;a];%��ŽǶ�
%                polarscatter(a,r,'.','r');
%                hold on 
           d = [d;((r*(1-e*cos(a)))/(1-e*cos(angle)))];%�����ľ��루�Ƕ�Ϊangle���������������ڣ�
%                d = [d;(r*(1-(e*cos(a))))/(1-e^2)];%�����ľ��루�Ƕ�Ϊ0���������������ڣ�
        end
    end
index = index +1;
disp(['�����',num2str(index/size(input,1)*100),'%'])
end

%��һ�����ϵ�Ƶ���ֲ�ͼ
% figure(2)
EL_co = [A R];%�����꣬AΪ�Ƕȣ�RΪ����
EL_co = unique(EL_co,'rows');%ȥ����ͬ�������ݣ���Ϊ�еı��ظ�����
EL_part = EL_co((EL_co(:,1)<deg2rad(5+ang)),:);%�ҵ��Ƕ�С��5+ang
EL_part = EL_part((EL_part(:,1)>deg2rad(ang)),:);%�ҵ��Ƕȴ���ang
% polarscatter(EL_part(:,1),EL_part(:,2),'.','r');%���ҵ��ĵ���ͼ
one_dis = (max(EL_part(:,2)))/NU;%��һ������ľ���
sameNU = hist(EL_part(:,2),NU);%�ֵ�һЩ��������
sameNU = [sameNU;zeros(1,size(sameNU,2))];
for i = 1:size(sameNU,2)
    sameNU(1,i) = sameNU(1,i)/(one_dis*i);%ÿ������ĸ���Ҫ���԰뾶�����������ռ�Ĳ���
    sameNU(2,i) = (one_dis*i);
end
histogram(sameNU,NU);
% hist(EL_part(:,2));


%��������ͼ
polarscatter(A,R,'.','r');%�����е���ͼ
scatter(EU_co(:,1),EU_co(:,2),'.','r');
% hist(R,100);
% polarscatter(a,r,'.');

%������Բ
ecc = axes2ecc(1.8,0.8);%������ ���ᣩ
[elat,elon] = ellipse1(0,0,[1.8 ecc],0);
hold on 
plot(elat,elon,'b')

% dis = d;
% dis(find(dis>=1))=[];
% hist(dis);
% R(find(R>=1.5))=[];
% hist(R);
% save;
% shutdown;%������֮���Զ��ػ�
end

