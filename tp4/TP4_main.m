clear; close all; clc;
load('releve_vit_cste_axe2.mat');

t = t(:); q=q2(:); qp=qpfil2(:); y=ifil2(:); 
figure;
subplot(3,1,1); plot(q); ylabel('q2');
subplot(3,1,2); plot(qp); ylabel('qpfil2');
subplot(3,1,3); plot(y); ylabel('ifil2');

A = [cos(q),qp, sign(qp), ones(size(q))];
rank(A), cond(A)

theta_mc = A\ y
R0 = mean((y-A*theta_mc).^2)

% Estimation RLS
[TH, ep] = rls_estimation(A,y,1,100*eye(4));
noms = {'G','Fv','Fs','off'};
figure;
for j=1:4
    subplot(2,2,j); semilogx(t, TH(:,j)); hold on;
    semilogx(t, theta_mc(j)*ones(size(t)),'k--'); title(noms{j});
    ylim(theta_mc(j)+[-1.5 1.5]*abs(theta_mc(j)));
end
TH(end,:)