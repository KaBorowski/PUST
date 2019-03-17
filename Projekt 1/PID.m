%Symulacja cyfroweo algorytmu PID oraz algorytmu DMC w wersji analitycznej
%bez ograniczeñ

clear;
set_params();

%Nastawy z eksperymentu Z-N
%Kr = 0.2934;
%Ti = 10.25;
%Td = 2.46;

%Nastawy w³asne
Kr = 0.187;
Ti = 7.68;
Td = 2.0;

Tp = 0.5;

r0 = Kr*(1+Tp/(2*Ti)+Td/Tp);
r1 = Kr*(Tp/(2*Ti)-2*Td/Tp-1);
r2 = Kr*Td/Tp;

kk=200; 
u(1:kk)=0; y(1:kk)=0;
yzad(1:9)=0; yzad(10:kk)=1; 
e(1:kk)=0; 

for k=13:kk
     y(k)=0.0476*u(k-11)+0.04249*u(k-12)+1.69*y(k-1)-0.7111*y(k-2);
     e(k)=yzad(k)-y(k);
     u(k)=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);  
end

figure;
hold on;
grid on; 
grid minor;
stairs(y);
stairs(u);
title('u');
xlabel('k');
stairs(y);
stairs(yzad, ':');
legend('yzad(k)', 'u(k)', 'y(k)', 'Location', 'northeast');
title('yzad, y');
xlabel('k');
hold off;








