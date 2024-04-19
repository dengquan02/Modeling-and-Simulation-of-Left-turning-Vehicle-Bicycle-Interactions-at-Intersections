%% ���ű���Ŀ���Ƕ����ݽ���Ԥ���������ѵ����������֤�����Լ���������
tic;
%% ��ȡ���ݣ��������
%��ÿ���켣���Ӧ�Ļ������ͷǻ���������ŵ�ͬһ����,14��
[E1]=xlsread('M:\New_try\4-����·����·����-ת����켣���ݣ������ࣩ�������ȱʧֵ��(1).xlsx',1);%������ֱ�зǻ�����
%�켣��� ʱ�� x y
E1= [E1(:,2) E1(:,8:10)];
Fs = 25;  %������

for i = 1:20 
%ѡ�����Ϊi�Ĺ켣
    ID = find(E1(:,1)==i);
    x = [E1(ID,3)];
    y = [E1(ID,4)];

    %% ��������˹��ͨ�˲�

    h = figure(1);
    filename = ['�켣',num2str(i),'�˲��ԱȽ��.fig']
    Wc=2*3/Fs;  %��ֹƵ�� 3Hz
    %����Ϊ 3 ʱ���˲����
    [b0,a0]=butter(3,Wc);  
    Signal_Filter_x0=filtfilt(b0,a0,x);  %�ֱ���xy���˲�
    Signal_Filter_y0=filtfilt(b0,a0,y);
    %����Ϊ 4 ʱ���˲����
    [b1,a1]=butter(4,Wc);  
    Signal_Filter_x1=filtfilt(b1,a1,x);  %�ֱ���xy���˲�
    Signal_Filter_y1=filtfilt(b1,a1,y);
    %����Ϊ 5 ʱ���˲����
    [b2,a2]=butter(5,Wc);  
    Signal_Filter_x2=filtfilt(b2,a2,x);  %�ֱ���xy���˲�
    Signal_Filter_y2=filtfilt(b2,a2,y);

    plot(x,y,Signal_Filter_x0,Signal_Filter_y0,Signal_Filter_x1,Signal_Filter_y1,Signal_Filter_x2,Signal_Filter_y2);  %ԭʼ�켣 �˲�����Ϊ3,4,5ʱ�Ĺ켣
    legend('ԭʼ�켣','n=3ʱ�켣','n=4ʱ�켣','n=5ʱ�켣');
    title('Butterworth��ͨ�˲�ǰ��켣�Ա�');
    saveas(h,filename);
end