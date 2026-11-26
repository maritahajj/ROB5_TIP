function tracer_parametres(t, liste_TH, legendes, theta_mc, noms, titre)

figure('Name', titre, 'Color', 'w');
for j = 1:numel(noms)
    subplot(2, 2, j);
    hold on; grid on;
    for m = 1:numel(liste_TH)
        plot(t, liste_TH{m}(:, j), 'LineWidth', 1);
    end
    plot([1e-2, t(end)], theta_mc(j)*[1, 1], 'k--', 'LineWidth', 1.2);
    set(gca, 'XScale', 'log');                 % echantillonnage non uniforme
    xlim([1e-2, t(end)]);
    ylim(theta_mc(j) + [-1.5, 1.5]*abs(theta_mc(j)));
    xlabel('t (s)');
    ylabel(noms{j});
end

legend([legendes, {'MC hors ligne'}], 'Location', 'best');
sgtitle(titre);

end
