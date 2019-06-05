kk = 50;
tt = 10;
u1(1:kk) = 0;
u2(1:kk) = 0;
u3(1:kk) = 0;
y1(1:kk) = 0;
y2(1:kk) = 0;
y3(1:kk) = 0;

u1(tt:kk) = 0.5;
u2(tt:kk) = -0.5;
u3(tt:kk) = 0.3;
    
for k=7:kk
    if u1(k)>1
        u1(k)=1;
    end
    if u1(k)<-1
        u1(k)=-1;
    end
    if u2(k)>1
        u2(k)=1;
    end
    if u2(k)<-1
        u2(k)=-1;
    end
    if u3(k)>1
        u3(k)=1;
    end
    if u3(k)<-1
        u3(k)=-1;
    end
    
    
    y1(k)=symulacja_obiektu10y(u1(k-5),u1(k-6),y1(k-1),y1(k-2));
    y2(k)=symulacja_obiektu10y(u2(k-5),u2(k-6),y2(k-1),y2(k-2));
    y3(k)=symulacja_obiektu10y(u3(k-5),u3(k-6),y3(k-1),y3(k-2));
end
hold on;
plot(y1);
plot(y2);
plot(y3);
plot(u1);
plot(u2);
plot(u3);
legend('Odp. na skok 0 -> 0.5', 'Odp. na skok 0 -> -0.5', 'Odp. na skok 0 -> 0.3', 'Location', 'southeast');
title('Punkt pracy', 'FontName', 'Helvetica');
xlabel('k');
grid on;
grid minor;
hold off;

% u1_data = [(1:kk)'-1 u1'];
% u2_data = [(1:kk)'-1 u2'];
% u3_data = [(1:kk)'-1 u3'];
% dlmwrite(strcat('../data/Zad2/zad2_u1.csv'), u1_data, '\t');
% dlmwrite(strcat('../data/Zad2/zad2_u2.csv'), u2_data, '\t');
% dlmwrite(strcat('../data/Zad2/zad2_u3.csv'), u3_data, '\t');
% y1_data = [(1:kk)'-1 y1'];
% y2_data = [(1:kk)'-1 y2'];
% y3_data = [(1:kk)'-1 y3'];
% dlmwrite(strcat('../data/Zad2/zad2_yu1.csv'), y1_data, '\t');
% dlmwrite(strcat('../data/Zad2/zad2_yu2.csv'), y2_data, '\t');
% dlmwrite(strcat('../data/Zad2/zad2_yu3.csv'), y3_data, '\t');


