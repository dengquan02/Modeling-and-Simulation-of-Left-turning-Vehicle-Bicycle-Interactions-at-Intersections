function [OPT,EXITFLAG,possible_points_allData,const_output,ID_best_inOPT,ID_best_inDis] = Exhaustion_Method(perception_time,Possible_points,OPT_th,mmax,mmin)
%ͨ��Ԥ������͵Ȳ鿴�ٶȺͼ��ٶ�Լ��
% for k44 = 0.5
% Possible_points = possible_points;  %������������ʱ��Ҫ���и��д���
Possible_points(find((Possible_points(:,1)==0)&(Possible_points(:,2)==0)),:) = [];%ɾ�����յ�һ�µĵ�
% OPT_th= 3;
% input_data = E_trajectory;
% % input_data = data_test;
% % a_limit = (input_data(find(input_data(:,14)==1),10));%10���ٶȣ�11�Ǽ��ٶ�    1�����г�  2�ǵ綯��
% a_limit = sort(abs(input_data(:,9)));
% % % % % % % a_limit = prctile(a_limit ,85);%��ٷ�λ��
% a_limit(size(a_limit,1)-500:size(a_limit,1),:) = [];
% % % median(a_limit)%��λ��median
% mean(abs(a_limit))%ƽ��ֵ
% hist(a_limit)
% % % mode(a_limit)
% % hist(a_limit);
wigh_path = 0.5;
%% ��ga���
% % Nu_point��ʾ���ڼ���������Ĺ켣����
% % perception_time = 25;
% generating_lengh = 9;
% 
% Nu_point = (perception_time-1)/(generating_lengh-1);%�����㣬�յ���м��
% 
% lb = zeros(Nu_point*2,1);
% ub = zeros(Nu_point*2,1);
% ub(1:Nu_point,1) = 2*pi;
% ub(Nu_point+1:Nu_point*2,1) = a_limit;%a_limit;%���ٶȵ��Ͻ�  ��λm/s  0.2�Ǽ��ٶȵ�ƽ��ֵ������������
% 
% %�Ż�����  
% options = gaoptimset('PopInitRange',[pi,0.15;pi,0.15],'PopulationSize',50, 'Generations', 200,'CrossoverFraction',0.8,'MigrationFraction',0.04 ); % �Ŵ��㷨�������   'StallGenLimit',20  
% 
% %�����Ŵ��㷨���м���
% [OPT,FVAL,EXITFLAG,OUTPUT] =ga(@Excur_predict_1,(Nu_point*2),[],[],[],[],lb,ub,@nonlcon,options);%�����Ŵ��㷨���в����궨  

%% ����ٷ����
possible_points_in = [];%��ʼ������
% optimal_solution = [];

%%  ��Ŀ��ֵ�ĵط�������ʵ�켣�����ֵ�����滻����������������һʧ��Ԥ������Ƕ��٣�  ��ʽ����ʱ��һ����X����
global E_trajectory;
global extract_one
fit_dis = [];
index_Truth = find((E_trajectory(:,1)==extract_one(1,1))&(E_trajectory(:,2)==extract_one(1,2)));
Truth_trj = E_trajectory(index_Truth:index_Truth+perception_time-1,4:5);%��ʵ�켣
const_output_all = [];%��Ÿ��Ե�Լ�� -1��ʾ���㣬1��ʾ������   [�ٶ�  ���� ���� ���ٶ�  ��һ���������]

% ���÷���ƫ��ϵ�� ����������Ҫ����
if extract_one(1,14) == 1%��̬��������ƫ��ϵ��  ���г�  ���յķݶ�
    k4 = 0.2;%PPT�ϵĽ�����õ���0.2
elseif extract_one(1,14) == 2  %�綯��
    k4 = 0.2;%PPT�ϵĽ�����õ���0.1
end

