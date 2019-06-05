kk = 300;
u(1:kk) = 0;
z(1:kk) = 0;
y(1:kk) = 0;

u(9:kk)=1;
% z(9:kk)=1;
    
for k=9:kk

    y(k)=symulacja_obiektu10y(u(k-7),u(k-8),z(k-3),z(k-4),y(k-1),y(k-2));
end
hold on;
plot(y);
plot(u);
plot(z);
%legend('Odp. na skok 3 -> 3.2', 'Odp. na skok 3 -> 4', 'Odp. na skok 3 -> 2', 'Location', 'southeast');
title('Odpowiedz na skok jednostkowy', 'FontName', 'Helvetica');
xlabel('k');
grid on;
grid minor;
hold off;

u_data = [(1:(183-8))'-1 u(9:183)'];
y_data = [(1:(183-8))'-1 y(9:183)'];
z_data = [(1:(183-8))'-1 z(9:183)'];

% u_data = [(1:(91-8))'-1 u(9:91)'];
% y_data = [(1:(91-8))'-1 y(9:91)'];
% z_data = [(1:(91-8))'-1 z(9:91)'];


% dlmwrite(strcat('data/Zad3/zad3_skok_sterowania_obciete_u.csv'), u_data, '\t');
% dlmwrite(strcat('data/Zad3/zad3_skok_sterowania_obciete_y.csv'), y_data, '\t');
% dlmwrite(strcat('data/Zad3/zad3_skok_sterowania_obciete_z.csv'), z_data, '\t');

% dlmwrite(strcat('data/Zad3/zad3_skok_zaklocenia_obciete_u.csv'), u_data, '\t');
% dlmwrite(strcat('data/Zad3/zad3_skok_zaklocenia_obciete_y.csv'), y_data, '\t');
% dlmwrite(strcat('data/Zad3/zad3_skok_zaklocenia_obciete_z.csv'), z_data, '\t');