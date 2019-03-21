init_point = [45 5 42];
minimal = [0 0 0.001];
maximum = [150 150 150];

options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');
opt_params = fmincon(@Zad6_DMC_E_function, init_point, [],[],[],[], minimal, maximum, [], options);

disp("N = "+floor(opt_params(1)));
disp("Nu = "+floor(opt_params(2)));
disp("lambda = "+opt_params(3));
err = Zad6_DMC_E_function(opt_params);
disp("Err = "+err);