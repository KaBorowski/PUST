Uy(1:12) =3;
Uy(13:500)= 3.2;
Uz(1:12) =3;
Uz(13:500)= 4;
Ux(1:12) =3;
Ux(13:500)= 2;

Y(1:500) = 0;
Z(1:500) = 0;
X(1:500) = 0;

% if U < 2.7
%     U = 2.7;
% end
% if U > 3.3
%     U = 3.3;
% end

    
for k=12:500
    if Uy(k) < 2.7
        Uy(k) = 2.7;
    end
    if Uy(k) > 3.3
        Uy(k) = 3.3;
    end
    Y(k)=symulacja_obiektu10Y(Uy(k-10),Uy(k-11),Y(k-1),Y(k-2));
end
for k=12:500
    if Uz(k) < 2.7
        Uz(k) = 2.7;
    end
    if Uz(k) > 3.3
        Uz(k) = 3.3;
    end
    Z(k)=symulacja_obiektu10Y(Uz(k-10),Uz(k-11),Z(k-1),Z(k-2));
end
for k=12:500
    if Ux(k) < 2.7
        Ux(k) = 2.7;
    end
    if Ux(k) > 3.3
        Ux(k) = 3.3;
    end
    X(k)=symulacja_obiektu10Y(Ux(k-10),Ux(k-11),X(k-1),X(k-2));
end
figure;
hold on;
plot(Y);
plot(Z);
plot(X);
legend('Odp. na skok 3 -> 3.2', 'Odp. na skok 3 -> 4', 'Odp. na skok 3 -> 2', 'Location', 'southeast');
title('Odpowiedzi skokowe', 'FontName', 'Helvetica');
xlabel('k');
grid on;
grid minor;
hold off;
figure;

plot(Y,Uy,'-o','LineWidth',0.5,'MarkerSize',0.5)
