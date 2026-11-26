function s = bilan(TH, e_pre, theta_mc, fen)

s.final = TH(end, :)';
s.ecart = 100*(s.final - theta_mc)./abs(theta_mc);
s.fluct = 100*std(TH(fen, :), 0, 1)'./abs(theta_mc);
s.rms   = sqrt(mean(e_pre.^2));

end
