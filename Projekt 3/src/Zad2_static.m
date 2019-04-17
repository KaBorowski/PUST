clear;
kk=300;
n=201;
U(1:kk)=0;
Y(1:kk)=0;
Ustat(1:n)=0;
Ystat(1:n)=0;

dU=-1;
%Wyznaczanie charakterystki statycznej sterowania
for i=1:n
%     dU=(i-1)*0.01;
    U(8:kk)=dU;
    dU=dU+0.01;
    for k=7:kk
        Y(k)=symulacja_obiektu10y(U(k-5),U(k-6),Y(k-1),Y(k-2));
    end
    Ustat(i)=U(kk);
    Ystat(i)=Y(kk);
end
%Y_MIN = -2.6416   |   Y_MAX = 0.0885

figure;
plot(Ustat,Ystat);
xlabel('U');
ylabel('Y');
title('Charakterystyka statyczna Y(U)');

%Wzmocnienie statyczne
KstatU=(Ystat(101)-Ystat(1))/(Ustat(101)-Ustat(1));

char_stat_U = [Ustat' Ystat'];
% dlmwrite(strcat('../data/Zad2/zad2_statU.csv'), char_stat_U, '\t');

