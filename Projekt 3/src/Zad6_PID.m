clear;
REG_COUNT = 2;
save = 0;

[Kr, Ti, Td, y_beg] = Zad5_local_PIDS_params(REG_COUNT);
PIDs_params = [Kr; Ti; Td; y_beg];

Y_MIN = -2.6416;
Y_MAX = 0.0885;

Tp = 0.5;

kk=1500; 
u(1:kk)=0; y(1:kk)=0;
yzad(1:9)=0; yzad(10:299)=0.08; yzad(300:599)=-1; yzad(600:899)=-0.25; yzad(900:1199)=-2; yzad(1200:kk) = 0;
e(1:kk)=0; 

input(1:REG_COUNT) = 0;
membership(1:REG_COUNT) = 0;

E=0; %wskaznik jakosci regulacji

for k=7:kk
     y(k)=symulacja_obiektu10y(u(k-5),u(k-6),y(k-1),y(k-2));
     e(k)=yzad(k)-y(k);
     E=E+e(k)^2;
     
     for i=1:REG_COUNT
         Kr = PIDs_params(1,i);
         Ti = PIDs_params(2,i);
         Td = PIDs_params(3,i);
            
         r0 = Kr*(1+Tp/(2*Ti)+Td/Tp);
         r1 = Kr*(Tp/(2*Ti)-2*Td/Tp-1);
         r2 = Kr*Td/Tp;
        
         input(i)=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);
         membership(i) = membership_function(y(k), PIDs_params(4,i), REG_COUNT);
     end
     
     for i=1:REG_COUNT
         u(k) = u(k) + membership(i)*input(i); 
     end
    
     u(k) = u(k)/sum(membership);

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
title(['Regulator PID rozmyty -> Regulatory lokalne = ' num2str(REG_COUNT) '   Wska¼nik jako¶ci regulacji E=' num2str(E)]);
xlabel('k');
hold off;

if save == 1
    u_data = [(1:kk)'-1 u'];
    y_data = [(1:kk)'-1 y'];
%     yzad_data = [(1:kk)'-1 yzad'];
% 
%     dlmwrite('../data/Zad4/trajektoria.csv', yzad_data, '\t')
    dlmwrite(strcat('../data/Zad6/PID/input_REG_COUNT=',num2str(REG_COUNT),'E=',num2str(E),'.csv'), u_data, '\t');
    dlmwrite(strcat('../data/Zad6/PID/output_REG_COUNT=',num2str(REG_COUNT),'E=',num2str(E),'.csv'), y_data, '\t');
end








