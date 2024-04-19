function [output,mmin,mmax] = Normalizing(input)
%������һ��
output=zeros(size(input,1),size(input,2));
mmin=zeros(1,size(input,2));
mmax=zeros(1,size(input,2));
for i=1:size(input,2)
    mmin(i)=min(input(:,i)); %���ÿ����Сֵ
    mmax(i)=max(input(:,i)); %���ÿ�����ֵ�������Ժ󷴹�һ��
    for j=1:size(input,1)
        output(j,i)=(input(j,i)-mmin(i))/(mmax(i)-mmin(i)); %��ÿ�У�ָ�꣩���й�һ��
    end
end
for i=1:size(output,1)
    for j=1:size(output,2)
        if isnan(output(i,j))%�����������nan�Ļ�����д��0��
           output(i,j)=0;
        end
    end
end
end

