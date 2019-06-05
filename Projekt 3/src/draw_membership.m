REG_COUNT = 2;
save = 0;
[Kr, Ti, Td, y_beg] = Zad5_local_PIDS_params(REG_COUNT);
Y_MIN = -2.6416;
Y_MAX = 0.0885;
x=Y_MIN:0.01:Y_MAX;
figure;
hold on;
grid minor;

for i=1:REG_COUNT
    membership = membership_function(x, y_beg(i), REG_COUNT);
    plot(x,membership);
    if save == 1
        membership_data = [x' membership'];
        dlmwrite(strcat('../data/Zad6/PID/membership_REG_COUNT=',num2str(REG_COUNT),'lokalPID=',num2str(i),'.csv'), membership_data, '\t');
    end
end
xlim([Y_MIN, Y_MAX]);