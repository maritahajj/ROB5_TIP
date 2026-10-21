% question 3
p_vrai = [0.2; 0.3; 0.2; 0.1; -0.1; 0.08; 0.1; 0.03; 0.025; 0.6];

theta_mesures = rand(3, 10) * pi;

J_empile = zeros(30, 10);

for k = 1:10
    theta_k = theta_mesures(:, k);
    J_k = jacobien(theta_k, p_vrai);
    indices = (k-1)*3 + 1 : k*3;
    J_empile(indices, :) = J_k;
end

rang_J = rank(J_empile);
disp(['Le rang de la matrice Jacobienne 30x10 est : ', num2str(rang_J)]);

% question 4
Y_m = zeros(30, 1);
for k = 1:10
    Y_m((k-1)*3+1 : k*3) = mod_geom(theta_mesures(:, k), p_vrai);
end

p_estime = [0.2; 0.25; 0.25; 0.15; -0.1; 0; 0; 0; 0; 0]; 

indices_libres = [2, 3, 4, 6, 7, 8, 9, 10]; 

max_iter = 20;
tolerance = 1e-6;

for iter = 1:max_iter
    Y_pred = zeros(30, 1);
    J_empile = zeros(30, 10);

    for k = 1:10
        idx = (k-1)*3+1 : k*3;
        Y_pred(idx) = mod_geom(theta_mesures(:, k), p_estime);
        J_empile(idx, :) = jacobien(theta_mesures(:, k), p_estime);
    end

    % Calcul du résidu (erreur entre les mesures et la prédiction)
    r = Y_m - Y_pred;

    J_reduit = J_empile(:, indices_libres);

    delta_p_reduit = J_reduit \ r; 

    p_estime(indices_libres) = p_estime(indices_libres) + delta_p_reduit;

    if norm(delta_p_reduit) < tolerance
        disp(['Convergence atteinte à l''itération ', num2str(iter)]);
        break;
    end
end

disp('Comparaison Paramètres Vrais vs Estimés :');
format shortG
disp([p_vrai, p_estime]);

% question 5
bruit_q = 0.017 * randn(3, 10);
theta_bruite = theta_mesures + bruit_q;

bruit_x = [0.005 * randn(2, 10); 0.017 * randn(1, 10)];

Y_m_bruite = zeros(30, 1);
for k = 1:10
    Y_m_bruite((k-1)*3+1 : k*3) = mod_geom(theta_mesures(:, k), p_vrai) + bruit_x(:, k);
end

p_estime_bruite = [0.2; 0.25; 0.25; 0.15; -0.1; 0; 0; 0; 0; 0]; 

for iter = 1:max_iter
    Y_pred = zeros(30, 1);
    J_empile = zeros(30, 10);

    for k = 1:10
        idx = (k-1)*3+1 : k*3;

        Y_pred(idx) = mod_geom(theta_bruite(:, k), p_estime_bruite);
        J_empile(idx, :) = jacobien(theta_bruite(:, k), p_estime_bruite);
    end

    r = Y_m_bruite - Y_pred;
    J_reduit = J_empile(:, indices_libres);
    delta_p_reduit = J_reduit \ r; 

    p_estime_bruite(indices_libres) = p_estime_bruite(indices_libres) + delta_p_reduit;

    if norm(delta_p_reduit) < tolerance
        break;
    end
end

disp('--- Paramètres Vrais vs Estimés avec Bruit (N=10) ---');
disp([p_vrai, p_estime_bruite]);
disp(['Erreur absolue moyenne : ', num2str(mean(abs(p_vrai - p_estime_bruite)))]);


% Test 5a
disp('--- TEST 5a : Influence du nombre de mesures (N=100) ---');
N = 100;

theta_100 = rand(3, N) * pi;
bruit_q_100 = 0.017 * randn(3, N);
theta_bruite_100 = theta_100 + bruit_q_100;

