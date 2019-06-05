init_point = [1.8 7 4.5];
minimal = [0.001 0.001 0];
maximum = [10 10 10];

options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');
opt_params = fmincon(@Zad6_PID_E_function, init_point, [],[],[],[], minimal, maximum, [], options);

disp("Kr = "+opt_params(1));
disp("Ti = "+opt_params(2));
disp("Td = "+opt_params(3));
err = Zad6_PID_E_function(opt_params);
disp("Err = "+err);