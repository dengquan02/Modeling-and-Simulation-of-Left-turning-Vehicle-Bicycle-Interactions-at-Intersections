function [order] = myplot(E,N,order)
%%%��ͼ
plot_E = E(find(E(:,2)==order),:);
plot_N = N(find(N(:,2)==order),:);
scatter(plot_E(:,3),plot_E(:,4),'*','b');
hold on
scatter(plot_N(:,3),plot_N(:,4),'*','r');
% %����������������ֲ����
% figure(1)
% X = plot_E(:,3);%��ȡ���
% [M,M1] = hist(X );%��Ƶ��  [M,M1] = hist(X , (0:0.5:12));%��Ƶ��
% bar(M1,M);
% figure(2)
% Y = plot_E(:,4);%��ȡ���
% [M,M1] = hist(Y );%��Ƶ��  [M,M1] = hist(X , (0:0.5:12));%��Ƶ��
% bar(M1,M);
end

