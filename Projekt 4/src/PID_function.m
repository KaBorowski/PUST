function E = PID_function(params, draw)
%Nastawy PID
% Kolejno�� podpi�cia regulator�w do wyj�� [y1 y2 y3]
Kr = params(1:3);
Ti = params(4:6);
Td = params(7:9);

Tp = [0.5, 0.5, 0.5];

r0 = Kr.*(1+Tp./(2.*Ti)+Td./Tp);
r1 = Kr.*(Tp./(2.*Ti)-2.*Td./Tp-1);
r2 = Kr.*Td./Tp;

r0=r0';
r1=r1';
r2=r2';

kk=300; 

nu = 4;
ny = 3;

u = zeros(nu, kk);
y = zeros(ny, kk);
yzad = zeros(ny, kk);
e = zeros(ny,kk);
E=0; %wskaznik jakosci regulacji

yzad(:,7:100)=1;
yzad(:,101:200)=-0.5;
yzad(:,201:kk)= 0.2;

%Kolejno�� podpi�cia sygna��w steruj�cych do regulator�w
% U_order = [4, 1, 3];
% U_order = [4, 1, 2];
U_order = [3, 1, 2];


for k=7:kk
    [y(1,k),y(2,k),y(3,k)]=symulacja_obiektu10(u(1,k-1),u(1,k-2),u(1,k-3),u(1,k-4),...
        u(2,k-1),u(2,k-2),u(2,k-3),u(2,k-4), u(3,k-1),u(3,k-2),u(3,k-3),u(3,k-4),...
        u(4,k-1),u(4,k-2),u(4,k-3),u(4,k-4), y(1,k-1),y(1,k-2),y(1,k-3),y(1,k-4),...
        y(2,k-1),y(2,k-2),y(2,k-3),y(2,k-4), y(3,k-1),y(3,k-2),y(3,k-3),y(3,k-4));
    e(:,k)=yzad(:,k)-y(:,k);
    E=E+sum(e(:,k).^2);
    
    U = [u(U_order(1),:); u(U_order(2),:); u(U_order(3),:)];
    U(:,k)=r2.*e(:,k-2)+r1.*e(:,k-1)+r0.*e(:,k)+U(:,k-1);
    u(U_order(1),:) = U(1,:);
    u(U_order(2),:) = U(2,:);
    u(U_order(3),:) = U(3,:);
end

if draw == true
    figure;
    sgtitle(['Algorytm PID, wska�nik jako�ci regulacji E=', num2str(E)]);
    for i=1:ny
        subplot(ny,1,i);
        hold on;
        grid on;
        grid minor;
        stairs(yzad(i,:));
        plot(y(i,:));
    %     ylim([0,2]);
        legend(strcat('y_', num2str(i), '^{zad}(k)'), ...
            strcat('y_', num2str(i), '(k)'), 'Location', 'northeast');
    %     ylabel('Warto�� sygna�u');
        title(['PID',num2str(i),'   K=' num2str(Kr(i)) ', T_i=' num2str(Ti(i)) ', T_d=' num2str(Td(i))]);

    end
    xlabel('k');
    hold off;
    
    matlab2tikz(strcat('../data/Zad5/PID/output_konf_', ...
        num2str(U_order(1)), num2str(U_order(2)), ...
        num2str(U_order(3)),'E_', num2str(E),'.tex'), 'showInfo', false);

    figure;
    sgtitle(['Algorytm PID, sygna�y steruj�ce']);
    for i=1:nu
        subplot(nu,1,i);
        hold on;
        grid on;
        grid minor;
        plot(u(i,:));
        if i == 1
            title(['Algorytm PID, sygna�y steruj�ce']);
        end
    end
    xlabel('k');
    hold off;
    
    matlab2tikz(strcat('../data/Zad5/PID/input_konf_', ...
        num2str(U_order(1)), num2str(U_order(2)), ...
        num2str(U_order(3)),'E_', num2str(E),'.tex'), 'showInfo', false);
end

end