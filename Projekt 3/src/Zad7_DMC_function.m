function E = Zad7_DMC_function(lambda, Y, dY)

D = 30;
Tp = 0.5;
%parametry DMC wlasne
N = 10;
Nu = 1; 

s = generate_step(getU(Y),Y,dY);
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
ku = K1*Mp;

kk=600; 
u(1:kk)=getU(Y); y(1:kk)=Y; 
yzad(1:9)=Y; yzad(10:kk)=Y+dY;
du(1:D-1)=0;

E=0;

for k=7:kk
   
    y(k)=symulacja_obiektu10y(u(k-5),u(k-6),y(k-1),y(k-2));
    e = yzad(k) - y(k);
    E=E+e^2;
    
    deltau = ke*e-ku*du';
    
    for n=D-1:-1:2
        du(n)=du(n-1);
    end
    
    du(1)=deltau;
    u(k) = u(k-1) + du(1);   
    
end

