%% ���ű���Ŀ���Ƕ����ݽ���Ԥ���������ѵ����������֤�����Լ���������
tic;
%% ��ȡ����
type = 1;
%�������ͣ�1�����г���2�ǵ綯����3�ǻ�������4����������
filename = 'M:\New_try\4-����·����·����-ת����켣���ݣ������ࣩ��ƽ�������ȱʧֵ��(�Ѵ���).xlsx';
%��ÿ���켣���Ӧ�Ļ������ͷǻ���������ŵ�ͬһ����,14��
[E1]=xlsread(filename,type);%���г�
%% �������
%�켣��� ʱ�� x y
Fs = 25;  %������
% filename = ['�켣',num2str(1),'�˲��ԱȽ��.fig'];
[a,b] = size(E1);
x = zeros(a,1);
y = zeros(a,1);
Vx = zeros(a,1);
Vy = zeros(a,1);
V = zeros(a,1);
t = E1(:,1);
Ax = zeros(a,1);
Ay = zeros(a,1);
A = E1(:,9);
Wc=2*3/Fs;  %��ֹƵ�� 3Hz
% if type == 3
%     Wc = 2*1/Fs;
% end

%% �ٹ켣λ��ƽ����3��ButterWorth�˲���
for i = 1:E1(end,12)
    ID = find(E1(:,12)==i);
    tempx = [E1(ID,2)];
    tempy = [E1(ID,3)];
    
    % �����װ�����˹��ͨ�˲�
    [b0,a0]=butter(3,Wc);
    x(ID) = filtfilt(b0,a0,tempx);  %�ֱ���xy���˲�
    y(ID) = filtfilt(b0,a0,tempy);
    % �����¼����˶�ѧ������
    %�����ٶ�
    tempVx = [E1(ID,4)];
    tempVy = [E1(ID,5)];
    tempVx(1:end-1) = (x(ID(2:end))-x(ID(1:end-1)))./0.04;
    tempVy(1:end-1) = (y(ID(2:end))-y(ID(1:end-1)))./0.04;
    Vx(ID) = tempVx;
    Vy(ID) = tempVy;
    %������ٶ�
    tempAx = [E1(ID,6)];
    tempAy = [E1(ID,7)];
    tempAx(1:end-1) = (Vx(ID(2:end))-Vx(ID(1:end-1)))./0.04;
    tempAy(1:end-1) = (Vy(ID(2:end))-Vy(ID(1:end-1)))./0.04;
    Ax(ID) = tempAx;
    Ay(ID) = tempAy;
    V(ID) = (Vx(ID).^2+Vy(ID).^2).^0.5.*3.6;
    A(ID(1:end-1)) = (V(ID(2:end))-V(ID(1:end-1)))./0.04;
end
%�������һ���켣��ͬ�׶ε���������ڶԱ������˲�Ч��
x1 = [tempx];
y1 = [tempy];
x2 = [x(ID)];
y2 = [y(ID)];

%�����Ƿ����ã���ô����

%% ��ɸѡ�쳣ֵ���������ٶ�>25/40/60km/h����ͨ���г�/��ͨ�綯��/�������֣��Ĺ켣�㣩��

for i = 1:E1(end,12)
    ID = find(E1(:,12)==i);
    outliers = [];
    if type == 1 || 2 || 4
        if type == 1
            Vlimit = 25;
        elseif type == 4
            Vlimit = 40;
        else
            Vlimit = 60;
        end
        for a = 1:length(ID)
            if(V(ID(a)) >= Vlimit & a >= 11 & a <= length(ID)-10)
                outliers = [outliers,ID(a)];
            end
        end
    else %�����������ٶ�>10m/s^2�����������Ĺ켣�㣩
        Alimit = 10;
        for a = 1:length(ID)
            if(abs(A(ID(a))) >= Alimit & a >= 11 & a <= length(ID)-10)
                outliers = [outliers,ID(a)];
            end
        end
    end
    %     outliers = ID(find(V(ID) >= Vlimit));%�ҳ�����ֵ
    %     outliers = [outliers(find(outliers >= (ID(1)+10) & outliers <= (ID(end)-10)))];%ȥ��ǰ����ʮ�����ֵ
    if isempty(outliers)%Ϊ����������ǰ�켣
        continue;
    end
    for k = 1:length(outliers)
        j = outliers(k);
        t0 = linspace(j-10,j+10,21);
        %���²�ֵ�켣�㣨����������������ֵ������
        tempx = [x(j-10),x(j+10)];
        tempy = [y(j-10),y(j+10)];
        x(j-10:j+10) = spline([j-10,j+10],tempx,t0);
        y(j-10:j+10) = spline([j-10,j+10],tempy,t0);
        %         traj(:,6) = yi;
        %         x(outliers) = spline(normal,x(normal),outliers);
        %         y(outliers) = spline(normal,y(normal),outliers);
        %     normal = setxor(ID,outliers);
        %�����¼����ٶȺͼ��ٶ�
