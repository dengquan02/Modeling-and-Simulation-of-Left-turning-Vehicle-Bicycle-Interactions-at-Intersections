function [all_output] = Myfitting(X)
%threshold_Risk = X(1);
% G=X(7);
R_b = 1;%��ʾ��·�����������������1�Ĳ���
k1 = X(1);
k3 = X(2);
char_intrusion = X(3);%ԭ����2
char_end = X(4);%ԭ����6
index_end = X(5);
k4 = X(6);
char_intrusion_right = X(7);
char_end_right = X(8);
index_end_right = X(9);
% tic
hitss = 10;%������
prop = 2;%���ٶ����ɵı���
% threshold_Risk = 0.5;
G=X(10);%G=0.01;
% R_b = 1;
% M_b = 2000;%����ڼ������������
% k1 = 1;
% k3 = 0.05;
% char_intrusion = 2;%ԭ����200
% char_end = 0.2;%ԭ����6
% index_end = 2;
% k4 = 1.2;
����������������ͻᱨ��
%��������Ŀ��������֪��ʵ�켣������£�������ͷ���ΪĿ�꣬ȡ��ʵ�켣�����ɹ켣������Ĳ�������
global data_cal;%�궨������  ��ʽ��E_trajectoryһ��������ID������һ����
perception_time = 20;%Ԥ�ⲽ������
global intrusion_cood_E
% intrusion_cood_E = [47.43 27;47.43 23.5;3 27;3 23.5];
input = data_cal;
index_cal = unique(data_cal(:,1)');%��ȡ���
output = 0;%��¼���������켣��Ŀ��ֵ�Ƿ����Ŀ��ֵ��Խ��Խ��
index_output = 0;%��¼������
for index = 1:size(index_cal,2)%����ÿ���켣
    extract_trajectory = input((input(:,1)==index_cal(index)),:);%��ȡ�켣���Ϊindex�Ĺ켣
    for index_in = randperm((size(extract_trajectory,1)-perception_time-1),1)%round(rand(1)*18)+1:(size(extract_trajectory,1) - perception_time-1)  %����ÿ���켣��
        extract_20 = extract_trajectory(index_in:index_in+perception_time,:);%��ȡ����ʵ�켣
        %%%��ʼ��Ԥ���������һϵ�п��ܵĹ켣����֤����������ʵ�켣���Ϳ�����ɱ궨����
        output_gen = [];%�洢ÿ�����ɹ켣��Ŀ��ֵ
        for ID_generation = 1:hitss%����ʮ�������켣
%             accle = rand(1,perception_time*2);
%             accle(1,1:perception_time) = 2*pi*accle(1,1:perception_time);
%             accle(1,perception_time+1:perception_time*2) = 1.6*accle(1,perception_time+1:perception_time*2);%���ٶȵ��Ͻ�  ��λm/s
%             acc =[accle(1:perception_time)' accle(perception_time+1:perception_time*2)'];%һ�л�������
            %%%����ʵ�켣�����ȥһЩ��
             accle = (rand(1,perception_time*2)*2-1)*prop;%�����������ʵ�켣���ٶȵ�5%����
             acc =[accle(1:perception_time)' accle(perception_time+1:perception_time*2)'];%һ�л�������
             acc = extract_20(1:perception_time,8:9).*(1+acc);
            %�������-1.6~1.6m/s^2��
 %           accle = (rand(1,perception_time*2)*2-1)*1.6;%�����������ʵ�켣���ٶȵ�5%����
  %          acc =[accle(1:perception_time)' accle(perception_time+1:perception_time*2)'];%һ�л�������
            
%             ��ʼ����Ŀ��ֵ
            extract = extract_20(1,:);%Ԥ���֡
            extract(:,1:3) = [];
            extract = reshape(extract',11,[])';%�����11�е�
            extract(all(extract==0,2),:)=[];%ȥ��ȫ0��,ʣ�µ���ÿ����������ģ���һ��������
            base_point = extract(1,1:2);%��׼��
            Vio = [extract(1,3) extract(1,4)];%ǰ������&������
            prediction_point = base_point;%���Ԥ���ľ���
            diss = [];%��¼�ľ���
            Risk = [];%������ŷ���,��һ����Ԥ��㣬�ڶ�������ʵ��
            standard_point = [];
            for i = 1:size(acc,1)%����ÿһ��������
                extract_time_i = reshape(extract_20(i,4:size(extract_20,2))',11,[])';%�����11�е�
                extract_time_i(all(extract_time_i==0,2),:)=[];%ȥ��ȫ0��,������ʵ�Ľ�������
                %�ȼ��� ��Ҫ���ٶȵ��Ǹ��㣬ȷ��Լ����Χ��
                pre_point = [(base_point(1,1)+Vio(1,1)*0.12) (base_point(1,2)+Vio(1,2)*0.12)];%������ٶ��ƽ��ĵ㣬Ҳ��������ԭ�㣻
                [acceleration(1,1),acceleration(1,2)] = pol2cart(acc(i,1),acc(i,2));%�����ٶȵļ�����ת��Ϊֱ������
                %�����ٶȻ������ٶȲο�ϵ
                truth_point = [pre_point(1,1)+acceleration(1,1)*0.12^2*0.5 pre_point(1,2)+acceleration(1,2)*0.12^2*0.5];%���ݵ�ǰʱ�̵ļ��ٶ������ʵ�켣�㣻
                Vio = [Vio(1,1)+acceleration(1,1)*0.12 Vio(1,2)+acceleration(1,2)*0.12];%���µļ��ٶȸ�����һ���������ٶ�  vt=v0+at
                truth_Risk = Risk_calculation(truth_point,extract_time_i(2:size(extract_time_i,1),:),intrusion_cood_E,G,R_b,k1,k3,char_intrusion,char_end,index_end,char_intrusion_right,char_end_right,index_end_right);%���㵱ǰ��ķ��գ�
                Risk = [Risk;norm(truth_Risk)];
                dis = Vio(1,1)*0.12;
%                 prediction_point = [prediction_point;truth_point];%��Ԥ��켣��ŵ�������
%                 standard_point = [standard_point;pre_point];%ÿһ�������ı�׼��
                diss = [diss;dis];%����ǰʱ�̵�ǰ�������λ�Ƽӽ�ȥ
                prediction_point = [prediction_point;truth_point];%��Ԥ��켣��ŵ�������
                base_point = truth_point ; %��Ԥ��㸳���׼��
            end
            output_ID = sum(diss(:,1));%����λ��֮��
            output_ID = output_ID + k4*(sum(Risk(:,1)));%��궨��������Ȩ��
            %%%���ɹ켣���
            output_gen = [output_gen;output_ID];%���ɹ켣������Ŀ��ֵ
%             scatter(prediction_point(:,1),prediction_point(:,2),'*','r');%����켣
%             hold on
%             scatter(extract_20(:,4),extract_20(:,5),'*','b');%��ʵ�켣
        end
%         ��ɫ�Ƚ����ۣ����������ɹ켣��Ŀ��ֵ��
        Risk_real = [];%��¼һ�����Ż��ķ���
        for i = 1:perception_time%����ÿһ��������
            extract_time_real = reshape(extract_20(i,4:size(extract_20,2)),11,[])';%��ȡ��ǰʱ�̵Ľ�������
            
            extract_time_real(all(extract_time_real==0,2),:)=[];%ȥ��ȫ0��,ʣ�µ���ÿ����������ģ���һ��������
            truth_Risk_real = Risk_calculation(extract_time_real(1,1:2),extract_time_real(2:size(extract_time_real,1),:),intrusion_cood_E,G,R_b,k1,k3,char_intrusion,char_end,index_end,char_intrusion_right,char_end_right,index_end_right);%���㵱ǰ��ķ��գ�
            Risk_real = [Risk_real;norm(truth_Risk_real)];%��¼��ǰ��ķ���ֵ
        end
        output_one = -(extract_trajectory(index_in,4)-extract_trajectory(index_in+perception_time,4)) + k4*(sum(Risk_real(:,1)));%һ��Сѭ��(һ���켣��)������+���� 
%         if isnan(output_one)
%             continue
%         end
        try
            for i = 1:size(output_gen,1)
                output_gen_dif = output_one - output_gen(i,1) ;%����ʵ�켣Ŀ��ֵ��ȥ���ɵģ��������Խ��Խ��
%                 disp(output_gen_dif)
                index_output = index_output + 1;
                if output_gen_dif>0
                    output = output + 1;
                end
            end
        catch
            continue
        end
    end
%     disp(output)
%     disp(['�����',num2str(index/size(index_cal,2)*100),'%'])
end
all_output = output/index_output;
% toc
disp(['fitting = ',num2str(all_output)])

end


