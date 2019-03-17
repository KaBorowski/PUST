Uy(1:249) =3;
Uy(250:500)= 3.2;
Uz(1:249) =3;
Uz(250:500)= 4;
Ux(1:249) =3;
Ux(250:500)= 2.7;

Y(1:500) = 0;
Z(1:500) = 0;
X(1:500) = 0;

    
for k=12:500

    Y(k)=symulacja_obiektu10Y(Uy(k-10),Uy(k-11),Y(k-1),Y(k-2));
end
for k=12:500

    Z(k)=symulacja_obiektu10Y(Uz(k-10),Uz(k-11),Z(k-1),Z(k-2));
end
for k=12:500

    X(k)=symulacja_obiektu10Y(Ux(k-10),Ux(k-11),X(k-1),X(k-2));
end
figure;
hold on;
plot(Y);
plot(Z);
plot(X);
legend('Odp. na skok 3 -> 3.2', 'Odp. na skok 3 -> 4', 'Odp. na skok 3 -> 2.7', 'Location', 'southeast');
title('Odpowiedzi skokowe', 'FontName', 'Helvetica');
xlabel('k');
grid on;
grid minor;
hold off;
figure;

plot(Uy,Y,'-o','LineWidth',0.5,'MarkerSize',0.5)
