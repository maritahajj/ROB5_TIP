function A = regresseur(q, qp)

q  = q(:);
qp = qp(:);
A  = [cos(q), qp, sign(qp), ones(size(q))];

end