%         for jj = j-9:j+9
%             Vx(jj) = (x(jj+1)-x(jj-1))/(t(jj+1)-t(jj-1));
%             Vy(jj) = (y(jj+1)-y(jj-1))/(t(jj+1)-t(jj-1));
%             V(jj) = (Vx(jj).^2+Vy(jj).^2).^0.5.*3.6;
%             Ax(jj) = (x(jj+1)-2*x(jj)+x(jj-1))/(t(jj+1)-t(jj)).^2;
%             Ay(jj) = (y(jj+1)-2*y(jj)+y(jj-1))/(t(jj+1)-t(jj)).^2;
%             A(jj) = (V(jj)-V(jj-1))./0.04;
%         end
    end
    %�����¼����ٶȺͼ��ٶ�
    Vx(ID(1:end-1)) = (x(ID(2:end))-x(ID(1:end-1)))./0.04;
    Vy(ID(1:end-1)) = (y(ID(2:end))-y(ID(1:end-1)))./0.04;      
    %������ٶ�
    Ax(ID(1:end-1)) = (Vx(ID(2:end))-Vx(ID(1:end-1)))./0.04;
    Ay(ID(1:end-1)) = (Vy(ID(2:end))-Vy(ID(1:end-1)))./0.04;
    V(ID) = (Vx(ID).^2+Vy(ID).^2).^0.5.*3.6;
    A(ID(1:end-1)) = (V(ID(2:end))-V(ID(1:end-1)))./0.04;
end

x3 = [x(ID)];
y3 = [y(ID)];
x4 = [x(outliers)];
y4 = [y(outliers)];
Vx1 = [Vx(ID)];
Vy1 = [Vy(ID)];

%% ��ƽ���ٶȣ�1��ButterWorth�˲�����
for i = 1:E1(end,12)
    ID = find(E1(:,12)==i);
    % �����װ�����˹��ͨ�˲�
    [b1,a1]=butter(1,Wc);
    Vx(ID)=filtfilt(b1,a1,Vx(ID));  %�ֱ���VxVy���˲�
    Vy(ID)=filtfilt(b1,a1,Vy(ID));
    %�����¼���λ�úͼ��ٶ�
    for j = 2:length(ID)
        x(ID(j)) = x(ID(j-1)) + Vx(ID(j-1))*0.04 + 0.5*Ax(ID(j-1))*0.04^2;
        y(ID(j)) = y(ID(j-1)) + Vy(ID(j-1))*0.04 + 0.5*Ay(ID(j-1))*0.04^2;
        Ax(ID(j-1)) = (Vx(ID(j)) - Vx(ID(j-1)))/0.04;
        Ay(ID(j-1)) = (Vy(ID(j)) - Vy(ID(j-1)))/0.04;
    end
    V(ID) = (Vx(ID).^2+Vy(ID).^2).^0.5.*3.6;
    A(ID(1:end-1)) = (V(ID(2:end))-V(ID(1:end-1)))./0.04;
end
x5 = [x(ID)];
y5 = [y(ID)];
Vx2 = [Vx(ID)];
Vy2 = [Vy(ID)];
%�����ͬ�׶εĹ켣�������
plot(x1,y1,x2,y2,x3,y3,x5,y5,x4,y4);
legend('ԭʼ�켣','1ƽ����켣','3����������ֵ�켣','5�ٶ�ƽ�������ս��','�쳣��');
% plot(linspace(1,length(ID),length(ID)),Vx1,linspace(1,length(ID),length(ID)),Vx2);
% legend('ƽ��ǰ','ƽ����');
%% ��������
title = {'GlobalTime','X[m]','Y[m]','Vx[m/s]','Vy[m/s]','Ax[m/s2]','Ay[m/s2]','Speed[km/h]','Acceleration[m/s2]','Space[m]','Curvature[1/m]','ID','ID_in','ID_straight','type'};
data = [E1(:,1),x,y,Vx,Vy,Ax,Ay,V,A,E1(:,10:15)];
%�����ʱ���Ϊ0.12s
fdata = [];
%�������һ��������޷����˶�ѧ��ʽ�ó���ɾ�����һ����
for i = 1:data(end,12)
    ID = find(data(:,12)==i);
    data(ID(end),:) = [];
    %�����ʱ���Ϊ0.12s
    ID = [ID(1:end-1)];
    j = 1;
    while j <= (length(ID)-2)
        fdata = [fdata;data(ID(j),:)];
        j = j + 3;
    end
    %���±��
    ID = find(fdata(:,12)==i);
    fdata(ID,13) = linspace(1,length(ID),length(ID));
end
if type == 1
    sheetname = '���г�';
elseif type == 2
    sheetname = '�綯��';
elseif type == 3
    sheetname = '������';
else
    sheetname = '��������';
end
xlswrite(filename,[title;num2cell(fdata)],sheetname);



