function [trajectory_block,trajectory_no] = trajectory_divide(trajectory,down,up)
%���켣��ΪԽ�߹켣�ͷ�Խ�߹켣
%fe��ʾһ���켣��Ĳ�����Ŀ
% trajectory = E;
trajectory_block = [];
trajectory_no = [];
%����ÿ���켣
index = 1;%�켣���
ID_block = 1;
ID_no = 1;
while index <= trajectory(size(trajectory,1),1)
    trajectory_current = trajectory((trajectory(:,1)==index),:);%�ҵ���ǰ���ݵ�Ԥ��ֵ
    index_block = 0;%Խ�ߵ����
    for j = 1:size(trajectory_current,1)
       if (trajectory_current(j,5)>up)||(trajectory_current(j,5)<down) %����õ�Խ�� 22,26
           index_block = index_block + 1;
      end
    end
    if index_block>0 %��index>0,˵���������и�һ����Խ���ˣ���ŵ����ż�
        trajectory_current(:,1) = ID_block;
        trajectory_block = [trajectory_block;trajectory_current];%���ż�
        ID_block = ID_block + 1;
    else
        trajectory_current(:,1) = ID_no;
        trajectory_no = [trajectory_no;trajectory_current];
        ID_no = ID_no + 1;
    end
    index = index + 1;
end
end

