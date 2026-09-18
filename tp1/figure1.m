clear;
clc;
close all;

definit_param;
simule_systeme;

figure

subplot(3,1,1)
plot(t, alpha)
hold on
plot(t, beta)
plot(t, gamma)
grid on
title('Positions mesurées')
xlabel('Temps (s)')
ylabel('Position (m)')
legend('alpha','beta','gamma')

subplot(3,1,2)
plot(t, vit_alpha)
hold on
plot(t, vit_beta)
plot(t, vit_gamma)
grid on
title('Vitesses mesurées')
xlabel('Temps (s)')
ylabel('Vitesse (m/s)')
legend('vit alpha','vit beta','vit gamma')

subplot(3,1,3)
plot(t, acc_alpha)
hold on
plot(t, acc_beta)
plot(t, acc_gamma)
grid on
title('Accelerations mesurées')
xlabel('Temps (s)')
ylabel('Acceleration (m/s^2)')
legend('acc alpha','acc beta','acc gamma')