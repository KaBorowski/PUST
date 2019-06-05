function E = Zad5_PID_function(params, y_beg, dY)

Kr = params(1);
Ti = params(2);
Td = params(3);

U = getU(y_beg);

Tp = 0.5;

r0 = Kr*(1+Tp/(2*Ti)+Td/Tp);
r1 = Kr*(Tp/(2*Ti)-2*Td/Tp-1);
r2 = Kr*Td/Tp;

kk=600; 
% U = start_point;
% Y = get_beg_y(U);
% dY = jump_value;
u(1:kk)=U; y(1:kk)=y_beg;
yzad(1:9)=y_beg; yzad(10:kk)=y_beg+dY;
e(1:kk)=0; 

E=0; %wskaznik jakosci regulacji

for k=7:kk
     y(k)=symulacja_obiektu10y(u(k-5),u(k-6),y(k-1),y(k-2));
     e(k)=yzad(k)-y(k);
     E=E+e(k)^2;
     u(k)=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);

     if u(k) < -1
         u(k) = -1;
     end
     if u(k) > 1
         u(k) = 1;
     end
    
end

% figure;
% hold on;
% plot(y);
% plot(u);
% stairs(yzad);

end

