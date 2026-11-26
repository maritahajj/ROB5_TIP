function [TH, e_pre, e_post, trP] = kalman_estimation(A, y, Q, R, P1, theta0)

[N, n] = size(A);
if nargin < 6
    theta0 = zeros(n, 1);
end
theta = theta0(:);
P = P1;
I = eye(n);

TH = zeros(N, n);
e_pre = zeros(N, 1);
e_post = zeros(N, 1);
trP = zeros(N, 1);

for k = 1:N
    a = A(k, :);
    % Prediction
    P_pred = P + Q;                           % covariance a priori (theta_pred = theta)
    % Mise a jour
    e_pre(k) = y(k) - a*theta;                % erreur a priori
    S = a*P_pred*a' + R;                      % covariance de l'erreur a priori
    K = P_pred*a' / S;                        % gain de Kalman
    theta = theta + K*e_pre(k);
    P = (I - K*a)*P_pred;
    P = (P + P')/2;
    e_post(k) = y(k) - a*theta;               % erreur a posteriori
    TH(k, :) = theta';
    trP(k) = trace(P);
end
end
