function E = Zad6_PID_E_function(params)

Kr = params(1);
Ti = params(2);
Td = params(3);

Tp = 0.5;

r0 = Kr*(1+Tp/(2*Ti)+Td/Tp);
r1 = Kr*(Tp/(2*Ti)-2*Td/Tp-1);
r2 = Kr*Td/Tp;

kk=600; 
u(1:kk)=3; y(1:kk)=0.9;
yzad(1:9)=0.9; yzad(10:149)=1.2; yzad(150:299)=0.5; yzad(300:449)=0.9; yzad(450:kk)=0.8;
e(1:kk)=0; 

E=0; %wskaznik jakosci regulacji

for k=12:kk
     y(k)=symulacja_obiektu10Y(u(k-10),u(k-11),y(k-1),y(k-2));
     e(k)=yzad(k)-y(k);
     E=E+e(k)^2;
     u(k)=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);
     if (u(k) - u(k-1)) > 0.075
         u(k) = u(k-1)+0.075;
     end
     if (u(k) - u(k-1)) < -0.075
         u(k) = u(k-1)-0.075;
     end
     if u(k) < 2.7
         u(k) = 2.7;
     end
     if u(k) > 3.3
         u(k) = 3.3;
     end
    
end

end

