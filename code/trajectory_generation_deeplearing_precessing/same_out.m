function [output_E] = same_out(E1)
%%%%������һ���켣��ͼ%%%%%
% shunxu = 649;
% figure(2);
% while shunxu<=E1(size(E1,1),5)
% clf %���ǰ���ͼ�õ�
% current = E1(find(E1(:,5)==shunxu),:);
% scatter(current(:,2),current(:,3),'*','r');%Ԥ������
% title(['���Ϊ',num2str(shunxu)]);
% pause(0.2)
% shunxu = shunxu+1;
% end
%%%ȥ����ͬ������
index = max(E1(:,12));%������켣����
E = [];
for i = 1:E1(size(E1,1),13)
    alone = zeros(1,index*14);%���ÿ���켣�ľ���
    current = E1(find(E1(:,13)==i),:);
%     current_out_in_X = unique(current(:,2));%��x������ͬ����Ҫ���������
%     current_out_in_Y = unique(current(:,3));%��y������ͬ����Ҫ���������
%     if size(current,1)/size(current_out_in_X,1)>2||size(current,1)/size(current_out_in_Y,1)>2
%         break
%     end
    current(:,13)=[];
    current = reshape(current',1,[]);%resap����������
    alone(1,1:size(current,2)) = current;
    E = [E;alone];
end
E_handle = unique(E,'rows');  
output_E =[];
index = 1;
for i = 1:size(E_handle ,1)
    if mod(size(E_handle,2),13) ~=0
       alone = [E_handle(i,:),zeros(1,13-mod(size(E_handle,2),13))];
    else
       alone = E_handle(i,:);
    end
    current_after = reshape(alone,13,[])';
    current_after(find(current_after(:,1)==0),:)=[];
    current_after(:,13) = max(current_after(:,13));%�����͸��������Ҫģ������
    if ~isempty(current_after)
            index_M = zeros(size(current_after,1),1);
            index_M(:,1) = index;%�����±��
            current_after = [current_after(:,1:12),index_M,current_after(:,13)];
            output_E = [output_E;current_after];
            index = index + 1;
    end
end
end


%     %��ͼ
%     figure(2);
  
%     for i = 1:size(E,1)
%         clf %���ǰ���ͼ�õ�
%        for j = 1:5:size(E,2)
%            scatter(E(i,j+1),E(i,j+2),'*','r');%Ԥ������
%            hold on
%        end
%        pause(0.5)
%     end
           