%����ÿ���켣������ָ��ʣ�������Ϊ�켣��
tic
test_result_block = [];%��¼������
input = trajectory_block;%�ȼ���������Ϊ��
index_all = randperm(trajectory_block(size(trajectory_block,1),1),33);%�����������ѡ��30%�Ĺ켣�����м���
for ID = 1:size(index_all,2)%����ÿ���켣
    index = index_all(ID);%�켣���
    output = [];
    Nu_point = 1;%������Ϊ�˼���
    DIS = [];
    result_point = [];
    buxing = 0;
    Plo = [];
    lo = [];
        extract_trajectory = input((input(:,1)==index),:);%��ȡ�켣���Ϊindex�Ĺ켣
      % ��ͼ
%       hold on
%       drow_point = extract_trajectory;
%       for i = 4:11:size(drow_point)
%           scatter(drow_point(:,i),drow_point(:,i+1),'*','r');
%       end  
        index_in = randperm(extract_trajectory(size(extract_trajectory,1),2)-perception_time-1,1);%���ѡ���켣��һ��ʱ��������Ԥ��
%         while index_in <=size(extract_trajectory,1)-1%��ȡÿ���켣�㣬��ÿ֡
            global extract_one
            extract_one = extract_trajectory(index_in,:);%ÿ֡����
%           next_point =  [(extract_one(1,6)*0.12),(extract_one(1,7)*0.12)];%�ҵ���һ�����ٶȵĵ㣨�Ե�ǰ��Ϊԭ���һ����
%           next_point = [next_point;[extract_trajectory(index_in+1,4)-extract_trajectory(index_in,4),extract_trajectory(index_in+1,5)-extract_trajectory(index_in,5)]];%����ʵ����ں���
%           [nextPol_point(:,1),nextPol_point(:,2)] = cart2pol(next_point(:,1),next_point(:,2));%ת��Ϊ������
%           Plo = [Plo;abs(rad2deg(nextPol_point(1,1)-nextPol_point(2,1)))];
%           lo = [lo;abs(nextPol_point(1,2)-nextPol_point(2,2))];
%           if (abs(rad2deg(nextPol_point(1,1)-nextPol_point(2,1)))>15&&abs(rad2deg(nextPol_point(1,1)-nextPol_point(2,1)))<345)||(((nextPol_point(2,2)-nextPol_point(1,2))>0.12)||((nextPol_point(2,2)-nextPol_point(1,2))<-0.24))
%               buxing = buxing + 1;%�Բ����������ļ���
%           end
%             ���������ˣ���Ԥ��
            tic
            MyGA;%���Ŵ��㷨���
            toc
            test_result_block = [test_result_block;[ID index index_in OPT]];%index�ǹ켣��ţ�index_in�ǹ켣��Ԥ���ı�ţ� OPT���Ż���ļ��ٶȼ���
%             Myfmincon;%��fmincon���
%             �������Ŵ��㷨���
%             ����������Ԥ��켣�Ŀ��ӻ�
%             scatter(extract_time_i(2:size(extract_time_i,1),1),extract_time_i(2:size(extract_time_i,1),2),'*','p')%���������
%             hold on
%             for i =1:20
%             scatter(extract_trajectory(index_in+i-1:index_in+i,4),extract_trajectory(index_in+i-1:index_in+i,5),'*','b')
%             hold on
%             scatter(output1(i+1,1),output1(i+1,2),'*','r')
% %             hold on 
% %             scatter(standard_point(i,1),standard_point(i,2),'*','g')
% %             i = i+1;
%             pause(0.5)
%             end
%            [MDE] = ADE(extract_trajectory(index_in:index_in+20,4:5),output1);%����ƽ���������     
     disp(['�����',num2str(ID/size(index_all,2)*100),'%'])
end
toc

%���ϼ�����֮�����濪ʼ���������
MDE = [];%��¼���
for i =1:size(test_result_block,1)
    index_ce = find(input(:,1)==test_result_block(i,2)&(input(:,2)==test_result_block(i,3)));
    Truth_block = input(index_ce : index_ce + perception_time,:);%��ʵ�켣
    [output,output1,output2] = Excur_predict_2(test_result_block(i,4:size(test_result_block,2)),Truth_block(1,:),Truth_block);%%output��Ŀ��ֵ��output1�������Ԥ��㣻output2������ķ���ֵ��
    clf
    for j =1:20
        scatter(Truth_block(j+1,4),Truth_block(j+1,5),'*','b')
        hold on
        scatter(output1(j+1,1),output1(j+1,2),'*','r')
        pause(0.5)
    end
    [MDE] = [MDE ; ADE(Truth_block(:,4:5),output1)];%����ƽ���������   
%     pause(2)
    disp(ADE(Truth_block(:,4:5),output1))
end
disp(min(MDE))
disp('done��!!')