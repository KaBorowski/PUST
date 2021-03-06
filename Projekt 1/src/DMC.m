clear;
odp=load('data/odpowiedz_skokowa_dmc.mat');
s=odp.skok;

D = length(s);
Tp = 0.5;
%parametry DMC wlasne
N = 45;
Nu = 5;
lambda = 42; 

%parametry DMC po optymalizacji
% N = 45;
% Nu = 5;
% lambda = 41.6529;

zaklocenie = 0;


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

%liczenie macierzy zaklocenia

if zaklocenie==1
     Mzp=zeros(N,Dz-1);
     for i=1:N
        for j=1:Dz-1
           if i+j<=Dz
              Mzp(i,j)=sz(i+j)-sz(j);
           else
              Mzp(i,j)=sz(Dz)-sz(j);
           end      
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
ku = K1*Mp;

if zaklocenie==1
    kz = K1*Mzp;
end

kk=600; 
u(1:kk)=3; y(1:kk)=0.9; z(1:kk)=0;
yzad(1:9)=0.9; yzad(10:149)=1.2; yzad(150:299)=0.5; yzad(300:449)=0.9; yzad(450:kk)=0.8;
du(1:D-1)=0;

if zaklocenie==1
    dz(1:Dz-1)=0;
end

E=0;


for k=12:kk
     
    y(k)=symulacja_obiektu10Y(u(k-10),u(k-11),y(k-1),y(k-2)); %symulowany sygna� wyj�ciowy obiektu
    e = yzad(k) - y(k);
    E=E+e^2;
    
    if zaklocenie==1
       for n=Dz-1:-1:2
         dz(n)=dz(n-1);
       end
       dz(1)=z(k)-z(k-1);
    end 
    
    deltau = ke*e-ku*du';
    
    if zaklocenie==1
      deltau = deltau-kz*dz';
    end
    
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
plot(u); 
plot(y);
plot(yzad); 
legend('u(k)', 'y(k)', 'yzad(k)', 'Location', 'northeast');
xlabel('k');
ylabel('Warto�� sygna�u');
title(['Regulator DMC N=' num2str(N) ', Nu=' num2str(Nu) ', lambda=' num2str(lambda) '   Wska�nik jako�ci regulacji=' num2str(E)]);
hold off;

zad5_save = false;
zad6_save = false;

if(zad5_save)
%     yzad_data = [(1:kk)'-1 yzad'];
%     dlmwrite('y_zadane.csv', yzad_data, '\t');
    u_data = [(1:kk)'-1 u'];
    y_data = [(1:kk)'-1 y'];
    dlmwrite(strcat('data/Zad5/DMC/Zad5_DMC_input_N=',num2str(N),'Nu=',num2str(Nu),'lambda=',num2str(lambda),'E=',num2str(E),'.csv'), u_data, '\t');
    dlmwrite(strcat('data/Zad5/DMC/Zad5_DMC_output_N=',num2str(N),'Nu=',num2str(Nu),'lambda=',num2str(lambda),'E=',num2str(E), '.csv'), y_data, '\t');

end
if(zad6_save)
    u_data = [(1:kk)'-1 u'];
    y_data = [(1:kk)'-1 y'];
    dlmwrite(strcat('data/Zad6/DMC/Zad6_DMC_input_simulation=600_N=',num2str(N),'Nu=',num2str(Nu),'lambda=',num2str(lambda),'E=',num2str(E),'.csv'), u_data, '\t');
    dlmwrite(strcat('data/Zad6/DMC/Zad6_DMC_output_simulation=600_N=',num2str(N),'Nu=',num2str(Nu),'lambda=',num2str(lambda),'E=',num2str(E), '.csv'), y_data, '\t');
end
