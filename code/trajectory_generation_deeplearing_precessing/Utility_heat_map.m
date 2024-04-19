function [output] = Utility_heat_map(optimal_solution_order)
%����optimal_solution_order��Ч�ú���������ͼ
%% �Ƚ��б任����Լ��ת����Ч��ֵ��
input_order = optimal_solution_order;

input_order(:,3) = -input_order(:,3);%ԭ��������Сֵ���������ȡ����
input_order(:,3) = input_order(:,3) + (-input_order(:,4));
input_order = sortrows(input_order,-3);
input_order(:,3) = sortrows([1:size(input_order,1)]',-1) ;
input_order(:,3) = (input_order(:,3)-min(input_order(:,3)))/(max(input_order(:,3))-min(input_order(:,3)));

%% �ɷ��� ������ͼ
% %�����ʼ��
% X=input_order(:,1);
% Y=input_order(:,2);
% Xmin=min(X);Xmax=max(X);
% Ymin=min(Y);Ymax=max(Y);
% %�ָ������С
% Nx=size(unique(input_order(:,1)),1);
% Ny=size(unique(input_order(:,2)),1);
% 
% %�ָ�ı� ,Ҳ��������·������
% Xedge=linspace(Xmin,Xmax,100);  %Xedge=linspace(Xmin,Xmax,Nx);
% Yedge=linspace(Ymin,Ymax,100);
% 
% % N = input_order(:,3)';
% %ͳ��ÿ������ĵ������N��xy������ת�õģ�
% [N,~,~,binX,binY] = histcounts2(X,Y,[-inf,Xedge(2:end-1),inf],[-inf,Yedge(2:end-1),inf]);
% 
% XedgeM=movsum(Xedge,2)/2;
% YedgeM=movsum(Yedge,2)/2;
% %������ͼ����
% [Xedgemesh,Yedgemesh]=meshgrid(XedgeM(2:end),YedgeM(2:end)); %��������
% 
% %����pcolorͼ
% figure(2)
% pcolor(Xedgemesh,Yedgemesh,N');shading interp
% %����pcolorͼ����ɫ����ɢ��ͼ��ɫ
% ind = sub2ind(size(N),binX,binY);
% col = N(ind);
% 
% % figure(2)
% % plot(X,Y,'x')
% %����ɢ��ͼ
% % figure(3)
% % scatter(X,Y,20,col,'filled');
% 
% % ����N
% N=input_order(:,3);
% 
% %�����ܶȸ߳�ͼ
% figure(4)
% [XX,YY,ZZ]=griddata(Xedgemesh,Yedgemesh,N',Xedge',Yedge,'V4');%����zֵ
% surf(XX,YY,ZZ);%����������
% shading interp
% % 
% % 
output=input_order;

%% �·���
As = input_order(:,3);%Ч��ֵ
X = input_order(:,1);
Y= input_order(:,2);
% Xedge=linspace(min(X),max(X),100);
% Yedge=linspace(min(Y),max(Y),100);
[x,y] = meshgrid(min(X):0.2:max(X),min(Y):0.2:max(Y));%2e4=20000
z = griddata(X,Y,As,x,y,'v4');%��ֵ
% c = contour(x.y,z);
surf(x,y,z);%����������
% view([0,0,1])

%% �����������ͶӰ x������
x_0 = max(max(x))+2;%����x��ȫ��Լ�����ֵ
x_0 = ones(size(x,1),size(x,2))*x_0;%����x��ȫ����0
for i = 1:size(z,1)
    z_x(i,:)=max(z(i,:));
    if i==1||i==size(z,1)%������Ϊ��ͼ�ÿ������߽ӵ�����
       z_x(i,:)=0; 
    end
end

hold on
plot3(x_0,y,z_x,'black');%����������

%% �����������ͶӰ y������
y_0 = max(max(y))+2;%����x��ȫ��Լ�����ֵ
y_0 = ones(size(y,1),size(y,2))*y_0;%����x��ȫ����0
for i = 1:size(z,2)
    z_y(:,i)=max(z(:,i));
        if i==1||i==size(z,2)%������Ϊ��ͼ�ÿ������߽ӵ�����
             z_y(:,i)=0; 
        end
end

hold on
plot3(x,y_0,z_y,'black');%����������


end