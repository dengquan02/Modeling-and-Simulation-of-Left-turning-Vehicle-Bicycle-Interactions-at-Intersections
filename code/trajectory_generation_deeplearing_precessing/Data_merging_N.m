function [output] = Data_merging_N(N1,N2)
N = N1;
N2(:,12) = N2(:,12)+N(size(N,1),12);%��12���ǹ켣ID
N = [N;N2];
N(:,14) = [];
output = N;
output(:,12) = N(:,13);%ID_in����һ��λ��
output(:,13) = N(:,12);%ID
end

