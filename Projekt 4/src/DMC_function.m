function E = DMC_function(params)
% disp(lambda_params);
odp=load('../data/Zad2/odp.mat');
s=odp.s;
s = permute(s, [1,3,2]);

nu = 4;
ny = 3;

D = length(s);
Tp = 0.5;
%parametry DMC wlasne
N = D;
Nu = N;
mi = diag(params(1:ny));
lambda = diag(params(ny+1:ny+nu)); 

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
            M{i,j} = zeros(ny,nu);    
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
            LAMBDA{i,j} = zeros(nu);
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
            MI{i,j} = zeros(ny);
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
kk=1000; 
u = zeros(nu, kk);
y = zeros(ny, kk);
yzad = zeros(ny, kk);
e = zeros(ny,kk);
du = cell(1,D-1)';
for i=1:D-1
    du{i}=zeros(1,nu)';
end
E=0; %wskaznik jakosci regulacji

yzad(1,7:kk)=1;
yzad(2,7:kk)=2;
yzad(3,7:kk)=-1;

 
for k=7:kk
   
    [y(1,k),y(2,k),y(3,k)]=symulacja_obiektu10(u(1,k-1),u(1,k-2),u(1,k-3),u(1,k-4),...
        u(2,k-1),u(2,k-2),u(2,k-3),u(2,k-4), u(3,k-1),u(3,k-2),u(3,k-3),u(3,k-4),...
        u(4,k-1),u(4,k-2),u(4,k-3),u(4,k-4), y(1,k-1),y(1,k-2),y(1,k-3),y(1,k-4),...
        y(2,k-1),y(2,k-2),y(2,k-3),y(2,k-4), y(3,k-1),y(3,k-2),y(3,k-3),y(3,k-4));
    e(:,k)=yzad(:,k)-y(:,k);
    E=E+sum(e(:,k).^2);
    
    Kuj_du = zeros(1,nu)';
    for j=1:D-1
        if j < k
            Kuj_du = Kuj_du + Kuj{j}*du{j};
        else
            break;
        end
    end
    
    deltau = Ke*e(:,k) - Kuj_du;
    
    for n=D-1:-1:2
        du(n)=du(n-1);
    end
    
    du{1}=deltau;
    u(:,k) = u(:,k-1) + du{1};   
    
end

end