function [path,max_dis] = longest_path(DAG,extract_one,NUm,benchmark_risk,perception_Radius,all_risk)
%%�ڶ����޸ĵĴ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%long_path���·����max_dis���·�������棬DAG������ͼ
%ͨ��̰���㷨�����·��
%��ÿһ��������ģ����վ������
%�ҵ���㣬���λ��ʱ���1������λ��0������λ��1
%��ʼ��
% NUm = 3;
% origin = find((DAG(1,:)==1)&(DAG(3,:)==0)&(DAG(4,:)==1));%�ҵ�Դ��
% long_path = zeros(NUm,1);
% long_path(:,:) = origin;%�·�����,��һ����Դ��,���У�ÿ�θ������һ����Ѱ����һ��
% max_dis = [0;0;0];%���ӵ�����ֵ
% time_step = 1;
% 
% while time_step<DAG(1,size(DAG,1))
%     long_path_time = [];%��ǰ������·�����
%     dis = zeros(NUm*3,1);
%     for i = 1:size(long_path,1)%����ÿ��Դ��,�ҵ�����һ���ĵ�
%         left = find((DAG(1,:)==DAG(1,long_path(i,size(long_path,2)))+1)&(DAG(3,:)==DAG(3,long_path(i,size(long_path,2)))+1)&(DAG(4,:)==DAG(4,long_path(i,size(long_path,2)))+1));%�ҵ���һ��ʱ����ߵĵ�
%         right = find((DAG(1,:)==DAG(1,long_path(i,size(long_path,2)))+1)&(DAG(3,:)==DAG(3,long_path(i,size(long_path,2)))-1)&(DAG(4,:)==DAG(4,long_path(i,size(long_path,2)))+1));%�ҵ���һ��ʱ���ұߵĵ�
%         next = find((DAG(1,:)==DAG(1,long_path(i,size(long_path,2)))+1)&(DAG(3,:)==DAG(3,long_path(i,size(long_path,2))))&(DAG(4,:)==DAG(4,long_path(i,size(long_path,2)))+2));%�ҵ���һ��ʱ��ǰ���ĵ�
% %       fixed = find((DAG(1,:)==DAG(1,origin)+1)&(DAG(3,:)==DAG(3,origin))&(DAG(4,:)==DAG(4,origin)));%�ҵ���һ��ʱ�̶̹������ĵ�
%         llong = [long_path(i,:) left;long_path(i,:) right; long_path(i,:) next];%�ò�����·��
%         long_path_time = [long_path_time;llong];%����һ��������һ���о���·��
%         dis(((i-1)*3)+1,1) = max_dis(i,:) + DAG(long_path(i,size(long_path,2)),left);%��i��������
%         dis(((i-1)*3)+2,1) = max_dis(i,:) + DAG(long_path(i,size(long_path,2)),right);%��i������ұ�
%         dis(((i-1)*3)+3,1) = max_dis(i,:) + DAG(long_path(i,size(long_path,2)),next);%��i������м�
%     end
%     %Ѱ���������·��
%     long_path_time = [dis long_path_time];%��·���������,��1��
%     long_path_time = sortrows(long_path_time, -1);
%     long_path = long_path_time(1:NUm,2:size(long_path_time,2));%��ȡ��������·��
% %     disp(long_path)
%     max_dis = long_path_time(1:NUm,1);%��ȡ������������ָ
%     time_step = time_step + 1;
% end
% 
% %�ҵ���������·��
% long_path_time(:,1) = [];%ɾ��ǰ����һ�ѵ�dis
% long_path_time = [dis long_path_time];%��·���������,��1��
% long_path_time = sortrows(long_path_time, -1);
% long_path = long_path_time(1,2:size(long_path_time,2));%��ȡ��������·��
% max_dis = long_path_time(1,1);%��ȡ������������ָ
% 
% %���·����ԭ������
% path = zeros(size(long_path,2),2);
% path(1,:) = extract_one(1,4:5);%������������ 
% for i = 1:size(long_path,2)
%     path(i+1,:) = DAG(long_path(i),5:6);%��ȡÿ����ɢ�������
% end 

