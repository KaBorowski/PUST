init_point = [45 5 42];
minimal = [0.001 0.001 0.001];
maximum = [100 100 100];

options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');
opt_params = fmincon(@Zad6_PID_E_function, init_point, [],[],[],[], minimal, maximum, [], options);

disp("N = "+opt_params(1));
disp("Nu = "+opt_params(2));
disp("lambda = "+opt_params(3));
err = Zad6_PID_E_function(opt_params);
disp("Err = "+err);