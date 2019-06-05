clear;

save_files = 0;
kk = 150;

u1(1:kk) = 0;
u2(1:kk) = 0;
u3(1:kk) = 0;
u4(1:kk) = 0;
y1(1:kk) = 0;
y2(1:kk) = 0;
y3(1:kk) = 0;
s = zeros(3,kk,4);
position = 0;
figure;
hold on;
for j=1:3
    for i=1:4
        u1(1:kk) = 0;
        u2(1:kk) = 0;
        u3(1:kk) = 0;
        u4(1:kk) = 0;
        eval(strcat('u',num2str(i),'(1:kk)=1;'));
        position = position + 1;
        y1(1:kk) = 0;
        y2(1:kk) = 0;
        y3(1:kk) = 0;
        for k=5:kk
            [y1(k),y2(k),y3(k)]=symulacja_obiektu10(u1(k-1),u1(k-2),u1(k-3),u1(k-4), u2(k-1),u2(k-2),u2(k-3),u2(k-4), u3(k-1),u3(k-2),u3(k-3),u3(k-4), u4(k-1),u4(k-2),u4(k-3),u4(k-4), y1(k-1),y1(k-2),y1(k-3),y1(k-4), y2(k-1),y2(k-2),y2(k-3),y2(k-4), y3(k-1),y3(k-2),y3(k-3),y3(k-4));
        end
        eval(strcat('s(j,:,i)=y', num2str(j),';'));
        subplot(3,4,position);
        hold on;
        eval(strcat('plot(y',num2str(j),');'));
        grid on;
        ylim([0,2]);
        title(strcat('s^{',num2str(j),',',num2str(i),'}'));
        ylabel(strcat('y_{',num2str(j),'}'));
        xlabel('k');
        legend(strcat('y_{',num2str(j),'}'));
        hold off;
    end
end
hold off;
if save_files == 1
    matlab2tikz('../data/Zad2/odp_skok.tex', 'showInfo', false);
    save('../data/Zad2/odp', 's');
end


