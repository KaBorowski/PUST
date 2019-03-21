%Symulacja cyfroweo algorytmu PID oraz algorytmu DMC w wersji analitycznej
%bez ograniczeñ

clear;

%Nastawy z eksperymentu Z-N  Kk=2.01 Tk=25.5
% Kr = 1.206;
% Ti = 12.75;
% Td = 3.06;

%Nastawy po optymalizacji
Kr = 3.8948;
Ti = 9.0552;
Td = 5.0646;

%Nastawy w³asne
% Kr = 1.8;
% Ti = 7;
% Td = 4.5;

Tp = 0.5;

r0 = Kr*(1+Tp/(2*Ti)+Td/Tp);
r1 = Kr*(Tp/(2*Ti)-2*Td/Tp-1);
r2 = Kr*Td/Tp;

kk=600; 
u(1:kk)=3; y(1:kk)=0.9;
yzad(1:9)=0.9; yzad(10:149)=1.2; yzad(150:299)=0.5; yzad(300:449)=0.9; yzad(450:kk)=0.8;
e(1:kk)=0; 

E=0; %wskaznik jakosci regulacji

for k=12:kk
     y(k)=symulacja_obiektu10Y(u(k-10),u(k-11),y(k-1),y(k-2));
     e(k)=yzad(k)-y(k);
     E=E+e(k)^2;
     u(k)=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);
     if (u(k) - u(k-1)) > 0.075
         u(k) = u(k-1)+0.075;
     end
     if (u(k) - u(k-1)) < -0.075
         u(k) = u(k-1)-0.075;
     end
     if u(k) < 2.7
         u(k) = 2.7;
     end
     if u(k) > 3.3
         u(k) = 3.3;
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

zad5_save = false;
zad6_save = true;

if(zad5_save)
%     yzad_data = [(1:kk)'-1 yzad'];
%     dlmwrite('y_zadane.csv', yzad_data, '\t');
    u_data = [(1:kk)'-1 u'];
    y_data = [(1:kk)'-1 y'];
    dlmwrite(strcat('data/Zad5/PID/Zad5_PID_input_K=',num2str(Kr),'Ti=',num2str(Ti),'Td=',num2str(Td),'E=',num2str(E),'.csv'), u_data, '\t');
    dlmwrite(strcat('data/Zad5/PID/Zad5_PID_output_K=',num2str(Kr),'Ti=',num2str(Ti),'Td=',num2str(Td),'E=',num2str(E), '.csv'), y_data, '\t');

end
if(zad6_save)
    u_data = [(1:kk)'-1 u'];
    y_data = [(1:kk)'-1 y'];
    dlmwrite(strcat('data/Zad6/PID/Zad6_PID_input_simulation=600_K=',num2str(Kr),'Ti=',num2str(Ti),'Td=',num2str(Td),'E=',num2str(E),'.csv'), u_data, '\t');
    dlmwrite(strcat('data/Zad6/PID/Zad6_PID_output_simulation=600_K=',num2str(Kr),'Ti=',num2str(Ti),'Td=',num2str(Td),'E=',num2str(E), '.csv'), y_data, '\t');
end







