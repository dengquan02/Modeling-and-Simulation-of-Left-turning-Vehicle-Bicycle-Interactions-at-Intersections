function[]= testdividing(input,path)
%�����Լ��ֿ���� 
dir = strcat(path,'\x_test_');
for i=1:size(input,1)
    dlmwrite([dir,num2str(i),'.txt'],input(i,:));
    %save(['x_test_',num2str(i),'.txt'],input(i,:));%[]��ʾ���������num2str()��ʾ��ֵ����ַ�
end
end


