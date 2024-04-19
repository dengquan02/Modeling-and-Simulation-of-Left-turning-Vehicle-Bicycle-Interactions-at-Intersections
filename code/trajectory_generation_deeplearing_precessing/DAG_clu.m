function [DAG] = DAG_clu(all_risk,benchmark_risk)
%��������ͼ
%all_risk����ɢ����ĵ�ͷ��� ,��5����x��������y
%benchmark_risk�ǻ�׼���գ���С�Ŀ�������
% benchmark_risk = 40;%�����ϹŪ��
min_risk = min(all_risk(:,7));
DAG = [zeros(size(all_risk,2)) all_risk';all_risk zeros(size(all_risk,1))];%�����ڽӾ���
%���濪ʼ��ֵ
for i =8:size(DAG,1)
    for j =8:size(DAG,2)
        if DAG(i,j)==0
            DAG(i,j)=-inf;%�Ƚ�����ֵ������-inf
        end
    end
end

for i =1:size(DAG,1)
    if DAG(i,1)~=0
        time_step = DAG(i,1);%��ȡʱ���
        longcood = DAG(i,3);%��ȡ������
        crosscood = DAG(i,4);%��ȡ������
        left = find((DAG(1,:)==time_step+1)&(DAG(3,:)==longcood-1)&(DAG(4,:)==crosscood+1));%�ҵ���һ��ʱ����ߵĵ�
        right = find((DAG(1,:)==time_step+1)&(DAG(3,:)==longcood+1)&(DAG(4,:)==crosscood+1));%�ҵ���һ��ʱ���ұߵĵ�
        next = find((DAG(1,:)==time_step+1)&(DAG(3,:)==longcood)&(DAG(4,:)==crosscood+2));%�ҵ���һ��ʱ��ǰ���ĵ�
%         fixed = find((DAG(1,:)==time_step+1)&(DAG(3,:)==longcood)&(DAG(4,:)==crosscood));%�ҵ���һ��ʱ�̶̹������ĵ�
        connection = [left right next];%�п����ĸ����ӵ㲻ȫ
%         DAG(i,fixed) = 0;%λ��û��������Ͷ�Ϊ0��
        if length(connection)>1%�ҵ��������������ӵ�
            for j = 1:size(connection,2)
%                 reduction = 1-((DAG(connection(j),7)-min_risk)/(benchmark_risk-min_risk));%��������ۼ�ϵ��������1���ʾ��ֵ
                DAG(i,connection(j)) = DAG(connection(j),7);%�г�����*�ۼ�ϵ��   �ı���㷽����ȥ���˺˼�ϵ����������һ�к���һ��   DAG(i,connection(j)) = (abs(DAG(i,5)-DAG(connection(j),5)))*(reduction);%�г�����*�ۼ�ϵ��
            end
        end
    end
end


end

% x=(0:0.1:10);
% scatter(x,1-((x-0.1)/(2-0.1)))