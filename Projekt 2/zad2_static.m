n=300;
U(1:n)=0;
Z(1:n)=0;
Y(1:7)=0;
Y(8:n)=1;
Ystat3D=zeros(101);
%Wyznaczanie charakterystki statycznej sterowania
for i=1:101
    dU=(i-1)*0.01;
    U(10:n)=dU;
    for k=9:n
        Y(k)=symulacja_obiektu10y(U(k-7),U(k-8),Z(k-3),Z(k-4),Y(k-1),Y(k-2));
    end
    Ustat(i)=U(n);
    YstatU(i)=Y(n);
end

plot(Ustat,YstatU);
xlabel('U');
ylabel('Y');
title('Charakterystyka statyczna Y(U)');

%Wzmocnienie statyczne
KstatU=(Ystat(101)-Ystat(1))/(Ustat(101)-Ustat(1));

%Wyznaczanie charakterystki statycznej zak³ócenia
for i=1:101
    dZ=(i-1)*0.01;
    Z(10:n)=dZ;
    for k=9:n
        Y(k)=symulacja_obiektu10y(U(k-7),U(k-8),Z(k-3),Z(k-4),Y(k-1),Y(k-2));
    end
    Zstat(i)=Z(n);
    YstatZ(i)=Y(n);
end
figure
plot(Zstat,YstatZ);
xlabel('Z');
ylabel('Y');
title('Charakterystyka statyczna Y(Z)');

%Wzmocnienie statyczne
KstatZ=(Ystat(101)-Ystat(1))/(Zstat(101)-Zstat(1));

%Wyznaczanie charakterystki statycznej y(u,z)
for i=1:101
    dU=(i-1)*0.01;
    U(10:n)=dU;
    for j=1:101
        dZ=(j-1)*0.01;
        Z(10:n)=dZ;
        for k=9:n
            Y(k)=symulacja_obiektu10y(U(k-7),U(k-8),Z(k-3),Z(k-4),Y(k-1),Y(k-2));
        end
        Zstat(j)=Z(n);
        Ystat3D(i,j)=Y(n);
    end
    Ustat(i)=U(n);
end

% surf(Ustat,Zstat,Ystat3D);
% xlabel('U');
% ylabel('Z');
% zlabel('Y');
% title('Charakterystyka statyczna y(u,z)');
% kk=101;
% data = [Ustat' Zstat' Ystat'];
%  char_stat_U = [Ustat' YstatU'];
%  char_stat_Z = [Zstat' YstatZ'];
% % plot(Ustat,Ystat)
%  dlmwrite(strcat('data/Zad2/zad2_statU.csv'), char_stat_U, '\t');
%  dlmwrite(strcat('data/Zad2/zad2_statZ.csv'), char_stat_Z, '\t');
% dlmwrite(strcat('data/Zad2/zad2_surf.csv'), data, '\t');
