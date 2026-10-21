function J = jacobien(theta, p)
    % question 2
    dp = 1e-6;
    J = zeros(3, 10);

    X0 = mod_geom(theta, p);

    for i = 1:10
        p_pert = p; 
        p_pert(i) = p_pert(i) + dp;
    
        X_pert = mod_geom(theta, p_pert);

        J(:, i) = (X_pert - X0) / dp; 
    end
end