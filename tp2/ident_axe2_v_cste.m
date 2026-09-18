%% CE PROGRAMME PERMET D'IDENTIFIER LES PARAMETRES DU MODELE
%% DE L'AXE 2 POUR DES MOUVEMENTS A VITESSE CONSTANTE
%% G. MOREL - 29-12-05.
%% M. Khoramshahi 02-02-2023

close all
clc
load releve_vit_cste_axe2; %% charge les relevés expérimentaux

%% Paramètres connus a priori:
kc2=0.0525; %% constante de couple de l'axe 2.
N2=4.5; %% inverse du rapport de réduction de l'axe 2.

kc1=0.0525;
N1=20.25;



%% Construction de la matrice Y.
s = size(q2);
A = [];
y = [];
for k=1:s(1)
    a = [cos(q2(k)) sign(qp2(k)) qp2(k) 1];
    A = [A; a];
    y = [y; N2*kc2*i2(k)];
end

disp("Size de A : ");
disp(size(A));
disp("Size de y : ");
disp(size(y));
disp("Rank de A : ");
disp(rank(A));
disp("Conditionnement de A : ");
disp(cond(A));
%% Calcul des paramètres
p2 = (A' * A)\(A' * y);

%% Affichage des résultats.
format long
disp('Paramètres estimés à partir des données brutes : p2 = ');
disp(p2');

figure(1)
clf; %% clear figure
h=plot3(q2,qp2,kc2*N2*i2,'x');
set(h,'LineWidth',0.5);
hold on; %% permet de conserver le graphique et d'en ajouter d'autres sur la même fig.
h=plot3(q2,qp2,A*p2,'.');
set(h,'LineWidth',1.5);
title('Résultats de l''identification sans filtrage');
legend('\Gamma_2 non filtré', 'modèle');
grid on;
xlabel('$q_2$','Interpreter','latex')
ylabel('$\dot{q}_2$','Interpreter','latex')
zlabel('$\tau$','Interpreter','latex')


%% Extra plots to check the quality of the identification

figure;
qqplot(A*p2-y)
grid on
axis equal
axis square

figure;
plot(y,A*p2,'.')
hold on
plot([min(y) max(y)],[min(y) max(y)],'--g','LineWidth',2)
grid on
xlabel('$y$','Interpreter','latex','FontSize',16)
ylabel('$\hat{y}$','Interpreter','latex','FontSize',16)
xlim([-0.25 0.25])
ylim([-0.25 0.25])
axis equal
axis square