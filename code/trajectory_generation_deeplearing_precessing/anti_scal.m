function [output] = anti_scal(input,ratio_test,start_point_test,minE,nu)
%%%%�������ݷ�����ÿ���������Ϊ���仯�����Ժ��ٳ�������֮��ľ��롣��֤�����ڲ��Ĳ����Ժ�����֮��������ԣ���׼��Ϣ������
output=input;
t=size(output,1);
for i=1:t
    for j=1:minE %����minE���㣻
        for o=1:3:(nu)
             output(i,((j-1)*nu+o))=start_point_test(1,i)+ratio_test(i)*(input(i,((j-1)*nu+o))-start_point_test(1,i))/15;%����x��ȥ�������x����������֮��ľ��룬���������ͬһˮƽ,���ӻ����� 
             output(i,((j-1)*nu+o+1))=start_point_test(2,i)+ratio_test(i)*(input(i,((j-1)*nu+o+1))-start_point_test(2,i))/15;%����y��ȥ�������y����������֮��ľ��룬���������ͬһˮƽ�����ӻ����� 
        end
    end
end
end