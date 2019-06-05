
mi_init = [1 1 1];
mi_min = [0 0 0];
mi_max = [10 10 10];

lambda_init = [1 1 1 1];
lambda_min = [0 0 0 0];
lambda_max = [100 100 100 100];

init_point = [1 1 1 1 1 1 1];
minimal = [0 0 0 0 0 0 0];
maximum = [20 20 20 100 100 100 100];

options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');
opt_params = fmincon(@DMC_function, [mi_init, lambda_init], ...
    [],[],[],[], [mi_min, lambda_min], [mi_max, lambda_max], [], options);

disp("MI = "+opt_params(1:3));
disp("lambda = "+opt_params(4:7));
err = DMC_function(opt_params);
disp("Err = "+err);