%Wyznaczenie optymalnych parametrów transmitancji aproksymującej obiekt
clear;
fun = @zad3_err_function;
x0 = [100 20 0.4 3];
lb = [0.001 0.001 -10 0];
ub = [1000 1000 10 500];
[optim_params, E] = fmincon(fun, x0, [],[],[],[], lb, ub);
disp("T1 = "+optim_params(1));
disp("T2 = "+optim_params(2));
disp("K = "+optim_params(3));
disp("Td = "+floor(optim_params(4)));
[~, s, y] = zad3_err_function(optim_params);
disp("E = "+E);
plot(s); hold on; plot(y); title(['E = ' num2str(E)]);