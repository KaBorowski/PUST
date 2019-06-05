function DMC_lab_rozmyty()
    addpath('F:\SerialCommunication'); % add a path to the functions
    initSerialControl COM21 % initialise com port
    
    figure;
    y=[];
    yplot=[];
    uplot=[];
    yzadplot=[];
    
    load('u30_35.mat');
    s1 = (u30_35-u30_35(1))/5;
    load('u49_51.mat');
    s2 = (u49_51-u49_51(1))/2;
    load('u62_67.mat');
    s1 = (u62_67-u62_67(1))/5;
      
    x_fp = 0:0.01:100;       
    fp1 = trapmf(x_fp, [0 0.0001 40 42.5]);
    fp2 = trapmf(x_fp, [40.5 41.5 44 45]);
    fp3 = trapmf(x_fp, [44 45 99.9999 100]);
    
    D = 500;
    %parametry DMC
    N = D;
    Nu = D;
    lambda1 = 1;
    lambda2 = 1;
    lambda3 = 1;
    
    Mp1 = zeros(N,D-1);
    for i = 1:N
        for j = 1:(D-1)
            if (i+j > D)
                Mp1(i,j) = s1(D) - s1(j);
            else
                Mp1(i,j) = s1(i+j) - s1(j);
            end
        end
    end
    
    Mp2 = zeros(N,D-1);
    for i = 1:N
        for j = 1:(D-1)
            if (i+j > D)
                Mp2(i,j) = s2(D) - s2(j);
            else
                Mp2(i,j) = s2(i+j) - s2(j);
            end
        end
    end
    
    Mp3 = zeros(N,D-1);
    for i = 1:N
        for j = 1:(D-1)
            if (i+j > D)
                Mp3(i,j) = s3(D) - s3(j);
            else
                Mp3(i,j) = s3(i+j) - s3(j);
            end
        end
    end

    %Wyznaczanie macierzy dynamicznej
    M1 = zeros(N,Nu);
    for j = 1:Nu
        for i = 1:N
            if i >= j
                M1(i,j) = s1(i-j+1);
            end
        end
    end
    
    M2 = zeros(N,Nu);
    for j = 1:Nu
        for i = 1:N
            if i >= j
                M2(i,j) = s2(i-j+1);
            end
        end
    end
    
    M3 = zeros(N,Nu);
    for j = 1:Nu
        for i = 1:N
            if i >= j
                M3(i,j) = s3(i-j+1);
            end
        end
    end
    

    %Wyznaczenie wspoczynnikow K
    K1 = (M1'*M1+lambda1*eye(Nu))^-1*M1';
    K2 = (M2'*M2+lambda2*eye(Nu))^-1*M2';
    K3 = (M3'*M3+lambda3*eye(Nu))^-1*M3';
    K1_1 = K1(1,1:N);
    K2_1 = K2(1,1:N);
    K3_1 = K3(1,1:N);
    ke1 = sum(K1_1);
    ke2 = sum(K2_1);
    ke3 = sum(K3_1);
    ku1 = K1_1*Mp1;
    ku2 = K2_1*Mp2;
    ku3 = K3_1*Mp3;
    
    du(1:D-1)=0; u(1:2) = 35;
    
    sendControls(1, 50);
    measurements = readMeasurements(1:7);
    Tpp = measurements(1);
    y(1) = Tpp;
    yzad(1:30)=Tpp; yzad(31:180)=Tpp+5; yzad(181:550)=Tpp+15; yzad(551:10000)=Tpp;   
    E(1:10000) = 0;
    k = 2;
    
    while(1)
        %% obtaining measurements
        measurements = readMeasurements(1:7); % read measurements from 1 to 7
        y(k) = measurements(1);
        %% processing of the measurements and new control values calculation
        yplot =[yplot measurements(1)];
        uplot = [uplot u(k-1)];
        yzadplot = [yzadplot yzad(k)];
        disp(measurements(1)); % process measurements
        hold on; grid on; plot(yplot, 'g'); plot(uplot, 'r'); stairs(yzadplot, 'b');
        legend('y(k)','u(k)','yzad(k)', 'Location', 'southwest');
        title(['Algorytm DMC, E = ' num2str(E(k-1))]);
        drawnow
        
             
    e = yzad(k) - y(k);
    E(k) = E(k-1)+e^2;
    
    deltau1 = ke1*e-ku1*du';
    deltau2 = ke2*e-ku2*du';
    deltau3 = ke3*e-ku3*du';
    
    x = measurements(1); %zmienna wybieraj¹ca
    w1 = fp1(x*100);
    w2 = fp2(x*100);
    w3 = fp3(x*100);
    
    deltau = (w1*deltau1+w2*deltau2+w3*deltau3)/(w1+w2+w3);
    
    for n=D-1:-1:2
        du(n)=du(n-1);
    end
    
    du(1) = deltau;
    u(k) = u(k-1) + du(1);
        
        if u(k)>100
            u(k) = 100;
        end
            
        if u(k)<0
            u(k) = 0;
        end
            
        %% sending new values of control signals
        sendNonlinearControls(u(k));
        
        %% synchronising with the control process        
        k = k + 1;
        waitForNewIteration(); % wait for new batch of measurements to be ready        
        
    end
end