
%�Ż�����
options = gaoptimset('PopInitRange',[pi,1.5;pi,1.5],'PopulationSize',100, 'Generations', 800,'CrossoverFraction',0.8,'MigrationFraction',0.02 ); % �Ŵ��㷨�������   'StallGenLimit',20  
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
a_limit = (E_trajectory(find(E_trajectory(:,14)==1),9));
a_limit = sort(a_limit);
global extract_one
if extract_one(1,14)==2%����2����Ϊ�綯��
    a_limit = 2;%��ʵ�綯��Ϊ-3~3.3m/s^2
elseif extract_one(1,14)==1%����1����Ϊ���г�
    a_limit = 1;%��ʵ���г���Ϊ-2~1.3m/s^2
end
%���½�
lb = zeros(20,1);
ub = zeros(20,1);
lb(1:20,1) = -a_limit;
ub(1:20,1) = a_limit;%���ٶȵ��Ͻ�  ��λm/s
%�����Ŵ��㷨���м���
[OPT,FVAL,EXITFLAG,OUTPUT] =ga(@Excur_predict_3,20,[],[],[],[],lb,ub,@nonlcon_3,options);%�����Ŵ��㷨���в����궨  