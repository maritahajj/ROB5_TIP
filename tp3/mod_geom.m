function X = mod_geom(theta, p)
    % question 1
    l0 = p(1); l1 = p(2); l2 = p(3); l3 = p(4);
    th_o1 = p(5); th_o2 = p(6); th_o3 = p(7);
    xc = p(8); yc = p(9); alphac = p(10);

    q1 = theta(1) + th_o1;
    q2 = theta(2) + th_o2;
    q3 = theta(3) + th_o3;
    
    c1 = cos(q1);             s1 = sin(q1);
    c12 = cos(q1 + q2);       s12 = sin(q1 + q2);
    c123 = cos(q1 + q2 + q3); s123 = sin(q1 + q2 + q3);
    
    x_R0 = l1*c1 + l2*c12 + l3*c123;
    y_R0 = l0 + l1*s1 + l2*s12 + l3*s123;
    alpha_R0 = q1 + q2 + q3;
    
    c_ac = cos(alphac);
    s_ac = sin(alphac);
    
    xm = c_ac * (x_R0 - xc) + s_ac * (y_R0 - yc);
    ym = -s_ac * (x_R0 - xc) + c_ac * (y_R0 - yc);
    alpham = alpha_R0 - alphac;

    X = [xm; ym; alpham];
end