function [tt_t,yy_y] = Anti_normalizating(tt,yy,mmax,mmin)
%����һ��
%   �˴���ʾ��ϸ˵��
tt_t=zeros(size(tt,1),size(tt,2));%tt��ʾ��ֵ
yy_y=zeros(size(yy,1),size(yy,2));%��ʾԤ��
for i=1:size(tt,2)
    for j=1:size(tt,1)
        tt_t(j,i)=((mmax(i)-mmin(i))*tt(j,i))+mmin(i);   %%��ÿ�У�ָ�꣩���з���һ��
    end
end
for i=1:size(yy,2)
    for j=1:size(yy,1)
        yy_y(j,i)=((mmax(i)-mmin(i))*yy(j,i))+mmin(i);   %%��ÿ�У�ָ�꣩���з���һ��
    end
end 
end

