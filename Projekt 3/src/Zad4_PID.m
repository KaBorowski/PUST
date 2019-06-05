%Symulacja cyfroweo algorytmu PID oraz algorytmu DMC w wersji analitycznej
%bez ograniczeñ

clear;

Y_MIN = -2.6416;
Y_MAX = 0.0885;
%Z-N -> T=17 K=0.7
%Z-N nie bylo stabilne
%Nastawy w³asne
Kr = 0.35;
Ti = 5;
Td = 1;

save = 0;

Tp = 0.5;

r0 = Kr*(1+Tp/(2*Ti)+Td/Tp);
r1 = Kr*(Tp/(2*Ti)-2*Td/Tp-1);
r2 = Kr*Td/Tp;

kk=1500; 
u(1:kk)=0; y(1:kk)=0;
%Y = od -2.6 do 0.0885
yzad(1:9)=0; yzad(10:299)=0.08; yzad(300:599)=-1; yzad(600:899)=-0.25; yzad(900:1199)=-2; yzad(1200:kk) = 0;
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
stairs(yzad);
plot(u);
plot(y);
legend('yzad(k)', 'u(k)', 'y(k)', 'Location', 'northeast');
ylabel('Warto¶æ sygna³u');
title(['Regulator PID K=' num2str(Kr) ', Ti=' num2str(Ti) ', Td=' num2str(Td) '   Wska¼nik jako¶ci regulacji E=' num2str(E)]);
xlabel('k');
hold off;

if save == 1
    u_data = [(1:kk)'-1 u'];
    y_data = [(1:kk)'-1 y'];
%     yzad_data = [(1:kk)'-1 yzad'];
% 
%     dlmwrite('../data/Zad4/trajektoria.csv', yzad_data, '\t')
    dlmwrite(strcat('../data/Zad4/PID/input_K=', num2str(Kr), 'Ti=',num2str(Ti),'Td=',num2str(Td),'E=',num2str(E),'.csv'), u_data, '\t');
    dlmwrite(strcat('../data/Zad4/PID/output_K=', num2str(Kr), 'Ti=',num2str(Ti),'Td=',num2str(Td),'E=',num2str(E),'.csv'), y_data, '\t');

end







