% clear;
odp=load('odpowiedz_skokowa_dmc.mat');
s=odp.skok;

D = length(s);
Tp = 0.5;
%parametry DMC
N = 45;
Nu = 5;
lambda = 42; 

%Wyznaczanie macierzy predykcji
Mp = zeros(N,D-1);

for i = 1:N
    for j = 1:(D-1)
        if (i+j > D)
            Mp(i,j) = s(D) - s(j);
        else
            Mp(i,j) = s(i+j) - s(j);
        end
    end
end
       
%Wyznaczanie macierzy dynamicznej
M = zeros(N,Nu);

for j = 1:Nu
    for i = 1:N
        if i >= j
            M(i,j) = s(i-j+1);
        end
    end
end

%Wyznaczenie wspoczynnika K
K = (M'*M+lambda*eye(Nu))^-1*M';
K1 = K(1,1:N);
ke = sum(K1);

kk=600; 
u(1:kk)=3; y(1:kk)=0.9;
yzad(1:9)=0.9; yzad(10:149)=1.2; yzad(150:299)=0.5; yzad(300:449)=0.9; yzad(450:kk)=0.8;
du(1:D-1)=0;

E=0;

ku = K1*Mp;
for k=12:kk
     
    y(k)=symulacja_obiektu10Y(u(k-10),u(k-11),y(k-1),y(k-2)); %symulowany sygna� wyj�ciowy obiektu
    e = yzad(k) - y(k);
    E=E+e^2;
    deltau = ke*e-ku*du';
    for n=D-1:-1:2
        du(n)=du(n-1);
    end
    
    du(1)=deltau;
    u(k) = u(k-1) + du(1);
    
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
hold on
grid on; 
grid minor;
plot(u); 
plot(y);
plot(yzad); 
legend('u(k)', 'y(k)', 'yzad(k)', 'Location', 'northeast');
xlabel('k');
ylabel('Warto�� sygna�u');
title(['Regulator DMC N=' num2str(N) ', Nu=' num2str(Nu) ', lambda=' num2str(lambda) '   Wska�nik jako�ci regulacji=' num2str(E)]);
hold off;
