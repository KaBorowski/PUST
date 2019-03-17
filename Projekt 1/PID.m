%Symulacja cyfroweo algorytmu PID oraz algorytmu DMC w wersji analitycznej
%bez ograniczeñ

clear;

%Nastawy z eksperymentu Z-N


%Nastawy w³asne
Kr = 1;
Ti = 99999;
Td = 0;

Tp = 0.5;

r0 = Kr*(1+Tp/(2*Ti)+Td/Tp);
r1 = Kr*(Tp/(2*Ti)-2*Td/Tp-1);
r2 = Kr*Td/Tp;

kk=200; 
u(1:kk)=3; y(1:kk)=0.9;
yzad(1:19)=0.9; yzad(20:kk)=1.2; 
e(1:kk)=0; 

for k=12:kk
     y(k)=symulacja_obiektu10Y(u(k-10),u(k-11),y(k-1),y(k-2));
     e(k)=yzad(k)-y(k);
     u(k)=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);
     if u(k) < 2.7
         u(k) = 2.7;
     end
     if u(k) > 3.3
         u(k) = 3.3;
     end
     if (u(k) - u(k-1)) > 0.075
         u(k) = u(k-1)+0.075;
     end
     if (u(k) - u(k-1)) < -0.075
         u(k) = u(k-1)-0.075;
     end
end

figure;
hold on;
grid on; 
grid minor;
stairs(y);
stairs(u);
stairs(y);
stairs(yzad, ':');
legend('yzad(k)', 'u(k)', 'y(k)', 'Location', 'northeast');
ylabel('Warto¶æ sygna³u');
title(['Regulator PID K=' num2str(Kr) ', Ti=' num2str(Ti) ', Td=' num2str(Td)]);
xlabel('k');
hold off;








