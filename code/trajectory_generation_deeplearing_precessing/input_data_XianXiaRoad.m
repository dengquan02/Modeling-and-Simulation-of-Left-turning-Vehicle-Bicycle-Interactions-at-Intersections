function [E_trajectory] = input_data_XianXiaRoad(E1,E1V,W1V,Num_No,Num_V)
%%% ��ȡ����      %��ÿ���켣���Ӧ�Ļ������ͷǻ���������ŵ�ͬһ����,14��
tic
E1(:,14) = [];
E1V(:,14) = [];
W1V(:,14) = [];
E1= [E1(:,1:11) E1(:,13) E1(:,12) E1(:,14)];
E1V= [E1V(:,1:11) E1V(:,13) E1V(:,12) E1V(:,14)];
W1V= [W1V(:,1:11) W1V(:,13) W1V(:,12) W1V(:,14)];

%%% Ťתһ�£�����ľͲ��ø���
[E1] = change_rad(E1,90);
[E1V] = change_rad(E1V,90);
[W1V] = change_rad(W1V,90);

%%% �����Ҫ����
% Num_No=6;%�����ķǻ���������ĸ�����Ŀǰ�ǰ��վ�����̵ļ���,�ο�����6����
% Num_V=6;%�����Ļ���������

% csvwrite('intrusion_cood_EXXRoad.csv',intrusion_cood_EXXRoad)


%%%ȥ����ͬ����
[E1] = same_out(E1);
[E1V] = same_out(E1V);
[W1V] = same_out(W1V);

%%%�ҵ�ֱ�зǻ�����
[E_straight] = [E1(:,1:12) E1(:,14) E1(:,13)];%find_straight(E1,35,60,15,40,-10,10,20,40);

%%%%%%%��E��N�����������������%%%%%%%
[NVinterract,Vinterract] = DATA_merge (E1,[],E1V,W1V,[]);%%DATA merge

[E_trajectory] = data_handle(E_straight,NVinterract,Vinterract,Num_No,Num_V,1);%��ԭʼ���ݴ����Ū���������� ,���һ�����ֱ�ʾ�켣��0�ĸ������ܳ���������

toc
end