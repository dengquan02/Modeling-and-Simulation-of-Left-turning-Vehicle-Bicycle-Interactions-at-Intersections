function [output] = Data_merging_E(E1,E1_add,E2,E2_add)
E = E1;
E1_add(:,12) = E1_add(:,12)+E(size(E,1),12);%��12���ǹ켣ID
E = [E;E1_add];
E2(:,12) = E2(:,12)+E(size(E,1),12);%��12���ǹ켣ID
E = [E;E2];
E2_add(:,12) = E2_add(:,12)+E(size(E,1),12);%��12���ǹ켣ID
E = [E;E2_add];
E(:,14) = [];
output = E;
output(:,12) = E(:,13);%ID_in����һ��λ��
output(:,13) = E(:,12);%ID
end

