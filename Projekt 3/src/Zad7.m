clear;

REG_COUNT = 5;
save = 0;

Y_MIN = -2.6416;
Y_MAX = 0.0885;

y_beg = zeros(1,REG_COUNT);
delta_y_beg = (Y_MAX-Y_MIN)/(REG_COUNT-1);
JUMP = 0.1;

%nastawy regulator�w lokalnych DMC
D=30;
N=10;
Nu=1;
lambda(1:REG_COUNT)=1;
ke=zeros(1, REG_COUNT);
ku=zeros(REG_COUNT, D-1);
dUp = zeros(D-1, 1);

for reg = 1:REG_COUNT
    if reg==1
       y_beg(reg)=Y_MIN;
    else
        y_beg(reg)=y_beg(reg-1)+delta_y_beg;
    end
    
    if y_beg(reg)>(Y_MAX-JUMP)
        y_beg(reg) = Y_MAX - JUMP;
    end
    
    if reg==REG_COUNT
       y_beg(reg)=Y_MAX;
       JUMP = -0.08;
    end
    s = generate_step(getU(y_beg(reg)),y_beg(reg),JUMP);
    lambda(reg) = Zad7_DMC_params(y_beg(reg), JUMP);
    %Wyznaczanie macierzy predykcji
    Mp = zeros(N,D-1);

    for i = 1:N
        for j = 1:(D-1)
            if (i+j > D)
                Mp(i,j) = s(D) - s(j);
            else
                Mp(i,j) = s(i+j) - s(j);
            end
        end
    end

    %Wyznaczanie macierzy dynamicznej
    M = zeros(N,Nu);

    for j = 1:Nu
        for i = 1:N
            if i >= j
                M(i,j) = s(i-j+1);
            end
        end
    end

    %Wyznaczenie wspoczynnika K
    K = (M'*M+lambda(reg)*eye(Nu))^-1*M';
    K1 = K(1,:);
    ke(reg) = sum(K1);
    ku(reg,:) = K1*Mp;
end

kk=1500; 
u(1:kk)=0; y(1:kk)=0;
yzad(1:9)=0; yzad(10:299)=0.08; yzad(300:599)=-1; yzad(600:899)=-0.25; yzad(900:1199)=-2; yzad(1200:kk) = 0;

du(1:D-1)=0;
membership(1:REG_COUNT) = 0;
input(1:REG_COUNT) = 0;
deltau_lok(1:REG_COUNT) = 0;
deltau=0;

E=0;

for k=7:kk
    for i = 1:(D-1)
        if (k-i) <= 0
            du1 = 0;
        else
            du1 = u(k - i);
        end
        if (k-i-1) <= 0
            du2 = 0;
        else
            du2 = u(k - i - 1);
        end 
        dUp(i) = du1 - du2;
    end
   
    y(k)=symulacja_obiektu10y(u(k-5),u(k-6),y(k-1),y(k-2));
    e = yzad(k) - y(k);
    E=E+e^2;
    
    for i=1:REG_COUNT
        input(i) = ke(i)*e-ku(i,:)*dUp; 
        if input(i)>1
            input(i)=1;
        elseif input(i)<-1
            input(i)=-1;
        end
        deltau_lok(i) = ke(i)*e-ku(i,:)*du';
        membership(i) = membership_function(y(k), y_beg(i), REG_COUNT);
    end
    u(k)=0;
    for i=1:REG_COUNT
         u(k) = u(k) + membership(i)*input(i); 
    end
    u(k) = u(k)/sum(membership);
    u(k) = u(k) + u(k-1);

     if u(k) < -1
         u(k) = -1;
     end
     if u(k) > 1
         u(k) = 1;
     end
    
end

figure;
hold on
grid on; 
grid minor;
plot(yzad); 
plot(u); 
plot(y);
legend('yzad(k)','u(k)', 'y(k)', 'Location', 'northeast');
xlabel('k');
ylabel('Warto�� sygna�u');
title(['Regulator DMC rozmyty -> regulatory lokalne = ',num2str(REG_COUNT),'   Wska�nik jako�ci regulacji=' num2str(E)]);
hold off;

if save == 1
    u_data = [(1:kk)'-1 u'];
    y_data = [(1:kk)'-1 y'];
%     yzad_data = [(1:kk)'-1 yzad'];
% 
%     dlmwrite('../data/Zad4/trajektoria.csv', yzad_data, '\t')
    dlmwrite(strcat('../data/Zad7/input_N=10_Nu=1_REG_COUNT=',num2str(REG_COUNT),'E=',num2str(E),'lambdy=',num2str(lambda),'.csv'), u_data, '\t');
    dlmwrite(strcat('../data/Zad7/output_N=10_Nu=1_REG_COUNT=',num2str(REG_COUNT),'E=',num2str(E),'lambdy=',num2str(lambda),'.csv'), y_data, '\t');
end


