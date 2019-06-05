%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                              %
%%    Przyk³adowy skrypt z implementacj¹ prostego regulatora DMC w wersji       %
%%  analitycznej, uzupe³niony o pomiar zak³ócenia (cz. III - symulowanie        %
%%  dzia³ania uk³adu regulacji po uprzednim obliczeniu parametrów regulatora    %
%%  i ustaleniu parametrów scenariusza eksperymentu).                           %
%%    Przyjête oznaczenia:                                                      %
%%    yk - bie¿¹ca wartoœæ wyjœcia obiektu                                      %
%%    uk - bie¿¹ca wartoœæ sterowania                                           %
%%    zk - bie¿¹ca wartoœæ zak³ócenia                                           %
%%    yk1 - poprzednia wartoœæ wyjœcia obiektu                                  %
%%    zk1 - poprzednia wartoœæ zak³ócenia                                       %
%%    D - horyzont dynamiki                                                     %
%%    ke, ku, kz - parametry regulatora                                         %
%%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Autor: Piotr Marusak; 2001-2017
%   Wersja przeznaczona dla s³uchaczy wyk³adu Diagnostyka procesów przemys³owych
% (DIPR) prowadzonego na Wydziale Elektroniki i Technik Informacyjnych 
% Politechniki Warszawskiej.


% G³ówna pêtla programu

for i=1:czas_sym
   
   yk1=yk;
   zk1=zk;
   
   if i==chwila_zak
      zk=wart_zak;
   end
   
   % Obiekt
   
   yk=a1*yk+b1*uk+c1*zk;
      
   % Regulator DMC
   
   ek=y_zad-yk;
   
   if fl_pomiar_zak==1
      for n=D-1:-1:2;
         deltazp(n)=deltazp(n-1);
      end
      deltazp(1)=zk-zk1;
   end      
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Prawo regulacji
   
   deltauk=ke*ek-ku*deltaup';
   if fl_pomiar_zak==1
      deltauk=deltauk-kz*deltazp';
   end         
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   for n=D-1:-1:2;
      deltaup(n)=deltaup(n-1);
   end
   deltaup(1)=deltauk;
   uk=uk+deltaup(1);
   
   wyu(i)=uk;
   wyy(i)=yk;
end

% Graficzna prezentacja wyników obliczeñ

plot(wyy,'b');hold on; grid on;
stairs(0:czas_sym,[yzad_pocz y_zad*ones(1,czas_sym)],'--');
stairs(0:czas_sym,[u_pocz wyu],'m');
xlabel('czas [Tp]');ylabel('u, y, y_{zad}')
title('Wynik dzialania ukladu z regulatorem DMC');

