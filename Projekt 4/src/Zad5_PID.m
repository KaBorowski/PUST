clear;
save_files = false;

K_init = [1 1 1];
K_min = [0 0 0];
K_max = [10 10 10];

Ti_init = [1 1 1];
Ti_min = [0 0 0];
Ti_max = [20 20 20];

Td_init = [0 0 0];
Td_min = [0 0 0];
Td_max = [1 1 1];

options = optimoptions('fmincon', 'Algorithm', 'sqp');
opt_params = fmincon(@(params)PID_function(params, false), [K_init, Ti_init, Td_init], ...
    [],[],[],[], [K_min, Ti_min, Td_min], [K_max, Ti_max, Td_max], [], options);

disp("K = "+opt_params(1:3));
disp("Ti = "+opt_params(4:6));
disp("Ti = "+opt_params(7:9));
err = PID_function(opt_params, true);
disp("Err = "+err);

if save_files == true
    
end