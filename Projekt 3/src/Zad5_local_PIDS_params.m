function [Kr, Ti, Td, y_beg] = Zad5_local_PIDS_params(REG_COUNT)

Y_MIN = -2.6416;
Y_MAX = 0.0885;

JUMP = 0.1;

Kr = zeros(1,REG_COUNT);
Ti = zeros(1,REG_COUNT);
Td = zeros(1,REG_COUNT);
y_beg = zeros(1,REG_COUNT);

delta_y_beg = (Y_MAX-Y_MIN)/(REG_COUNT-1);

for i=1:REG_COUNT
    if i==1
        y_beg(i)=Y_MIN;
    else
        y_beg(i)=y_beg(i-1)+delta_y_beg;
    end
    
    if y_beg(i)>(Y_MAX-JUMP)
        y_beg(i) = Y_MAX - JUMP;
    end
    
    if i==REG_COUNT
       y_beg(i)=Y_MAX;
       JUMP = -0.08;
    end

    init_point = [0.35 5 1];
    minimal = [0.001 0.001 0];
    maximum = [10 10 10];
    % options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');
    opt_params = fmincon(@(params)Zad5_PID_function(params, y_beg(i), JUMP), init_point, [],[],[],[], minimal, maximum);
    Kr(i) = opt_params(1);
    Ti(i) = opt_params(2);
    Td(i) = opt_params(3);
    
end

disp(y_beg);

% disp("Kr = "+Kr);
% disp("Ti = "+Ti);
% disp("Td = "+Td);
% err = Zad5_PID_function(opt_params);
% disp("Err = "+err);
end