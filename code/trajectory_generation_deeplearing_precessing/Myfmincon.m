%����fmincon���
% options = gaoptimset('PopulationSize',100, 'Generations', 500,'CrossoverFraction',0.8,'MigrationFraction',0.02); % �Ŵ��㷨�������
x0 = zeros(1,40);
lb = zeros(40,1);
ub = zeros(40,1);
ub(1:20,1) = 2*pi;
ub(21:40,1) = 0.12;
A = zeros(80,40);b = zeros(80,1);
for i = 1:40%�����ͽǶȶ�Ҫ����0
   A(i,i) = -1; 
   b(i,1) = 0;
end
for i = 1:20%�Ƕ�ҪС��2pi
   A(i+40,i) = 1; 
   b(i+40,1) = 2*pi;
end
for i = 1:20%������ҪС��0.24
   A(i+60,i+20) = 1; 
   b(i+60,1) = 0.12;
end
for i =21:40
   A(80,i) = 1; 
end
V = extract_one(1,10)/3.6*0.12;%���ݵ�ǰ�ļ����һ�������ľ��룬������ɢ��뾶  extract_one(1,10)
[OPT,fval]=fmincon('Excur_predict',x0,A,b,[],[],lb,ub,'nonlcon');