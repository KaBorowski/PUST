
mi_init = [1 1 1];
mi_min = [0 0 0];
mi_max = [10 10 10];

lambda_init = [1 1 1 1];
lambda_min = [0 0 0 0];
lambda_max = [10 10 10 10];

options = optimoptions('fmincon', 'Algorithm', 'sqp');
opt_params = fmincon(@(params)DMC_function(params, false), [mi_init, lambda_init], ...
    [],[],[],[], [mi_min, lambda_min], [mi_max, lambda_max], [], options);

disp("MI = "+opt_params(1:3));
disp("lambda = "+opt_params(4:7));
err = DMC_function(opt_params, true);
disp("Err = "+err);