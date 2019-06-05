init_point = [19 1 10];
minimal = [1 1 0.001];
maximum = [30 30 30];

% options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');
opt_params = fmincon(@DMC_E_function, init_point, [],[],[],[], minimal, maximum);

disp("N = "+floor(opt_params(1)));
disp("Nu = "+floor(opt_params(2)));
disp("lambda = "+opt_params(3));
err = DMC_E_function(opt_params);
disp("Err = "+err);