function [outputArg] = check_point_line(cro_point_1,input_1,input_2)
%���� �Ƿ�������
%���������ݣ�����ʱX��
% cro_point_1 = cro_point(1,:);
% input_1 = input_trajectory_1(j,:);
% input_2 = input_trajectory_1(j+1,:);

OA = cro_point_1 - input_1;
OB = cro_point_1 - input_2;
if norm(OA)==0||norm(OB)==0
    outputArg = 1;%������
else
    cosOAOB = OA*OB'/(norm(OA)*norm(OB));
    if cosOAOB - (-1)<0.01 %������ֵΪ-1����˵����������  ,�����и����0.0001����Ϊֱ����ȿ�����������
        outputArg = 1;
    else
        outputArg = 0;%��������-1����������
    end
end
end
