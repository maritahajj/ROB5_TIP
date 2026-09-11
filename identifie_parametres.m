Phi = @(x) [-x(1) x(2)-x(1) 0 -x(4) x(5)-x(4) 0 -x(7) 0 0;
           0 x(1)-x(2) x(3)-x(2) 0 x(4)-x(5) x(6)-x(5) 0 -x(8) 0;
           0 0 x(2)-x(3) 0 0 x(5)-x(6) 0 0 -x(9)];

list_idx = [5 10 50 100 150 200 300 500 700];
A = [];
Y = [];

for k=1:numel(list_idx)
    idx = list_idx(k);
     if(quanti == false)
        x = [alpha(idx) beta(idx) gamma(idx) vit_alpha(idx) vit_beta(idx) vit_gamma(idx) acc_alpha(idx) acc_beta(idx) acc_gamma(idx)];
     else
         x = [pos_q*round(alpha(idx)*1/pos_q) pos_q*round(beta(idx)*1/pos_q) pos_q*round(gamma(idx)*1/pos_q) vit_q*round(vit_alpha(idx)*1/vit_q) vit_q*round(vit_beta(idx)*1/vit_q) vit_q*round(vit_gamma(idx)*1/vit_q) acc_q*round(acc_alpha(idx)*1/acc_q) acc_q*round(acc_beta(idx)*1/acc_q) acc_q*round(acc_gamma(idx)*1/acc_q)];
     end
     if(filter == true)
         x = filtfilt([1 u-1], u, x);
     end

     A = [A ; Phi(x)];
     Y = [Y; -1;0;0];
end

x = A\Y;
