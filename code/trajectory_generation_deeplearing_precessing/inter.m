%��E�Ľ���ͼ
function [trajectory_block] = inter(trajectory_block,benchmark_E,Num_No,Num_V)
index = 2;%�켣���
X_dis = [];%���켣�����ƫ�ƾ���
Y_dis = [];%���ƫ�ƾ��뷢��ʱ���������
inter_dis = [];%���ƫ�ƾ��뷢��ʱ�������������Ľ�������
inter_X = [];
while index<=trajectory_block(size(trajectory_block,1),1)
    extract = trajectory_block(find(trajectory_block(:,1)==index),:);%��ȡ������Ĺ켣
%     plot(extract(:,2),extract(:,10),'k');%ʱ�����ٶȵĹ�ϵ
%     hold on
%     plot(extract(:,2),extract(:,13),'r');%ʱ����ƫ��ǵĹ�ϵ
%     title(['��',num2str(index),'�Ź켣���ٶ�ͼ']); %���ñ���
    X_dis = [X_dis;min(extract(:,5))];%�󱾹켣��Զƫ�ƾ���
    Y_dis = [Y_dis;mean(extract((extract(:,5)==min(extract(:,5))),4))];%��Զƫ�ƾ����������
    extract_far = extract((extract(:,5)==min(extract(:,5))),:);%�ҵ���Զƫ�ƾ�����Ǹ�ʱ�̣�
    extract_far = extract_far(1,:);%�ж����Сֵ�ģ�ֻ��һ��������
    extract_far(:,1:3) = [];
    extract_far = reshape(extract_far,11,[])';%�仯ά��
    extract_far(find(extract_far(:,11)==0),:)=[];%ȥ����ֵ
end
    %����������һ�½���������̵ĵ�
%     d = zeros(size(extract_far,1)-1,3);%���ھ���
%     d(:,1) = extract_far(2:size(extract_far,1),1)-extract_far(1,1);
%     d(:,2) = extract_far(2:size(extract_far,1),2)-extract_far(1,2);
%     d(:,3) = sqrt(d(:,1).^2+d(:,2).^2);%ŷʽ����
%     ID = find(d(:,3)==min(d(:,3)));%�ҵ���С��һ��
%     if ~isempty(d)
%         inter_dis = [inter_dis;min(d(:,3))];%����̽������뱣������
%         inter_X = [inter_X;extract_far(ID(1,1)+1,2)];%����������ĺ�������
%     else
%         inter_dis = [inter_dis;0];%���ǿռ���������0
%         inter_X = [inter_X;0];
%     end
%     if size(inter_X,1)~=size(X_dis,1)
%         disp(index);
%     end
%     inter_one = extract_far(ID+1,:);%��̽�������ĸ���������Ϣ
%     inter_one = [extract_far(1,:);inter_one];%����ͽ�������ŵ�һ���
    %�ҽ���������̵ĵ�end
%     hold on
%     plot(inter_one(:,1),inter_one(:,2));    
        
%     ��������ÿ���켣���ƶ�ͼ
%     index_ID = 1;%�켣����
    for index_ID = 1:22%size(extract,1)
         extract_point = extract(index_ID,:);
         extract_point(:,1:3) = [];%ȥ��ǰ��û���õı�ź�ʱ�䣻
         own = extract_point(1:11);%����Ԥ����������������
         NV = extract_point(12:Num_No*11+11);%���ǽ����ǻ����������������
         V = extract_point(Num_No*11+12:size(extract_point,2));%���ǽ��������������������
         NV = reshape(NV,11,[])';
         V = reshape(V,11,[])';
         NV(find(NV(:,11)==0),:)=[];
         V(find(V(:,11)==0),:)=[];
         %��ͼ
         figure(1)
         
         clf;
         scatter(benchmark_E(:,1),benchmark_E(:,2),'o','k')
         axis([0 50 10 35]); % ������������ָ��������
         hold on
         scatter(own(:,1),own(:,2),'*','b')%Ԥ������ĵ�
         axis([0 50 10 35]); % ������������ָ��������
         hold on 
         if ~isempty(NV)
         scatter(NV(:,1),NV(:,2),'*','r')%�����ǻ������ĵ�
         axis([0 50 10 35]); % ������������ָ��������
         end
         hold on
         if ~isempty(V)
         scatter(V(:,1),V(:,2),'*','m')%�����������ĵ�
         axis([0 50 10 35]); % ������������ָ��������
         end
         title(['��',num2str(index),'�Ź켣����',num2str(index_ID),'���켣��']); %���ñ���
         pause(0.1)
    end
    index = index+1;
end
% end
%��ͼ�����ƫ�ƾ����뵱ʱ����̽�������ĵ�ͼ���Ժ��������
scatter(inter_X,X_dis,'.','*');

% ����һ��������ƫ�Ƶ�ֱ��ͼ
X_dis = 27 - X_dis(:,1);
for i =1: size(X_dis,1)
       if X_dis (i,1)<0
          X_dis(i,1)=0;
       end
end
% X_dis(find(X_dis==0))=[];
intrusion = [X_dis Y_dis];%���������Ū��һ���
int_1 = intrusion(((35<intrusion(:,2))&(intrusion(:,2)<40.5)),:);%��С��һ����������
int_2 = intrusion(((0.5<intrusion(:,1))&(intrusion(:,1)<1)),:);%��С��һ����������,�����������Ƭ
scatter(int(:,1),int(:,2),'*','r');%��С��һ�����������ͼ
hist(int(:,1));%�Ժ�С��һ�����������ڵĺ���ƫ�ƾ������ֲ�
hist(int_2(:,2));%��
scatter(X_dis,Y_dis,'*','r');
hist(X_dis);
hist(Y_dis);

%��һ�·�����Ϊ�ľ���ͼ
% index = 1;%�켣���
% dis = [];
% while index<=trajectory_block(size(trajectory_block,1),1)
%     extract = trajectory_block(find(trajectory_block(:,1)==index),:);%��ȡ������Ĺ켣
%     for i =1:size(extract,1)-1
%         if extract(i,5)<27&&extract(i+1,5)>27%�����㷵������
%             dis = [dis;0.5*(extract(i,4)+extract(i+1,4))]; %��һ��ƽ��ֵ��
%         end
%     end
%     index = index +1;
% end
% dis = dis -3;
% hist(dis);

