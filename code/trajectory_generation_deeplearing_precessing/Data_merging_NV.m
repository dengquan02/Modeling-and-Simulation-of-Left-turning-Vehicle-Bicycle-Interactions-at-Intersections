function [output] = Data_merging_NV(N1V,N2V)
NV = N1V;
N2V(:,12) = N2V(:,12)+NV(size(NV,1),12);%��12���ǹ켣ID
NV = [NV;N2V];
NV(:,14) = [];
output = NV;
output(:,12) = NV(:,13);%ID_in����һ��λ��
output(:,13) = NV(:,12);%ID
end

