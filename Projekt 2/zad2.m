kk = 300;
tt = 20;
u1(1:kk) = 0;
u2(1:kk) = 0;
u3(1:kk) = 0;
z1(1:kk) = 0;
z2(1:kk) = 0;
z3(1:kk) = 0;
y1(1:kk) = 0;
y2(1:kk) = 0;
y3(1:kk) = 0;

sterowanie = 0;
zaklocenie = 1;

if sterowanie == 1
    u1(tt:kk) = 0.3;
    u2(tt:kk) = -0.1;
    u3(tt:kk) = 0.1;
end
if zaklocenie == 1
    z1(tt:kk) = 0.25;
    z2(tt:kk) = -0.1;
    z3(tt:kk) = 0.35;
end
    
for k=9:kk

    y1(k)=symulacja_obiektu10y(u1(k-7),u1(k-8),z1(k-3),z1(k-4),y1(k-1),y1(k-2));
    y2(k)=symulacja_obiektu10y(u2(k-7),u2(k-8),z2(k-3),z2(k-4),y2(k-1),y2(k-2));
    y3(k)=symulacja_obiektu10y(u3(k-7),u3(k-8),z3(k-3),z3(k-4),y3(k-1),y3(k-2));
end
hold on;
plot(y1);
plot(u1);
plot(y2);
plot(u2);
plot(y3);
plot(u3);
%legend('Odp. na skok 3 -> 3.2', 'Odp. na skok 3 -> 4', 'Odp. na skok 3 -> 2', 'Location', 'southeast');
title('Punkt pracy', 'FontName', 'Helvetica');
xlabel('k');
grid on;
grid minor;
hold off;
if sterowanie == 1
    u1_data = [(1:kk)'-1 u1'];
    u2_data = [(1:kk)'-1 u2'];
    u3_data = [(1:kk)'-1 u3'];
    dlmwrite(strcat('data/Zad2/zad2_u1.csv'), u1_data, '\t');
    dlmwrite(strcat('data/Zad2/zad2_u2.csv'), u2_data, '\t');
    dlmwrite(strcat('data/Zad2/zad2_u3.csv'), u3_data, '\t');
    y1_data = [(1:kk)'-1 y1'];
    y2_data = [(1:kk)'-1 y2'];
    y3_data = [(1:kk)'-1 y3'];
    dlmwrite(strcat('data/Zad2/zad2_yu1.csv'), y1_data, '\t');
    dlmwrite(strcat('data/Zad2/zad2_yu2.csv'), y2_data, '\t');
    dlmwrite(strcat('data/Zad2/zad2_yu3.csv'), y3_data, '\t');
end
if zaklocenie == 1
    z1_data = [(1:kk)'-1 z1'];
    z2_data = [(1:kk)'-1 z2'];
    z3_data = [(1:kk)'-1 z3'];
    dlmwrite(strcat('data/Zad2/zad2_z1.csv'), z1_data, '\t');
    dlmwrite(strcat('data/Zad2/zad2_z2.csv'), z2_data, '\t');
    dlmwrite(strcat('data/Zad2/zad2_z3.csv'), z3_data, '\t');
    y1_data = [(1:kk)'-1 y1'];
    y2_data = [(1:kk)'-1 y2'];
    y3_data = [(1:kk)'-1 y3'];
    dlmwrite(strcat('data/Zad2/zad2_yz1.csv'), y1_data, '\t');
    dlmwrite(strcat('data/Zad2/zad2_yz2.csv'), y2_data, '\t');
    dlmwrite(strcat('data/Zad2/zad2_yz3.csv'), y3_data, '\t');
end
