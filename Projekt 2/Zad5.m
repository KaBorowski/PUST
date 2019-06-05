clear;
odp=load('data/Zad3/odp_ster.mat');
s=odp.u;
odp2=load('data/Zad3/odp_zak.mat');
sz=odp2.z;

D = length(s);
Dz = 55;
Tp = 0.5;
%parametry DMC wlasne
N = 17;
Nu = 1;
lambda = 2;

%parametry DMC po optymalizacji
% N = 18;
% Nu = 4;
% lambda = 0.5;

zad5_save = false;

zaklocenie = 1;


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

kk=100; 
u(1:kk)=0; y(1:kk)=0; z(1:kk)=0;
yzad(1:9)=0;  yzad(10:kk)=1;
du(1:D-1)=0;

if zaklocenie==1
    dz(1:Dz-1)=0;
end

E=0;
skokz = 0;
count = 0;

for k=9:kk
     
    y(k)=symulacja_obiektu10y(u(k-7),u(k-8),z(k-3),z(k-4),y(k-1),y(k-2)); %symulowany sygna³ wyjœciowy obiektu
    
    e = yzad(k) - y(k);
    
    if abs(e)<= 0.1 && k>=30
        count = count + 1;
    end
    
    if skokz == 1
        z(k)=1;
    end
    
    if count == 20
        skokz = 1;
    end
    
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
stairs(z);
legend('u(k)', 'y(k)', 'yzad(k)','z(k)', 'Location', 'northeast');
xlabel('k');
ylabel('Wartoœæ sygna³u');
title(['Regulator DMC Dz=' num2str(Dz) '   Wska¼nik jako¶ci regulacji=' num2str(E)]);
hold off;

if(zad5_save)
%     yzad_data = [(1:kk)'-1 yzad'];
%     dlmwrite('data/Zad4/y_zadane.csv', yzad_data, '\t');
    u_data = [(1:kk)'-1 u'];
    y_data = [(1:kk)'-1 y'];
    z_data = [(1:kk)'-1 z'];
    dlmwrite(strcat('data/Zad5/DMC_input_Dz=',num2str(Dz),'E=',num2str(E),'.csv'), u_data, '\t');
    dlmwrite(strcat('data/Zad5/DMC_output_Dz=',num2str(Dz),'E=',num2str(E),'.csv'), y_data, '\t');
    dlmwrite(strcat('data/Zad5/DMC_zaklocenie_Dz=',num2str(Dz),'E=',num2str(E),'.csv'), z_data, '\t');
    
end