bruit_x_100 = [0.005 * randn(2, N); 0.017 * randn(1, N)];
Y_m_bruite_100 = zeros(3*N, 1);

for k = 1:N
    Y_m_bruite_100((k-1)*3+1 : k*3) = mod_geom(theta_100(:, k), p_vrai) + bruit_x_100(:, k);
end

p_estime_100 = [0.2; 0.25; 0.25; 0.15; -0.1; 0; 0; 0; 0; 0]; 

for iter = 1:20
    Y_pred = zeros(3*N, 1);
    J_empile = zeros(3*N, 10);

    for k = 1:N
        idx = (k-1)*3+1 : k*3;
        Y_pred(idx) = mod_geom(theta_bruite_100(:, k), p_estime_100);
        J_empile(idx, :) = jacobien(theta_bruite_100(:, k), p_estime_100);
    end

    r = Y_m_bruite_100 - Y_pred;
    J_reduit = J_empile(:, indices_libres);
    delta_p = J_reduit \ r; 

    p_estime_100(indices_libres) = p_estime_100(indices_libres) + delta_p;
    if norm(delta_p) < 1e-6, break; end
end

disp(['Erreur absolue moyenne avec N=10 (avant) : ', num2str(mean(abs(p_vrai - p_estime_bruite)))]);
disp(['Erreur absolue moyenne avec N=100 (maintenant) : ', num2str(mean(abs(p_vrai - p_estime_100)))]);


% Test 5b
disp('--- TEST 5b : Mauvais choix de mesures (Articulation 2 figée) ---');

theta_mal_excite = rand(3, 10) * pi;
theta_mal_excite(2, :) = 0.05 * rand(1, 10); 

Y_m_mal_excite = zeros(30, 1);
for k = 1:10
    Y_m_mal_excite((k-1)*3+1 : k*3) = mod_geom(theta_mal_excite(:, k), p_vrai);
end

p_estime_mal = [0.2; 0.25; 0.25; 0.15; -0.1; 0; 0; 0; 0; 0]; 

for iter = 1:20
    Y_pred = zeros(30, 1);
    J_empile = zeros(30, 10);

    for k = 1:10
        idx = (k-1)*3+1 : k*3;
        Y_pred(idx) = mod_geom(theta_mal_excite(:, k), p_estime_mal);
        J_empile(idx, :) = jacobien(theta_mal_excite(:, k), p_estime_mal);
    end

    r = Y_m_mal_excite - Y_pred;
    J_reduit = J_empile(:, indices_libres);

    delta_p = J_reduit \ r; 

    p_estime_mal(indices_libres) = p_estime_mal(indices_libres) + delta_p;
    if norm(delta_p) < 1e-6, break; end
end

disp('Paramètres estimés avec une mauvaise excitation (regarde l2 et th_o2) :');
disp([p_vrai, p_estime_mal]);


% Test 5c
disp('--- TEST 5c : Mauvaise estimation initiale ---');

p_estime_bad = [0.2; 5.0; -2.0; 3.0; -0.1; 2.5; -1.5; 8.0; -5.0; 3.14]; 

for iter = 1:50
    Y_pred = zeros(30, 1);
    J_empile = zeros(30, 10);

    for k = 1:10
        idx = (k-1)*3+1 : k*3;
        Y_pred(idx) = mod_geom(theta_mesures(:, k), p_estime_bad);
        J_empile(idx, :) = jacobien(theta_mesures(:, k), p_estime_bad);
    end

    r = Y_m - Y_pred; 
    J_reduit = J_empile(:, indices_libres);
    delta_p = J_reduit \ r; 

    p_estime_bad(indices_libres) = p_estime_bad(indices_libres) + delta_p;
    if norm(delta_p) < 1e-6
        disp(['Fausse convergence atteinte à l''itération ', num2str(iter)]);
        break; 
    end
end

disp('Paramètres trouvés après un mauvais départ (Minimum local ou divergence) :');
disp([p_vrai, p_estime_bad]);