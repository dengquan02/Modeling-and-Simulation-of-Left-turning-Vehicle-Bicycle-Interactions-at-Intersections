function [final_gj] = traj_clean_real(gj,T)
% ������һ���켣���ٶȺͼ��ٶ����¼���
%����ʱ����ΪT��Ĭ��Ϊ0.04s
%12���ٶȣ�13�Ǽ��ٶȣ�6��λ��
hs = 3.2808;
ls_re = gj;
for j = 2:size(ls_re,1)-1
    ls_re(j,12) = [ls_re(j+1,6)-ls_re(j-1,6)]/(2*T);
    ls_re(j,13) = [ls_re(j+1,6)+ls_re(j-1,6)-2*ls_re(j,6)]/T^2;
end
ls_orig = ls_re;
% Step 1.removing the outliers
% ����쳣ֵ,���ٶ���ֵ����10*3.2808�Ĺ켣���¹滮
for j = 1:size(ls_re,1)
    if abs(ls_re(j,13)) > 10*hs & j > 10 & j < size(ls_re,1)-10
        traj = ls_re(j-10:j+10,:);
        % ����������ֵ
        x = [traj(1,2),traj(end,2)];
        y = [traj(1,6),traj(end,6)];
        xi = traj(1:end,2);
        yi = spline(x,y,xi);
        traj(:,6) = yi;
        % �ٶȺͼ��ٶ�Ҳ���¼���
        for jj = 2:size(traj,1)-1
            traj(jj,12) = (traj(jj+1,6)-traj(jj-1,6))/(2*T);
            traj(jj,13) = (traj(jj+1,6)-2*traj(jj,6)+traj(jj-1,6))/T^2;
        end
        ls_re(j-10:j+10,:) = traj;
    end
end
% Step 2 cutting off the high- and medium-frequency responses in the speed profile
% ��Low Pass Filter / һ��Butterworth��ͨ�˲��� ƽ���ٶ�
v_raw = ls_re(:,12);
v_filter = lowpass(v_raw,1,1/T);  % x һά�źţ�fpass����ֹƵ�ʣ�fs������Ƶ�ʡ�
% wc = 2 * 1 / 10; % �ض�Ƶ��1Hz������Ƶ��10Hz
% [b,a] = butter(1,wc); % һ��
% v_filter = filter(b,a,v_raw);
ls_re(:,12) = v_filter;
% % �ӵ�ǰ5��ʱ�䲽�����ݣ�ǰ5�뻻��ԭʼ����
% ls_re = [ls_re(6:end,:)]; % ls_orig(1:5,:);
% λ�ü��ٶ����¼���
for j = 2:size(ls_re,1)
    ls_re(j,6) = ls_re(j-1,6) + 0.5*T*(ls_re(j-1,12)+ls_re(j,12));
    ls_re(j-1,13) = (ls_re(j,12) - ls_re(j-1,12))/T;
end
% Step 3 Removing the Residual Unphysical Acceleration Values, Preserving the Consistency Requirements
% Ӧ��5�ζ���ʽ��ֵ�Լ��ٶȴ���5m/s^2�Ĺ켣���¹滮
for j = 1:size(ls_re,1)
    if abs(ls_re(j,13)) > 5*hs & j > 10 & j < size(ls_re,1)-10
        traj = ls_re(j-10:j+10,:);
        % 5�ζ���ʽ���
        x = [traj(1:end,2)];
        y = [traj(1:end,6)];
        p = polyfit(x,y,5);
        xi = traj(1:end,2);
        yi = polyval(p,xi);
        traj(:,6) = yi;
        % �ٶȺͼ��ٶ�Ҳ���¼���
        for jj = 2:size(traj,1)-1
            traj(jj,12) = (traj(jj+1,6)-traj(jj-1,6))/(2*T);
            traj(jj,13) = (traj(jj,12)-traj(jj-1,12))/T;
        end
        ls_re(j-5:j+5,:) = traj(6:16,:);
    end
end
% Step 4 Cutting Off the High- and Medium-Frequency Responses Generated from Step 3
% ��Low Pass Filter ƽ���ٶ�
v_raw = ls_re(:,12);
v_filter = lowpass(v_raw,1,10);  % x һά�źţ�fpass����ֹƵ�ʣ�fs������Ƶ�ʡ�
% wc = 2 * 1 / 10; % �ض�Ƶ��1Hz������Ƶ��10Hz
% [b,a] = butter(1,wc); % һ��
% v_filter = filter(b,a,v_raw);
ls_re(:,12) = v_filter;
% % �ӵ�ǰ5��ʱ�䲽�����ݣ�ǰ5�뻻��ԭʼ����
ls_re = [ls_re(15:end-15,:)]; % ls_orig(1:5,:);
% λ�ü��ٶ����¼���
for j = 2:size(ls_re,1)
    ls_re(j,6) = ls_re(j-1,6) + 0.5*T*(ls_re(j-1,12)+ls_re(j,12));
    ls_re(j-1,13) = (ls_re(j,12) - ls_re(j-1,12))/T;
end
% % λ��-ʱ��ͼ�Ա�
%     figure(1)
%     hold on
%     plot(ls_orig(:,2),ls_orig(:,6),'-k');
%     plot(ls_re(:,2),ls_re(:,6),'-c');
% %     plot(ls_re(:,2),ls_re(:,6),'-r');
%     % �ٶ�-ʱ��ͼ
%     figure(2)
%     hold on
%     plot(ls_orig(:,2),ls_orig(:,12),'-b');
%     plot(ls_re(:,2),ls_re(:,12),'-c');
%     % ���ٶ�-ʱ��ͼ
%     figure(3)
%     hold on
%     plot(ls_orig(:,2),ls_orig(:,13),'-r');
%     plot(ls_re(:,2),ls_re(:,13),'-c');
%     plot(ls_re(:,2),ones(length(ls_re),1)*5*hs,'-k');
%     plot(ls_re(:,2),-1*ones(length(ls_re),1)*5*hs,'-k');
%     clf(figure(1))
%     clf(figure(2))
%     clf(figure(3))
final_gj = ls_re;
end