%% �����Ǽ���Ŀ��ֵ
for i = 1:size(Possible_points,1)   %Ǳ�ڹ켣����
        %% ��ȡǱ�ڹ켣
        Potential_trajectory_allData = reshape(Possible_points(i,3:size(Possible_points,2))',[],perception_time)';%��һ�л�ԭ��17��*14��  possible_pointsǰ�����������
        %% ���������һ��
        [Potential_trajectory_allData_output] = Anti_normalizating_NEW(Potential_trajectory_allData,perception_time,mmax,mmin);%  ����һ��������֮ǰѵ��Ԥ�������ݵ�mmaxm��mmin
        %% ��������
        Potential_trajectory = Potential_trajectory_allData_output(:,1:2);%ֻȡǰ�������о�����λ��
        fit_dis = [fit_dis; ADE(Truth_trj,Potential_trajectory)];%��������ʵ�켣������ʱ����м���
%        %��ͼ������һ��
%         hold on
%         figure(1)
%         plot(Potential_trajectory(:,1),Potential_trajectory(:,2),'black')  %o v *   %Ԥ��켣
%         hold on
%         scatter(Potential_trajectory(perception_time,1),Potential_trajectory(perception_time,2),'o','m')
        Potential_trajectory_1D = reshape(Potential_trajectory, 1 , []);%reshpe��һ�У�ǰ������[1x,2x,3x]���󲿷���[1y,2y,3y]
%         ����Ū������ʵ�켣�����水�ռ���ÿ��Ǳ�ڹ켣��Ŀ��ֵ
        [const,~] = nonlcon_Complete_path(Potential_trajectory,perception_time);%��Լ��
        const_output_all = [const_output_all sign(const)];%��������
        [~,~,~,output_dis,output_risk,sum_Dis_Path] = Trajectory_benefit_calculating(Potential_trajectory); %��fitt  ����Trajectory_benefit_calculating��ȡÿ��Ǳ�ڹ켣��fitt
        possible_points_in = [possible_points_in;[Possible_points(i,1:2) output_dis sum(sign(const)) Potential_trajectory_1D output_risk,sum_Dis_Path]];   %��ѡ�յ� [ǰ��λ�����i ǰ��λ�����j Ч��ֵ Լ��ֵ һά�켣���� ]     possible_points_in = [possible_points_in;[Possible_points(i,1:2) fitt sum(sign(const)) Potential_trajectory_1D output2]];   %��
end
%% ��������������й�һ������������Ŀ��ֵ
% dis_min = 0.5 * min(possible_points_in(:,size(possible_points_in,2)));%��Ҫ����Сֵȥ��һ�����������ݲ���̫��
sum_Dis_Path = possible_points_in(:,size(possible_points_in,2));%�����й�һ��     %(possible_points_in(:,size(possible_points_in,2))-dis_min)/(max(possible_points_in(:,size(possible_points_in,2)))-dis_min);%��ȡ����ÿ����������·��,�����й�һ��������ÿ��������·���Ĺ�һ������� ���ã� (possible_points_in(:,size(possible_points_in,2)));
%�� sum_Dis_Path���и�ֵ��һ��
risk_handle1 = [(1:size(possible_points_in,1))' sum_Dis_Path];
risk_handle1 = sortrows(risk_handle1,2);
risk_handle1 = [risk_handle1 (1:size(possible_points_in,1))'];
risk_handle1 = sortrows(risk_handle1,1);
sum_Dis_Path = risk_handle1(:,3);
sum_Dis_Path = ((sum_Dis_Path)-(min(sum_Dis_Path)))./(max(sum_Dis_Path)-min(sum_Dis_Path))+0.1;
% ��ֵ��һ������
possible_points_in(:,size(possible_points_in,2)) = [];%��·����Ϣɾ����
% �������һ���Ƿ�����Ϣ   ����ڶ��п����Ƿ���ռ����а�����·������
possible_points_in(:,size(possible_points_in,2)) = ((possible_points_in(:,size(possible_points_in,2)))-(min(possible_points_in(:,size(possible_points_in,2)))))./((max(possible_points_in(:,size(possible_points_in,2))))-(min(possible_points_in(:,size(possible_points_in,2)))))+0.1;%��ƽ���켣��ķ���ֵ���գ�x-min��/(max-min)�ķ������й�һ����
possible_points_in(:,size(possible_points_in,2)) = sum_Dis_Path.*possible_points_in(:,size(possible_points_in,2));%sum_Dis_Path��ƽ�����ճ���·�����ȣ�����·�����յĶ���
% ���յ�˳��ֵ��һ��   ��possible_points_in(:,size(possible_points_in,2))
risk_handle = [(1:size(possible_points_in,1))' possible_points_in(:,size(possible_points_in,2))];
risk_handle = sortrows(risk_handle,2);
risk_handle = [risk_handle (1:size(possible_points_in,1))'];
risk_handle = sortrows(risk_handle,1);
possible_points_in(:,size(possible_points_in,2)) = risk_handle(:,3);
%  ˳��ֵ����
possible_points_in(:,size(possible_points_in,2)) = ((possible_points_in(:,size(possible_points_in,2)))-(min(possible_points_in(:,size(possible_points_in,2)))))./((max(possible_points_in(:,size(possible_points_in,2))))-(min(possible_points_in(:,size(possible_points_in,2)))))+(min(possible_points_in(:,size(possible_points_in,2))))*0.1;%���ܷ���ֵ��һ����

dis_allSample = (((-possible_points_in(:,3))-(min(-possible_points_in(:,3))-(min(-possible_points_in(:,3))/10)))./((max(-possible_points_in(:,3)))-(min(-possible_points_in(:,3)))));%��λ��ֵ���գ�x-min��/(max-min)�ķ������й�һ����  dis_allSample = (((-possible_points_in(:,3))-(min(-possible_points_in(:,3))-(min(-possible_points_in(:,3))/10)))./((max(-possible_points_in(:,3)))-(min(-possible_points_in(:,3)))));%      %dis_allSample = (((-possible_points_in(:,3))-(min(-possible_points_in(:,3))))./((max(-possible_points_in(:,3)))-(min(-possible_points_in(:,3)))));
dis_allSample = -dis_allSample;
%��������Ч�ã�
possible_points_in(:,3) = (1-k4).* (dis_allSample*1) + k4.* possible_points_in(:,size(possible_points_in,2));
disp(dis_allSample);%·��
disp(possible_points_in);%risk
%%  ��Ŀ��ֵ�ĵط�������ʵ�켣�����ֵ�����滻����������������һʧ��Ԥ������Ƕ��٣� 
possible_points_in_fit_dis = [possible_points_in(:,1:2) fit_dis (ones(size(possible_points_in,1),1)*-5) possible_points_in(:,5:size(possible_points_in,2))];%��fit������ʵ�켣������滻�����ҵ����ɹ켣�������С�Ĺ켣��
% ���Ͻ���

%% ��������ѡ����
% ��fit��������
possible_points_allData = sortrows(possible_points_in,3);
optimal_solution = sortrows(possible_points_in(:,1:size(possible_points_in,2)-1),3);%���ű�ʾ��������  ������ֵ  ��    optimal_solution = sortrows(possible_points_in(:,1:size(possible_points_in,2)-1),3);%���ű�ʾ��������
save optimal_solution
% ��fit_dis��������
possible_points_allData_dis = sortrows(possible_points_in_fit_dis,3);
optimal_solution_dis = sortrows(possible_points_in_fit_dis(:,1:size(possible_points_in_fit_dis,2)-1),3);%���ű�ʾ��������  ������ֵ  ���յ�������������  ��fitt��С�ģ�����Ч��ֵ����    optimal_solution_dis = sortrows(possible_points_in_fit_dis(:,1:size(possible_points_in_fit_dis,2)-1),3);%���ű�ʾ��
%% ��fit_disΪĿ��ֵ���У���ʽ����ʱ����һС�ڲ����У�
%optimal_solution = optimal_solution_dis; %�Զ�ѡ����ӽ���Ԥ��켣

%% �ɵ�Ѱ�����ŵķ���
index_OPT = 1;%��¼ȡ����ֵ�ĵڼ���Ϊ��ѡ��
OPT_th_data_5 = [];
OPT_th_data_3 = [];

for i = 1:size(optimal_solution,1)
    if optimal_solution(i,4) == -5  %-5��ʾ����Լ������
        OPT_th_data_5 = [OPT_th_data_5; [index_OPT i]]; 
        index_OPT = index_OPT + 1;
    elseif optimal_solution(i,4) == -3  %-3��ʾ����Լ������
        OPT_th_data_3 = [OPT_th_data_3; i]; 
    end
end
if isempty(OPT_th_data_5)%��ѭ���껹��û������Լ�������ģ���ֱ���������������������ֵ
    if isempty(OPT_th_data_3)
        OPT_allData = optimal_solution(OPT_th,:);%������Լ��������
        const_output = optimal_solution(OPT_th,4);
        EXITFLAG = 1;%��ʾ�޿��н⣬����Ĳ���Լ������������ֵ
    elseif size(OPT_th_data_3,1) >= 1
        OPT_allData = optimal_solution(OPT_th_data_3(1),:);%������Լ��������
        const_output = optimal_solution(OPT_th_data_3(1),4);
        EXITFLAG = 0;%��ʾ�޿��н⣬����Ĳ���Լ������������ֵ
    end
elseif size(OPT_th_data_5,1) >= OPT_th
    OPT_allData = optimal_solution(OPT_th_data_5(OPT_th,2),:);%������
    const_output = optimal_solution(OPT_th_data_5(OPT_th,2),4);
    EXITFLAG = 0;%��ʾ�����˳����ҵ�������Լ��������ֵ
else
    OPT_allData = optimal_solution(OPT_th_data_5(size(OPT_th_data_5,1),2),:);%������
    const_output = optimal_solution(OPT_th_data_5(size(OPT_th_data_5,1),2),4);
    EXITFLAG = 0;%��ʾ�����˳����ҵ�������Լ��������ֵ
end

%% ������ٷ���켣���,һ�����OPT
% OPT = OPT_allData(5:size(OPT_allData,2));%ֻȡ����Ĺ켣

%% ����ѡȡ�Ĺ켣�ǿ�ѡ�켣�ĵڼ�λ��ͬʱ���Ž��ڵڼ�λ
optimal_solution_5 = optimal_solution(find(optimal_solution(:,4)==-5),:);
optimal_solution_3 = optimal_solution(find(optimal_solution(:,4)==-3),:);
optimal_solution_1 = optimal_solution(find(optimal_solution(:,4)==-1),:);
optimal_solution_11 = optimal_solution(find(optimal_solution(:,4)==1),:);
optimal_solution_33 = optimal_solution(find(optimal_solution(:,4)==3),:);
optimal_solution_order = [optimal_solution_5;optimal_solution_3;optimal_solution_1;optimal_solution_11;optimal_solution_33];%����������

OPT = optimal_solution_order(OPT_th,5:size(optimal_solution_order,2));
index_ii = find((Possible_points(:,1)==optimal_solution_dis(1,1))&(Possible_points(:,2)==optimal_solution_dis(1,2)));%�ҵ���ʵ�켣��Լ�����
const_output = const_output_all(:,index_ii);
% EXITFLAG = 1;
% const_output = optimal_solution_order(OPT_th,4);
ID_best_inOPT = find(optimal_solution_order(:,1)==optimal_solution_dis(1,1)&optimal_solution_order(:,2)==optimal_solution_dis(1,2)) ;  %��ʵֵ�ڵڼ�λ
if isempty(ID_best_inOPT)
    ID_best_inOPT = 0;
%     EXITFLAG = 0;
end
ID_best_inDis = find(optimal_solution_dis(:,1)==optimal_solution_order(OPT_th,1)&optimal_solution_dis(:,2)==optimal_solution_order(OPT_th,2)) ;%��ѡֵ����ʵֵ�ĵڼ�λ
% ID_best_inDis
%���պ�����ͼ�������Ƿ񷴱ȵĹ�ϵ
% bar(dis_allSample)
% hold on
% bar(possible_points_in(:,size(possible_points_in,2)))
% hold on
% bar(possible_points_in(:,3))
%  %% ������ѡ�켣
% hold on
% scatter(Truth_no(:,4),Truth_no(:,5),50,'o','b')  
% i=find(Possible_points(:,1)==optimal_solution_order(OPT_th,1)&Possible_points(:,2)==optimal_solution_order(OPT_th,2)) ;
% Potential_trajectory_allData = reshape(Possible_points(i,3:size(Possible_points,2))',[],perception_time)';%��һ�л�ԭ��17��*14��  possible_pointsǰ�����������
% [Potential_trajectory_allData_output] = Anti_normalizating_NEW(Potential_trajectory_allData,perception_time,mmax,mmin);%  ����һ��������֮ǰѵ��Ԥ�������ݵ�mmaxm��mmin
% Potential_trajectory = Potential_trajectory_allData_output(:,1:2);%ֻȡǰ�������о�����λ��
% hold on
% scatter(Potential_trajectory(:,1),Potential_trajectory(:,2),50,'o','r')  %o v *   %������ѡ�켣
% optimal_solution_dis(find(optimal_solution_dis(:,1)==optimal_solution_order(OPT_th,1)&optimal_solution_dis(:,2)==optimal_solution_order(OPT_th,2)),3)
% figure(2)
% [input_order] = Utility_heat_map(optimal_solution_order);%����Ч�õ�����ͼ����
% 
% 
% figure(3)%����Ч�ú�ADE�����߶Ա�ͼ����
% utility_ALL = input_order(:,1:3);
% ADE_ALL = optimal_solution_dis(:,1:3);
% for din = 1:size(utility_ALL,1)
%     IDD = find(ADE_ALL(:,1)==utility_ALL(din,1)&ADE_ALL(:,2)==utility_ALL(din,2));
%     utility_ALL(din,4:6)=ADE_ALL(IDD,:);
% end
% utility_ALL(:,4:5) = [];
% utility_ALL(:,size(utility_ALL,2)) = (utility_ALL(:,size(utility_ALL,2))-min(utility_ALL(:,size(utility_ALL,2))))/(max(utility_ALL(:,size(utility_ALL,2)))-min(utility_ALL(:,size(utility_ALL,2))));
% 
% 
% utility_ALL = sortrows(utility_ALL,4);
% end
