function [TH, e_pre, trP] = rls_estimation(A, y, lambda, P1)
[N, n] = size(A); theta = zeros(n,1); P=P1;
TH = zeros(N,n); e_pre = zeros(N,1); trP=zeros(N,1);

for k = 1:N
    a = A(k,:);
    e_pre(k) = y(k)-a*theta;
    K = P*a' / (lambda + a*P*a');
    P = (eye(n)-K*a)*P / lambda;
    P = (P+P')/2;
    theta = theta + K*e_pre(k);
    TH(k,:) = theta'; trP(k) = trace(P);
end

end