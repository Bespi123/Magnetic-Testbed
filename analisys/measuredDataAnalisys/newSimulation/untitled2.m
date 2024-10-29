tout        = out.tout;
yout        = out.simout;
yout1       = out.simout1;

n = size(yout,3);
p_est = zeros(n,3);
p_sat = zeros(n,3);

% Display each slice of the 3D array
 numSlices = size(yout, 3);
    for j = 1:numSlices
        %fprintf('val(:,:, %d) =\n\n', j);
        p_est(j,:) = yout1(:, :, j);
        p_sat(j,:) = yout(:, :, j);
    end



figure()
sp1 = subplot(3,1,1);
    p1 = semilogx(tout,p_est(:,1),'LineWidth',2); grid on
    title('Estimated Perturbations');
    xlabel('time (s)'); ylabel('\Delta B_p  (nT)')
    %legend([p1,p2,p3],'PID','Adaptive 1', 'Adaptive 2')

sp2 = subplot(3,1,2);
    p1 = semilogx(tout,p_est(:,2),'LineWidth',2); grid on
    xlabel('time (s)'); ylabel('\Delta B_p  (nT)')
    %legend([p1,p2,p3],'PID','Adaptive 1', 'Adaptive 2')

sp3 = subplot(3,1,3);
    p1 = semilogx(tout,p_est(:,3),'LineWidth',2); grid on
    xlabel('time (s)'); ylabel('\Delta B_p z (nT)');
    %legend([p1,p2, p3],'PID','Adaptive 1','Adaptive 2');
    linkaxes([sp1,sp2,sp3],'x');

figure()
sp1 = subplot(3,1,1);
    p1 = semilogx(tout,p_sat(:,1),'LineWidth',2); grid on
    title('Estimated Perturbations');
    xlabel('time (s)'); ylabel('B_{sat} x (nT)')
    %legend([p1,p2,p3],'PID','Adaptive 1', 'Adaptive 2')

sp2 = subplot(3,1,2);
    p1 = semilogx(tout,p_sat(:,2),'LineWidth',2); grid on
    xlabel('time (s)'); ylabel('B_{sat} y (nT)')
    %legend([p1,p2,p3],'PID','Adaptive 1', 'Adaptive 2')

sp3 = subplot(3,1,3);
    p1 = semilogx(tout,p_sat(:,3),'LineWidth',2); grid on
    xlabel('time (s)'); ylabel('B_{sat} z (nT)');
    %legend([p1,p2, p3],'PID','Adaptive 1','Adaptive 2');
    linkaxes([sp1,sp2,sp3],'x');
subplot(3,1,1)
ylim([-10 10])
subplot(3,1,2)
ylim([0 25])
subplot(3,1,3)
ylim([0 40])