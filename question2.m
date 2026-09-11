clear;
close all;

quanti = true;
pos_q = 10 * 1e-6;
vit_q = 0.1 * 1e-3;
acc_q = 1 * 1e-3;

run("definit_param.m");
run("simule_systeme.m");
run ("identifie_parametres.m");

disp("parametre trouve: ")
disp(x);

disp("Erreur avec les parametres réel:");
x_err = [];
for k=1:size(x)
    x_err = [x_err;(abs(x(k) - x_reel(k))/x_reel(k))*100];
end

disp(x_err);
