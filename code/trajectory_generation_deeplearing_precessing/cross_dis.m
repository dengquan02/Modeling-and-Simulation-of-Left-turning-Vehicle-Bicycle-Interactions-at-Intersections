function [output,output_dis] = cross_dis(input1,input2)
%�ú����������Ǽ���Ԥ��켣����ʵ�켣����ͬʱ����µĺ�����֮��
%ϣ����Ҫ̫�ߣ�Ŀǰ��׼����಻����1.5���Ҳ಻����0.5��
%��output = 1,��ʾͻ���¼�Ԥ��׼ȷ
% out_dis��ʾ������������
% input1 = Truth_no(:,4:5);%��ʵ�켣
% input2 = output1;%Ԥ��켣
left = 0;%���
right = 0;
%% Method��:������ͬʱ��켣��������
% dis_all = [];%��ź�������
% output_if_unmutation = [];
% for i = 1:size(input1,1)
%     if input2(i,2)>=(input1(i,2)-left)&&input2(i,2)<=(input1(i,2)+right)%���Ԥ��ֵ�ھ��ȷ�Χ��
%         cro_dis = 0 ;%������0
%     elseif input2(i,2)<(input1(i,2)-left)&&input2(i,2)<(input1(i,2)+right)%���Ԥ��ֵ�������
%         cro_dis = input2(i,2) - (input1(i,2)- left);%Ԥ��ֵ��ȥ��ʵֵ-1.5
%     elseif input2(i,2)>(input1(i,2)-left)&&input2(i,2)>(input1(i,2)+right)%���Ԥ��ֵ���Ҳ�
%         cro_dis = input2(i,2) - (input1(i,2)+ right);%Ԥ��ֵ��ȥ��ʵֵ+0.5
%     end
% %     disp(cro_dis)
%     output_if = sign(cro_dis);%�����������
%     output_if_unmutation = [output_if_unmutation;output_if];
%     dis_all = [dis_all;cro_dis];
% end
% if sum(output_if_unmutation)~=0
%     ID_dis = find(abs(dis_all)==max(abs(dis_all)));%�ҵ�������ĵ�
% %     disp('���ֵ')
% %     disp(ID_dis)
%     output_dis = dis_all(ID_dis);
% else 
%     output_dis = 0;
% end
% output = 1-sign(sum(abs(output_if_unmutation)));

%% Method��:������ʵ��Ԥ��켣����Զֱֵ�Ӽ���
extend_hor_GT = min(input1(:,2));%��ʵ�켣�����켣��ĺ������꣨��������������꣩
extend_hor_pre = min(input2(:,2));%Ԥ��켣�����켣��ĺ������꣨��������������꣩
output_dis = extend_hor_pre - extend_hor_GT;%������Ԥ��ֵ-��ʵֵ����ֵ��ʾԤ������ڲ࣬��ֵ��ʾԤ�������ࣻ
if output_dis<right&&output_dis>-left
    output = 1;
else
    output = 0;
end
end
