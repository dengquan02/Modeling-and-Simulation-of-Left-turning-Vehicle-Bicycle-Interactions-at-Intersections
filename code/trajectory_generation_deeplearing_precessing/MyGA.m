% V = extract_one(1,10)/3.6*0.12;%���ݵ�ǰ�ļ����һ�������ľ��룬������ɢ��뾶  extract_one(1,10)
% A = zeros(80,40);b = zeros(80,1);
% for i = 1:40%�����ͽǶȶ�Ҫ����0
%    A(i,i) = -1; 
%    b(i,1) = 0;
% end
% for i = 1:20%�Ƕ�ҪС��2pi
%    A(i+40,i) = 1; 
%    b(i+40,1) = 2*pi;
% end
% for i = 1:20%������ҪС��0.24
%    A(i+60,i+20) = 1; 
%    b(i+60,1) = 1;
% end
%�鿴Ԥ�������
% input_data = E_trajectory;
% % input_data = sample_test(:,2:size(sample_test,2));
% input_data(find(abs(input_data(:,6))>50),:)=[];
% a_limit = (input_data(find(input_data(:,14)==2),6));%10���ٶȣ�11�Ǽ��ٶ�    
% % a_limit = sort(abs(a_limit));
% % % % % % a_limit = prctile(a_limit ,85);%��ٷ�λ��
% % % % a_limit(size(a_limit,1)-2:size(a_limit,1),:) = [];
% % median(a_limit)%��λ��median
% mean(abs(a_limit))%ƽ��ֵ
% hist(a_limit)
% % % mode(a_limit)
% % hist(a_limit);
global extract_one
if extract_one(1,14)==2%����2����Ϊ�綯��
    a_limit = 0.2703;%0.2703;%���ֵ��3.8   %0.259����õ���0.2703��Ч���õ�ʱ����ƽ��ֵ0.4��ȡ����ƽ��ֵ�͵�ǰֵ�����ֵ  ��Ŀǰ�ڳ��԰ٷ�λ��0.74����λ��0.31������0.03
elseif extract_one(1,14)==1%����1����Ϊ���г�
    a_limit = 0.05934;%���ֵ��1.58   0.259����õ���0.05934Ч���õ�ʱ����ƽ��ֵ0.26��ȡ����ƽ��ֵ�͵�ǰֵ�����ֵ��Ŀǰ�ڳ��԰ٷ�λ��0.5����λ��0.2������0.01
end
a_limit = max(a_limit,extract_one(1,11)+0.01);%��ǰ���ٶȺ��Ҹ���Լ����ȡ��ֵ
%���½�
% a_limit = prctile(sort(abs(a_limit)),85);%��ٷ�λ��
%% ��ʼ�Ż�
% Nu_point��ʾ���ڼ���������Ĺ켣����
% perception_time = 25;
generating_lengh = 9;

Nu_point = (perception_time-1)/(generating_lengh-1);%�����㣬�յ���м��

lb = zeros(Nu_point*2,1);
ub = zeros(Nu_point*2,1);
ub(1:Nu_point,1) = 2*pi;
ub(Nu_point+1:Nu_point*2,1) = a_limit;%a_limit;%���ٶȵ��Ͻ�  ��λm/s  0.2�Ǽ��ٶȵ�ƽ��ֵ������������

%�Ż�����  
options = gaoptimset('PopInitRange',[pi,0.15;pi,0.15],'PopulationSize',50, 'Generations', 200,'CrossoverFraction',0.8,'MigrationFraction',0.04 ); % �Ŵ��㷨�������   'StallGenLimit',20  

%�����Ŵ��㷨���м���
[OPT,FVAL,EXITFLAG,OUTPUT] =ga(@Excur_predict_1,(Nu_point*2),[],[],[],[],lb,ub,@nonlcon,options);%�����Ŵ��㷨���в����궨  