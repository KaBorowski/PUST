function U = getU(Y)

init_point = 0;
minimal = -1;
maximum = 1;

% options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');
U = fmincon(@(U)get_static_U_function(U,Y), init_point, [],[],[],[], minimal, maximum);

end