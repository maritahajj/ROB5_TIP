clear;
close all;

run("definit_param.m");
run("simule_systeme.m");
run('identifie_parametres.m');

disp("paramètre trouvé : ");
disp(x);

disp("Erreur avec les paramètres réels : ");
x_err = [];
for k=1:size(x)
    x_err = [x_err; (abs(x(k)-x_reel(k))/x_reel(k))*100];
end

disp(x_err);