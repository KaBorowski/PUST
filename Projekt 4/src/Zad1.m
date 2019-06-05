kk = 300;
u = zeros(4, kk);
y = zeros(3, kk);
% u1(1:kk) = 0;
% u2(1:kk) = 0;
% u3(1:kk) = 0;
% u4(1:kk) = 0;
% y1(1:kk) = 0;
% y2(1:kk) = 0;
% y3(1:kk) = 0;

    
for k=5:kk
%     [y1(k),y2(k),y3(k)]=symulacja_obiektu10(u1(k-1),u1(k-2),u1(k-3),u1(k-4), u2(k-1),u2(k-2),u2(k-3),u2(k-4), u3(k-1),u3(k-2),u3(k-3),u3(k-4), u4(k-1),u4(k-2),u4(k-3),u4(k-4), y1(k-1),y1(k-2),y1(k-3),y1(k-4), y2(k-1),y2(k-2),y2(k-3),y2(k-4), y3(k-1),y3(k-2),y3(k-3),y3(k-4));
    [y(1,k),y(2,k),y(3,k)]=symulacja_obiektu10(u(1,k-1),u(1,k-2),u(1,k-3),u(1,k-4),...
         u(2,k-1),u(2,k-2),u(2,k-3),u(2,k-4), u(3,k-1),u(3,k-2),u(3,k-3),u(3,k-4),...
         u(4,k-1),u(4,k-2),u(4,k-3),u(4,k-4), y(1,k-1),y(1,k-2),y(1,k-3),y(1,k-4),...
         y(2,k-1),y(2,k-2),y(2,k-3),y(2,k-4), y(3,k-1),y(3,k-2),y(3,k-3),y(3,k-4));
end
hold on;
plot(y(1,:));
plot(y(2,:));
plot(y(3,:));
plot(u(1,:));
plot(u(2,:));
plot(u(3,:));
plot(u(4,:));
% plot(y);
% plot(u);

legend('y1', 'y2', 'y3','u1','u2','u3','u4', 'Location', 'southeast');
title('Punkt pracy', 'FontName', 'Helvetica');
xlabel('k');
grid on;
grid minor;
hold off;
% u_data = [(1:kk)'-1 u'];
% y_data = [(1:kk)'-1 y'];

% dlmwrite(strcat('../data/Zad1/zad1_u.csv'), u_data, '\t');
% dlmwrite(strcat('../data/Zad1/zad1_y.csv'), y_data, '\t');
