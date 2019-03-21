%Funkcja celu dla optymalizacji w zadaniu 3. Laboratorium

function [E, s, y] = zad3_err_function(params)

load('temp35_37.mat');
s = (temp35_37-34.5)/2;
len = length(s);

E = 0;
T1=params(1);
T2=params(2);
K=params(3);
Td=floor(params(4));

alfa1= exp(-1/T1);
alfa2 = exp(-1/T2);
a1 = -alfa1-alfa2;
a2 = alfa1*alfa2;
b1 = K/(T1-T2)*(T1*(1-alfa1)-T2*(1-alfa2));
b2 = K/(T1-T2)*(alfa1*T2*(1-alfa2)-alfa2*T1*(1-alfa1));

y(1:len) = 0; u(1:len) = 1;

for k=Td+3:len
   
    y(k) = b1*u(k-Td-1)+b2*u(k-Td-2)-a1*y(k-1)-a2*y(k-2);
    E = E + (s(k)-y(k))^2;
 
end
end
