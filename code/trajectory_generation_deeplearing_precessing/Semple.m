function [output_E,output_N] = Semple(E1,N1,order)
%Ū�ɷ������������
E = zeros(size(E1,1),4);%�зֱ���ID,ID_in,x,y
E(:,1) = E1(:,13);%����ID
E(:,2) = E1(:,12);%����ID_in
E(:,3:4) = E1(:,2:3);%����ID
index_E = E(size(E,1),1);
output_E = [];
for i = 1:index_E
    current_E = E(find(E(:,1)==i),:);
    x_basic = current_E(order,3);
    y_basic = current_E(order,4);
    for j = 1:size(current_E,1)
        current_E(j,3) = current_E(j,3)-x_basic;
        current_E(j,4) = current_E(j,4)-y_basic;
    end
    output_E = [output_E;current_E];
end


%%%����N
%Ū�ɷ������������
N = zeros(size(N1,1),4);%�зֱ���ID,ID_in,x,y
N(:,1) = N1(:,13);%����ID
N(:,2) = N1(:,12);%����ID_in
N(:,3:4) = N1(:,2:3);%����ID
index_N = N(size(N,1),1);
output_N = [];
for i = 1:index_N
    current_N = N(find(N(:,1)==i),:);
    x_basic = current_N(order,3);
    y_basic = current_N(order,4);
    for j = 1:size(current_N,1)
        current_N(j,3) = current_N(j,3)-x_basic;
        current_N(j,4) = current_N(j,4)-y_basic;
    end
    output_N = [output_N;current_N];
end
end

