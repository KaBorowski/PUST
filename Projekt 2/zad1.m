kk = 300;
u(1:kk) = 0;
z(1:kk) = 0;
y(1:kk) = 0;

    
for k=9:kk

    y(k)=symulacja_obiektu10y(u(k-7),u(k-8),z(k-3),z(k-4),y(k-1),y(k-2));
end
hold on;
plot(y);
plot(u);
%legend('Odp. na skok 3 -> 3.2', 'Odp. na skok 3 -> 4', 'Odp. na skok 3 -> 2', 'Location', 'southeast');
title('Punkt pracy', 'FontName', 'Helvetica');
xlabel('k');
grid on;
grid minor;
hold off;
u_data = [(1:kk)'-1 u'];
y_data = [(1:kk)'-1 y'];
z_data = [(1:kk)'-1 z'];
dlmwrite(strcat('data/Zad1/zad1_u.csv'), u_data, '\t');
dlmwrite(strcat('data/Zad1/zad1_y.csv'), y_data, '\t');
dlmwrite(strcat('data/Zad1/zad1_z.csv'), z_data, '\t');
