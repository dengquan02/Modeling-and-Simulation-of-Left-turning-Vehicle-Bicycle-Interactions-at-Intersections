function [Risk] = Risk_Heat_map(Risk)
%�����ʼ��
X=Risk(:,1);
Y=Risk(:,2);
Xmin=min(X);Xmax=max(X);
Ymin=min(Y);Ymax=max(Y);
%�ָ������С
Nx=100;
Ny=100;

%�ָ�ı� ,Ҳ��������·������
Xedge=linspace(Xmin,Xmax,Nx);
Yedge=linspace(Ymin,Ymax,Ny);

%ͳ��ÿ������ĵ������N��xy������ת�õģ�
[N,~,~,binX,binY] = histcounts2(X,Y,[-inf,Xedge(2:end-1),inf],[-inf,Yedge(2:end-1),inf]);

XedgeM=movsum(Xedge,2)/2;
YedgeM=movsum(Yedge,2)/2;
%������ͼ����
[Xedgemesh,Yedgemesh]=meshgrid(XedgeM(2:end),YedgeM(2:end));

%����pcolorͼ
figure(1)
pcolor(Xedgemesh,Yedgemesh,N');shading interp
%����pcolorͼ����ɫ����ɢ��ͼ��ɫ
ind = sub2ind(size(N),binX,binY);
col = N(ind);

% figure(2)
% plot(X,Y,'x')
%����ɢ��ͼ
% figure(3)
% scatter(X,Y,20,col,'filled');

%�����ܶȸ߳�ͼ
figure(4)
[XX,YY,ZZ]=griddata(Xedgemesh,Yedgemesh,N',Xedge',Yedge,'V4');
surf(XX,YY,ZZ);%����������
shading interp
end

