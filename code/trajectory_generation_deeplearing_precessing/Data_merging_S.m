function [output] = Data_merging_S(S1,S2)
S = S1;
S2(:,12) = S2(:,12)+S(size(S,1),12);%��12���ǹ켣ID
S = [S;S2];
S(:,14) = [];
output = S;
output(:,12) = S(:,13);%ID_in����һ��λ��
output(:,13) = S(:,12);%ID
end

