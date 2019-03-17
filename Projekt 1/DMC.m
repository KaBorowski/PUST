clear;
odp=load('odpy2.mat');
s=odp.y;
s=s(26:400);
s=s-34;
s=s/20;

% K=0.2839;
% T=95;

%Wyznaczenie rzêdnych odpowiedzi skokowej obiektu
% G = tf(K, [T, 1], 'InputDelay', 12);
% Gd = c2d(G, Tp, 'zoh');
% s = step(Gd, Tp*(D-1));


D = length(s);
Tp = 1;
%parametry DMC
N = 300;
Nu = N;
lambda = 1; 
%lambda = 2; 

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

kk=2000; %iloœæ próbek

u(1:kk)=0; y(1:kk)=0;
yzad(1:10)=0; yzad(11:kk)=3;
du(1:D-1)=0;


ku = K1*Mp;
for k=14:kk
     
    y(k)=0.002642*u(k-13)+0.9907*y(k-1); %symulowany sygna³ wyjœciowy obiektu
    e = yzad(k) - y(k);
    deltau = ke*e-ku*du';
    for n=D-1:-1:2
        du(n)=du(n-1);
    end
    
    du(1)=deltau;
    u(k) = u(k-1) + du(1);

    
end

figure;
hold on
grid on; 
grid minor;
plot((0:length(u)-1)*Tp,u); 
plot((0:length(y)-1)*Tp,y);
plot((0:length(yzad)-1)*Tp,yzad); 
legend('u(k)', 'y(k)', 'yzad(k)', 'Location', 'northeast');
xlabel('czas');
ylabel('Wartoœæ sygna³u');
title(['Regulator DMC N=' num2str(N) ', Nu=' num2str(Nu) ', lambda=' num2str(lambda)]);
hold off;
