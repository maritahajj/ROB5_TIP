clear; close all; clc;

%% Donnees et regresseur
load('releve_vit_cste_axe2.mat');            % t, q2, qpfil2, ifil2, ...
t  = t(:);
q  = q2(:);
qp = qpfil2(:);
y  = ifil2(:);

A = regresseur(q, qp);
[N, n] = size(A);
noms = {'G (A)', 'F_v (A.s/rad)', 'F_s (A)', 'off (A)'};
fen = (1:N)' > N/2;                          % fenetre de calcul des fluctuations

dt = diff(t);
fprintf('N = %d echantillons sur %.1f s, periode d''echantillonnage de %.4f a %.4f s\n', ...
        N, t(end), min(dt(dt > 0)), max(dt));
ch = find(diff(sign(qp)) ~= 0);              % fins de segments (changements de sens)
fprintf('%d segments a vitesse constante\n', numel(ch) + 1);

%% Reference hors ligne : moindres carres (TP2)
theta_mc = A \ y;
e_mc = y - A*theta_mc;
R0 = mean(e_mc.^2);                          % variance du residu -> choix de R
fprintf('\n--- Moindres carres hors ligne ---\n');
fprintf('theta_MC = [G Fv Fs off] = [%.4f %.5f %.4f %.4f]\n', theta_mc);
fprintf('rms residu = %.4f A (R0 = %.2e A^2), cond(A) = %.1f\n', sqrt(R0), R0, cond(A));

%% RLS : reglage retenu (lambda = 1, P1 = 1e2*I)
fprintf('\n--- RLS ---\n');
lambda = 1;
P1 = 1e2*eye(n);
[TH_rls, ep_rls, ~, trP_rls] = rls_estimation(A, y, lambda, P1);
afficher_bilan('RLS lambda=1, P1=1e2*I', bilan(TH_rls, ep_rls, theta_mc, fen));
tracer_parametres(t, {TH_rls}, {'RLS (\lambda = 1, P_1 = 10^2 I)'}, theta_mc, noms, ...
                  'RLS : parametres estimes au cours du temps');

% Identifiabilite : estimations a la fin des trois premiers segments
fprintf('Estimations a la fin des segments 1, 2, 3 :  [t G Fv Fs off]\n');
disp([t(ch(1:3)), TH_rls(ch(1:3), :)]);
fprintf('cond(A) sur les segments 1-2 : %.2e | sur les segments 1-3 : %.1f\n', ...
        cond(A(1:ch(2), :)), cond(A(1:ch(3), :)));

