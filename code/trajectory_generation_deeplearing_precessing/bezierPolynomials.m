function [res] = bezierPolynomials(s,alpha)
% s��[0,1]֮�� alpha���������ߵ���״
    M = size(alpha,2)-1;% ֻ��Ҫ�趨alpha�Ĵ�СM��ȷ����
    M_factorial = factorial(M);
    res = 0;
    for k = 0:1:M
       res = res + M_factorial/(factorial(k)*factorial(M-k))*alpha(k+1)*s^k*(1-s)^(M-k);
    end
end