%%��һ�εĴ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%������ԭ������
% origin = find((DAG(1,:)==1)&(DAG(3,:)==0)&(DAG(4,:)==1));%�ҵ�Դ��
% long_path = [];%�·�����
% max_dis = 0;%���ӵ�����ֵ
% time_step = 1;
% while time_step<DAG(1,size(DAG,1))
%    left = find((DAG(1,:)==DAG(1,origin)+1)&(DAG(3,:)==DAG(3,origin)+1)&(DAG(4,:)==DAG(4,origin)+1));%�ҵ���һ��ʱ����ߵĵ�
%    right = find((DAG(1,:)==DAG(1,origin)+1)&(DAG(3,:)==DAG(3,origin)-1)&(DAG(4,:)==DAG(4,origin)+1));%�ҵ���һ��ʱ���ұߵĵ�
%    next = find((DAG(1,:)==DAG(1,origin)+1)&(DAG(3,:)==DAG(3,origin))&(DAG(4,:)==DAG(4,origin)+2));%�ҵ���һ��ʱ��ǰ���ĵ�
% %    fixed = find((DAG(1,:)==DAG(1,origin)+1)&(DAG(3,:)==DAG(3,origin))&(DAG(4,:)==DAG(4,origin)));%�ҵ���һ��ʱ�̶̹������ĵ�
%    ID_dis = [left right next;DAG(origin,left) DAG(origin,right) DAG(origin,next)];%��һ����ID��DAG�ģ����ڶ��������ǵ��ۺ�����  ID_dis = [left right next fixed;DAG(origin,left) DAG(origin,right) DAG(origin,next) DAG(origin,fixed)];
%    max_dis = max_dis + ID_dis(2,(ID_dis(2,:)==max(ID_dis(2,:))));%���Ӹò������������·��
%    ID = ID_dis(1,(ID_dis(2,:)==max(ID_dis(2,:))));%�ҵ�ID  ��DAG�ڣ�
%    if size(ID,2)>1%����������һ���Ļ��������ѡһ��
%        ID = ID(1,randperm(size(ID,2),1));
%    end
%    long_path = [long_path ID];%���Ӹò���������������(DAG��)
%    %���±��
%    origin = ID;%�ҵ��¸�������Դ�㣬�����ڲ������յ�
%    time_step = time_step + 1;
% end
% %���·����ԭ������
% path = zeros(size(long_path,2),2);
% path(1,:) = extract_one(1,4:5);%������������ 
% for i = 1:size(long_path,2)
%     path(i+1,:) = DAG(long_path(i),5:6);%��ȡÿ����ɢ�������
% end  
% end

%%�����εĴ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
min_risk = min(all_risk(:,7));%����С����ֵ
origin = find((DAG(1,:)==1)&(DAG(3,:)==0)&(DAG(4,:)==1));%�ҵ�Դ��
long_path = [];%�·�����
max_dis = 0;%���ӵ�����ֵ
time_step = 1;
while time_step<DAG(1,size(DAG,1))
   left = find((DAG(1,:)==(DAG(1,origin)+1))&(DAG(3,:)==(DAG(3,origin)-1))&(DAG(4,:)==(DAG(4,origin)+1)));%�ҵ���һ��ʱ����ߵĵ�
   right = find((DAG(1,:)==(DAG(1,origin)+1))&(DAG(3,:)==(DAG(3,origin)+1))&(DAG(4,:)==(DAG(4,origin)+1)));%�ҵ���һ��ʱ���ұߵĵ�
   next = find((DAG(1,:)==(DAG(1,origin)+1))&(DAG(3,:)==(DAG(3,origin)))&(DAG(4,:)==(DAG(4,origin)+2)));%�ҵ���һ��ʱ��ǰ���ĵ�
%    fixed = find((DAG(1,:)==DAG(1,origin)+1)&(DAG(3,:)==DAG(3,origin))&(DAG(4,:)==DAG(4,origin)));%�ҵ���һ��ʱ�̶̹������ĵ�
   ID_dis = [left right next;DAG(origin,left) DAG(origin,right) DAG(origin,next)];%��һ����ID��DAG�ģ����ڶ��������ǵķ���  ID_dis = [left right next fixed;DAG(origin,left) DAG(origin,right) DAG(origin,next) DAG(origin,fixed)];
   if DAG(origin,next)<benchmark_risk%��ֱ�ߵķ��ձȽϵͣ���һ����ֱ��
       max_dis = max_dis + perception_Radius*2;
       best_ID = ID_dis(1,3);%�ҵ�ID
   else%����Ļ����ͼ�������������ۺ������ۺ�����
       ID_dis(2,1) = perception_Radius*(1-((DAG(origin,left)-min_risk)/(benchmark_risk-min_risk)));
       ID_dis(2,2) = perception_Radius*(1-((DAG(origin,right)-min_risk)/(benchmark_risk-min_risk)));
       ID_dis(2,3) = perception_Radius*2*(1-((DAG(origin,next)-min_risk)/(benchmark_risk-min_risk)));
       max_dis = max_dis + ID_dis(2,(ID_dis(2,:)==max(ID_dis(2,:))));%���Ӹò������������·��
       best_ID = ID_dis(1,(ID_dis(2,:)==max(ID_dis(2,:))));%�ҵ�ID  ��DAG�ڣ�
       if size(best_ID,2)>1%����������һ���Ļ��������ѡһ��
          best_ID = best_ID(1,randperm(size(best_ID,2),1));
       end
   end
   long_path = [long_path best_ID];%���Ӹò���������������(DAG��)
   %���±��
   origin = best_ID;%�ҵ��¸�������Դ�㣬�����ڲ������յ�
   time_step = time_step + 1;
end
%���·����ԭ������
path = zeros(size(long_path,2),2);
path(1,:) = extract_one(1,4:5);%������������ 
for i = 1:size(long_path,2)
    path(i+1,:) = DAG(long_path(i),5:6);%��ȡÿ����ɢ�������
end  

end