% Avec lambda = 1 et P1 grand, theta_k = MC hors ligne sur les k premiers echantillons
k = ch(10);
fprintf('max|theta_RLS(k) - MC(1:k)| = %.1e (k = %d)\n', ...
        max(abs(TH_rls(k, :)' - A(1:k, :)\y(1:k))), k);

%% RLS : effet de P1 (lambda = 1)
liste_sigma = [1e-6 1e-4 1e-2 1 1e2 1e4];
TH_s = cell(size(liste_sigma));
leg_s = cell(size(liste_sigma));
fprintf('\nEffet de P1 = sigma*I :\n');
for i = 1:numel(liste_sigma)
    [TH_s{i}, ep] = rls_estimation(A, y, 1, liste_sigma(i)*eye(n));
    leg_s{i} = sprintf('\\sigma = 10^{%d}', round(log10(liste_sigma(i))));
    afficher_bilan(sprintf('RLS sigma=%.0e', liste_sigma(i)), bilan(TH_s{i}, ep, theta_mc, fen));
end
tracer_parametres(t, TH_s, leg_s, theta_mc, noms, 'RLS : effet de P_1 = \sigma I (\lambda = 1)');

%% RLS : effet du facteur d'oubli (P1 = 1e2*I)
liste_lambda = [1 0.9999 0.9995 0.999 0.99];
TH_l = cell(size(liste_lambda));
trP_l = cell(size(liste_lambda));
leg_l = cell(size(liste_lambda));
fprintf('\nEffet de lambda (memoire ~ 1/(1-lambda) echantillons) :\n');
for i = 1:numel(liste_lambda)
    [TH_l{i}, ep, ~, trP_l{i}] = rls_estimation(A, y, liste_lambda(i), 1e2*eye(n));
    leg_l{i} = sprintf('\\lambda = %g', liste_lambda(i));
    afficher_bilan(sprintf('RLS lambda=%g', liste_lambda(i)), bilan(TH_l{i}, ep, theta_mc, fen));
    fprintf('%28s max trace(P) apres le 3e segment = %.2e\n', '', max(trP_l{i}(ch(3):end)));
end
tracer_parametres(t, TH_l, leg_l, theta_mc, noms, 'RLS : effet du facteur d''oubli \lambda');

figure('Name', 'RLS : trace de P', 'Color', 'w');
for i = 1:numel(liste_lambda)
    loglog(t, trP_l{i}, 'LineWidth', 1); hold on;
end
grid on; xlim([1e-2, t(end)]);
xlabel('t (s)'); ylabel('trace(P_k)'); legend(leg_l, 'Location', 'best');
title('RLS : explosion de la covariance quand \lambda < 1');

%% Kalman : reglage retenu
fprintf('\n--- Filtre de Kalman ---\n');
% Verification : Kalman avec Q = 0 et R = 1 <=> RLS avec lambda = 1 (meme P1)
TH_eq = kalman_estimation(A, y, zeros(n), 1, 1e2*eye(n));
fprintf('Kalman(Q=0, R=1) vs RLS(lambda=1) : max ecart = %.1e\n', max(abs(TH_eq(:) - TH_rls(:))));

R  = R0;                                     % variance du residu des MC
D  = diag(theta_mc.^2);                      % Q a l'echelle de chaque parametre
Q  = 1e-10*D;
P1k = eye(n);
[TH_kf, ep_kf, ~, trP_kf] = kalman_estimation(A, y, Q, R, P1k);
afficher_bilan('Kalman Q=1e-10*D, R=R0', bilan(TH_kf, ep_kf, theta_mc, fen));
tracer_parametres(t, {TH_rls, TH_kf}, {'RLS (\lambda = 1)', 'Kalman (Q = 10^{-10} D, R = R_0)'}, ...
                  theta_mc, noms, 'Kalman et RLS : parametres estimes');

%% Kalman : effet de Q (R = R0)
liste_rho = [0 1e-10 1e-9 1e-8 1e-7 1e-6];
TH_q = cell(size(liste_rho));
leg_q = cell(size(liste_rho));
fprintf('\nEffet de Q = rho2*diag(theta_MC.^2) (R = R0) :\n');
for i = 1:numel(liste_rho)
    [TH_q{i}, ep] = kalman_estimation(A, y, liste_rho(i)*D, R0, P1k);
    leg_q{i} = sprintf('\\rho^2 = %.0e', liste_rho(i));
    afficher_bilan(sprintf('Kalman rho2=%.0e', liste_rho(i)), bilan(TH_q{i}, ep, theta_mc, fen));
end
tracer_parametres(t, TH_q, leg_q, theta_mc, noms, 'Kalman : effet de Q (R = R_0)');

% Q identique pour tous les parametres : F_v (40 fois plus petit) est le plus perturbe
[TH_qu, ep] = kalman_estimation(A, y, 1e-9*eye(n), R0, P1k);
afficher_bilan('Kalman Q=1e-9*I (uniforme)', bilan(TH_qu, ep, theta_mc, fen));

%% Kalman : effet de R (Q = 1e-8*D)
liste_R = R0*[1e-2 1e-1 1 10 100];
TH_r = cell(size(liste_R));
leg_r = cell(size(liste_R));
fprintf('\nEffet de R (Q = 1e-8*D) :\n');
for i = 1:numel(liste_R)
    [TH_r{i}, ep] = kalman_estimation(A, y, 1e-8*D, liste_R(i), P1k);
    leg_r{i} = sprintf('R = %g R_0', liste_R(i)/R0);
    afficher_bilan(sprintf('Kalman R=%g*R0', liste_R(i)/R0), bilan(TH_r{i}, ep, theta_mc, fen));
end
tracer_parametres(t, TH_r, leg_r, theta_mc, noms, 'Kalman : effet de R (Q = 10^{-8} D)');

% Seul le rapport Q/R compte (avec P1/R) : multiplier Q, R et P1 par 10 ne change rien
TH_a = kalman_estimation(A, y, 1e-8*D, R0, P1k);
TH_b = kalman_estimation(A, y, 1e-7*D, 10*R0, 10*P1k);
fprintf('Q, R, P1 multiplies par 10 : max ecart = %.1e\n', max(abs(TH_a(:) - TH_b(:))));

%% Comparaison RLS / Kalman a capacite de suivi comparable
% RLS lambda = 0.999 et Kalman Q = 1e-8*D donnent une erreur a priori voisine
[TH_l999, ep_l999, ~, trP_l999] = rls_estimation(A, y, 0.999, 1e2*eye(n));
[TH_kf8, ep_kf8, ~, trP_kf8] = kalman_estimation(A, y, 1e-8*D, R0, P1k);
fprintf('\nComparaison a capacite de suivi comparable :\n');
afficher_bilan('RLS lambda=0.999', bilan(TH_l999, ep_l999, theta_mc, fen));
afficher_bilan('Kalman Q=1e-8*D, R=R0', bilan(TH_kf8, ep_kf8, theta_mc, fen));
fprintf('max trace(P) apres le 3e segment : RLS %.2e | Kalman %.2e\n', ...
        max(trP_l999(ch(3):end)), max(trP_kf8(ch(3):end)));
tracer_parametres(t, {TH_rls, TH_l999, TH_kf8}, ...
                  {'RLS \lambda = 1 (= Kalman Q = 0)', 'RLS \lambda = 0.999', 'Kalman Q = 10^{-8} D'}, ...
                  theta_mc, noms, 'Comparaison RLS / Kalman');
