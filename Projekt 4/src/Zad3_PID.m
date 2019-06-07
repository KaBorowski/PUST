clear;
save_files = false;

%Nastawy PID
% Kolejno¶æ podpiêcia regulatorów do wyj¶æ [y1 y2 y3]
Kr = [2.5714, 0.26869, 0.62088];
Ti = [7.2359, 0.010604, 2.9326];
Td = [0, 0, 0.144481];

Tp = [0.5, 0.5, 0.5];

r0 = Kr.*(1+Tp./(2.*Ti)+Td./Tp);
r1 = Kr.*(Tp./(2.*Ti)-2.*Td./Tp-1);
r2 = Kr.*Td./Tp;

r0=r0';
r1=r1';
r2=r2';

kk=50; 

nu = 4;
ny = 3;

u = zeros(nu, kk);
y = zeros(ny, kk);
yzad = zeros(ny, kk);
e = zeros(ny,kk);
E=0; %wskaznik jakosci regulacji

yzad(:,7:kk)=1;

%Kolejno¶æ podpiêcia sygna³ów steruj±cych do regulatorów
U_order = [4, 1, 3];

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

figure;
sgtitle(['Algorytm PID, wska¼nik jako¶ci regulacji E=', num2str(E)]);
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
%     ylabel('Warto¶æ sygna³u');
    title(['PID',num2str(i),'   K=' num2str(Kr(i)) ', Ti=' num2str(Ti(i)) ', Td=' num2str(Td(i))]);
    xlabel('k');
    hold off;
end

figure;
for i=1:nu
    subplot(nu,1,i);
    hold on;
    grid on; 
    grid minor;
    plot(u(i,:));
%     title(['PID',num2str(i),'   K=' num2str(Kr(i)) ', Ti=' num2str(Ti(i)) ', Td=' num2str(Td(i))]);
    xlabel('k');
    hold off;
end

if save_files == true
    matlab2tikz(strcat('../data/Zad4/PID/PID_U(', num2str(U_order(1)),',',...
        num2str(U_order(2)),',',num2str(U_order(3)),...
        ')_E=', num2str(E), '.tex'), 'showInfo', false);
end
    