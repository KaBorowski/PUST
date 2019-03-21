function MinimalWorkingExample_DMC()
    addpath('F:\SerialCommunication'); % add a path to the functions
    initSerialControl COM21 % initialise com port
    
    figure;
    y=[];
    uplot=[];
 
    yzad = 45;
    
    load('temp35_39.mat');
    s = (temp35_39-34.68)/4;
    
    D = length(s);
    %parametry DMC
    N = 45;
    Nu = 5;
    lambda = 1; 
    
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
    K = (M'*M+lambda*eye(Nu))^-1*M';
    K1 = K(1,1:N);
    ke = sum(K1);
    ku = K1*Mp;
    
    du(1:D-1)=0; u(1) = 0;
    yzad(1:50)=35; yzad(51:150)=37; yzad(151:1000)=40;
    
    E = 0;
    k = 1;
    
    while(1)
        %% obtaining measurements
        measurements = readMeasurements(1:7); % read measurements from 1 to 7
        
        %% processing of the measurements and new control values calculation
        y =[y measurements(1)];
        uplot = [uplot u(k)];
        disp(measurements(1)); % process measurements
        plot(y); hold on; plot(uplot);
        drawnow
        
    e = yzad(k) - y(k);
    E = E+e^2
    deltau = ke*e-ku*du';
    
    for n=D-1:-1:2
        du(n)=du(n-1);
    end
    
    du(1)=deltau;
    u(k) = u(k-1) + du(1);
        
        if (u(k)>100)
            u(k) = 100;
        end
            
        if (u(k)<0)
            u(k) = 0;
        end
            
        %% sending new values of control signals
        sendControls([1, 5], ... send for these elements
                     [50, u(k)]);  % new corresponding control values
        
        %% synchronising with the control process
        
        
        waitForNewIteration(); % wait for new batch of measurements to be ready
        k = k +1;
    end
end