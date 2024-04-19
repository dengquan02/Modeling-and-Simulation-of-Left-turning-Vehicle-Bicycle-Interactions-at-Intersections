function [output_E] = data_char(E_straight,NVinterract,Vinterract,Num_No,Num_V,index_zeros)
%E_straight��Ԥ�����壬�������������ǽ������壬������ѡ������������
disp('start data_handle');
disp('start E��');
%����E_straight
E_straight = [E_straight(:,14) E_straight(:,12) E_straight ];
E_straight(:,14) = [];
E_straight(:,15) = [];
%����NVinterract
NVinterract = [NVinterract(:,13) NVinterract(:,12) NVinterract ];
NVinterract(:,14:15) = [];
%����Vinterract
Vinterract = [Vinterract(:,13) Vinterract(:,12) Vinterract ];
Vinterract(:,14:15) = [];

%%%for NV
Nu_NVinterract = zeros(size(E_straight,1),1);%number of interacting NV
all_NVinterract = zeros(size(E_straight,1),Num_No*11);%Selected of interactive NV
chosed_NVinterract = zeros(size(E_straight,1),Num_No*11);%All of interactive NV

for i=1:size(E_straight,1)%��ÿ��ֱ�й켣�㶼Ū������
    nu=0;
    except_me = NVinterract((NVinterract(:,1)~=i),:);%find all of orthers except me
    all_NVinterract = except_me((except_me(:,3)==E_straight(i,3)),:);%find interactive obejct at the same time
    
    for i1=1:size(NVinterract,1)%��һ���켣������н����ǻ��������������E2��
        if NVinterract(i1,1)==E_straight(i,1)%�ж��Ƿ������ͬʱ��Ĺ켣�㣨����ԭ�켣�㣩
           nu=nu+1;%�����������
           all_NVinterract(i,((nu*11)-10):((nu*11)-1))=NVinterract(i1,2:11);%����ǻ������ĵ�2λ����11λ
           all_NVinterract(i,(nu*11))=NVinterract(i1,14);%����ǻ�����������(��ʮһλ)
        end
    end
    Nu_NVinterract(i,1)=nu-1;%number of interract NV(-1����Ϊ������һ�����Լ�)   
    d=zeros(2,max(nu,Num_No));%��Ž�������֮��ľ��룬ѡȡ������̵�Num������Ϊ0��
    for i2=1:max(nu,Num_No)
        d(1,i2)=i2;%��һ�з����ǵı��
        if  all_NVinterract(i,(i2*3)-2)~=0%����������Ϊ0�Ļ�
            d(2,i2)=((NVinterract(i1,2)- all_NVinterract(i,(i2*3)-2))^2+(NVinterract(i1,3)- all_NVinterract(i,(i2*3)-1))^2)^0.5;%�ڶ��з����ǵľ���
       end
    end
    d(:,(find(d(2,:)==0)))=[];%ɾ������Ϊ0����
    d=(sortrows(d',2))';%�Խ�����������������У��ҵ�ǰNum������
    for i3=1:min(Num_No,size(d,2))
        chosed_NVinterract(i,(i3*11-10):(i3*11-1))=all_NVinterract(i,((d(1,i3)*11)-10):(d(1,i3)*11)-1);
        chosed_NVinterract(i,i3*11)=all_NVinterract(i,(d(1,i3)*11));
    end
    disp(['E�������',num2str(i/size(E_straight,1)*100),'%']);
end

%%%%%%%for V
Nu_Vinterract=zeros(size(E_straight,1),1);%ÿ���켣�㣨ͬһʱ�̣��м�������������
all_Vinterract=zeros(size(E_straight,1),Num_V*11);%�������ÿ���ǻ�������ͬһʱ��ȫ�������������ڵģ�
chosed_Vinterract=zeros(size(E_straight,1),Num_V*11);%�������ÿ���ǻ������Ľ���������������
for i=1:size(E_straight,1)%��ÿ���켣�㶼Ū������
    nu_V=0;
    for i1=1:size(Vinterract,1)%��һ���켣�������
        if Vinterract(i1,1)==E_straight(i,1)%�ж��Ƿ������ͬʱ��Ĺ켣��
           nu_V=nu_V+1;%�����������
           all_Vinterract(i,((nu_V*11)-10):((nu_V*11)-1))=Vinterract(i1,2:11);%�����������xֵ(��һλ����ʮλ)
           all_Vinterract(i,(nu_V*11))=Vinterract(i1,14);%���������������(��ʮһλ)
        end
    end
    Nu_Vinterract(i,1)=nu_V-1;   
    d2=zeros(2,max(nu_V,Num_V));%��Ž�������֮��ľ��룬ѡȡ������̵�Num������Ϊ0��
    for i2=1:max(nu_V,Num_V)
        d2(1,i2)=i2;%��һ�з����ǵı��
        if  all_Vinterract(i,(i2*3)-2)~=0%����������Ϊ0�Ļ�
            d2(2,i2)=((Vinterract(i1,2)- all_Vinterract(i,(i2*3)-2))^2+(Vinterract(i1,3)- all_Vinterract(i,(i2*3)-1))^2)^0.5;%�ڶ��з����ǵľ���
       end
    end
    d2(:,(find(d2(2,:)==0)))=[];%ɾ������Ϊ0����
    d2=(sortrows(d2',2))';%�Խ�����������������У��ҵ�ǰNum������
    for i3=1:min(Num_V,size(d2,2))
        chosed_Vinterract(i,(i3*11-10):(i3*11-1))=all_Vinterract(i,((d2(1,i3)*11)-10):(d2(1,i3)*11)-1);
        chosed_Vinterract(i,i3*11)=all_Vinterract(i,(d2(1,i3)*11));
    end
    disp(['E�������',num2str(i/size(E_straight,1)*100),'%']);
end

%%%%%%%%%%���E������%%%%%%%%%%%
E=E_straight;
E(:,1)=E_straight(:,14);%��1�зŹ켣���ID
E(:,2)=E_straight(:,12);%��2�зŹ켣�ڲ��켣���ID_in
E(:,3:5)=E_straight(:,1:3);%ʱ���Ԥ�������ʱ�������
E(:,6:13)=E_straight(:,4:11);%Ԥ�������������Ϣ
E(:,14)=E_straight(:,13);%Ԥ�����������
E(:,15:(14+Num_No*11))=chosed_NVinterract(:,1:(Num_No*11));%�����ǻ�����
E(:,(15+Num_No*11):((14+Num_No*11)+Num_V*11))=chosed_Vinterract(:,1:Num_V*11);%����������



%���ֵ
output_E =E;

% %ȥ����������Ϊ0�ĵ�
% output_E = [];
% ID_E = 1;
% for i = 1:E(size(E,1),1)
%     current_output_E = E(find(E(:,1)==i),:);
%     current_output_E(:,1) = ID_E;
%     zero_index_N = sum(sum(current_output_E==0));
%     if zero_index_N<=index_zeros
%         output_E = [output_E;current_output_E];
%         ID_E = ID_E+1;
%     end
% end
% output_N = [];
% ID_N = 1;
% for i = 1:N(size(N,1),1)
%     current_output_N = N(find(N(:,1)==i),:);
%     current_output_N(:,1) = ID_N;
%     zero_index_N = sum(sum(current_output_N==0));
%     if zero_index_N<=index_zeros
%         output_N = [output_N;current_output_N];
%         ID_N = ID_N+1;
%     end
% end
end

