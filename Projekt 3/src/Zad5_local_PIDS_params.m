function [Kr, Ti, Td] = Zad5_local_PIDS_params(REG_COUNT)

START = 0;
JUMP = 0.25;
Kr = zeros(1:REG_COUNT);
Ti = zeros(1:REG_COUNT);
Td = zeros(1:REG_COUNT);

for i=1:REG_COUNT
%     if i == 1
%         START=-1;
%     end
%     if i == REG_COUNT
%         START=1;
%         JUMP=-0.08;
%     end
    
    if START > 0
        JUMP = -0.05;
    end
    init_point = [0.35 5 1 START JUMP];
    minimal = [0.001 0.001 0 START JUMP];
    maximum = [20 20 20 START JUMP];
    % options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');
    opt_params = fmincon(@Zad5_PID_function, init_point, [],[],[],[], minimal, maximum);
    Kr(i) = opt_params(1);
    Ti(i) = opt_params(2);
    Td(i) = opt_params(3);
end


disp("Kr = "+Kr);
disp("Ti = "+Ti);
disp("Td = "+Td);
% err = Zad5_PID_function(opt_params);
% disp("Err = "+err);
end