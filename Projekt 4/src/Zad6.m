clear;
save_files = false;
odp=load('../data/Zad2/odp.mat');
s=odp.s;
s = permute(s, [1,3,2]);

nu = 4;
ny = 3;

D = length(s);
Tp = 0.5;
%parametry DMC optymalne
N = D;
Nu = N;
mi = diag([5.3909, 0.049543, 0.17616]);
lambda = diag([0.0011426, 0.0026188, 0.24485, 2.4863]); 

S = cell(1,D);
for p=1:D
    S{p} = s(:,:,p);
end

%% Wyznaczanie macierzy predykcji
% Mp = zeros(N,D-1);
Mp = cell(N, D-1);

for i = 1:N
    for j = 1:(D-1)
        if (i+j > D)
            Mp{i,j} = S{D} - S{j};
        else
            Mp{i,j} = S{i+j} - S{j};
        end
    end
end
 

%% Wyznaczanie macierzy dynamicznej
M = cell(N,Nu);

for j = 1:Nu
    for i = 1:N
        if i >= j
            M{i,j} = S{i-j+1};
        else
            M{i,j} = zeros(3,4);    
        end
    end
end

%% Wyznaczenie macierzy LAMBDA
LAMBDA = cell(Nu);

for i = 1:Nu
    for j = 1:Nu
        if i == j 
            LAMBDA{i,j} = lambda;
        else
            LAMBDA{i,j} = zeros(4);
        end
    end
end

%% Wyznaczenie macierzy MI
MI = cell(N);

for i = 1:N
    for j = 1:N
        if i == j 
            MI{i,j} = mi;
        else
            MI{i,j} = zeros(3);
        end
    end
end

%% Wyznaczenie wspoczynnika K
K = (cell2mat(M)'*cell2mat(MI)*cell2mat(M)+cell2mat(LAMBDA))^-1 * ... 
    cell2mat(M)'*cell2mat(MI);

Ksize = size(K);
V1(1:Ksize(1)/nu) = nu;
V2(1:Ksize(2)/ny) = ny;
K = mat2cell(K, V1, V2);
K1 = K(1,:);

Ke = zeros(nu,ny);
for i=1:N
    Ke = Ke + K{1,i};
end

K1=cell2mat(K1);
Kuj = cell(1,D-1);
for j=1:D-1
    Kuj{j} = K1*cell2mat(Mp(:,j));
end


%% Regulacja DMC
kk=300; 
u = zeros(nu, kk);
y = zeros(ny, kk);
yzad = zeros(3, kk);
e = zeros(3,kk);
du = cell(1,D-1)';
for i=1:D-1
    du{i}=zeros(1,nu)';
end

E=0; %wskaznik jakosci regulacji

yzad(:,7:100)=1;
yzad(:,101:200)=-0.5;
yzad(:,201:kk)= 0.2;
 
for k=7:kk
   
    [y(1,k),y(2,k),y(3,k)]=symulacja_obiektu10(u(1,k-1),u(1,k-2),u(1,k-3),u(1,k-4),...
        u(2,k-1),u(2,k-2),u(2,k-3),u(2,k-4), u(3,k-1),u(3,k-2),u(3,k-3),u(3,k-4),...
        u(4,k-1),u(4,k-2),u(4,k-3),u(4,k-4), y(1,k-1),y(1,k-2),y(1,k-3),y(1,k-4),...
        y(2,k-1),y(2,k-2),y(2,k-3),y(2,k-4), y(3,k-1),y(3,k-2),y(3,k-3),y(3,k-4));
    e(:,k)=yzad(:,k)-y(:,k);
    E=E+sum(e(:,k).^2);
  
    YZAD = zeros(ny*N, 1);
    for i=1:ny:N
        YZAD(i:i+ny-1) = yzad(:,k);
    end
    
    Y = zeros(ny*N, 1);
    for i=1:ny:N
        Y(i:i+ny-1) = y(:,k);
    end
    
    dU = cell2mat(K)*(YZAD - Y - cell2mat(Mp)*cell2mat(du));
    
    for n=D-1:-1:2
        du(n)=du(n-1);
    end
    
    du{1} = dU(1:nu);
    
    u(:,k) = u(:,k-1) + dU(1:nu);
    
end


figure;
sgtitle(['Algorytm DMC, wska¼nik jako¶ci regulacji E=', num2str(E)]);
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
%     ylabel('Wartoï¿½ï¿½ sygnaï¿½u');
%     title(['DMC',num2str(i),'   K=' num2str(Kr(i)) ', T_i=' num2str(Ti(i)) ', T_d=' num2str(Td(i))]);
    xlabel('k');
    hold off;
end

figure;
sgtitle('Algorytm DMC, sygna³y steruj±ce');
for i=1:nu
    subplot(nu,1,i);
    hold on;
    grid on;
    grid minor;
    plot(u(i,:));
    title(['u_',num2str(i)]);
    xlabel('k');
    hold off;
end

% if save_files == true
%     matlab2tikz(strcat('../data/Zad4/DMC/DMC_U(', num2str(U_order(1)),',',...
%         num2str(U_order(2)),',',num2str(U_order(3)),...
%         ')_E=', num2str(E), '.tex'), 'showInfo', false);
% end
