%Symulacja cyfroweo algorytmu PID oraz algorytmu DMC w wersji analitycznej
%bez ograniczeñ

clear;

%Nastawy w³asne
Kr = 2;
Ti = 999999;
Td = 0;

Tp = 0.5;

r0 = Kr*(1+Tp/(2*Ti)+Td/Tp);
r1 = Kr*(Tp/(2*Ti)-2*Td/Tp-1);
r2 = Kr*Td/Tp;

kk=600; 
u(1:kk)=0; y(1:kk)=0;
%Y = od -2.6 do 0.0885
yzad(1:9)=0; yzad(10:149)=0.08; yzad(150:299)=0.02; yzad(300:449)=0.05; yzad(450:kk)=0;
e(1:kk)=0; 

E=0; %wskaznik jakosci regulacji

for k=7:kk
     y(k)=symulacja_obiektu10y(u(k-5),u(k-6),y(k-1),y(k-2));
     e(k)=yzad(k)-y(k);
     E=E+e(k)^2;
     u(k)=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);

     if u(k) < -1
         u(k) = -1;
     end
     if u(k) > 1
         u(k) = 1;
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
title(['Regulator PID K=' num2str(Kr) ', Ti=' num2str(Ti) ', Td=' num2str(Td) '   Wska¼nik jako¶ci regulacji E=' num2str(E)]);
xlabel('k');
hold off;







