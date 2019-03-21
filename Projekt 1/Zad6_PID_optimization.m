params0 = [1.8 7 3.06];

options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');
opt_params = fmincon(@err_function, params0, [],[],[], [0.001 0.001 0.001 0], [10000 10000 1000 10000], [], options);

disp("Kr = "+opt_params(1));
disp("Ti = "+opt_params(2));
disp("Td = "+opt_params(3));
err = Zad6_PID_E_function(opt_params);
disp("Err = "+err);