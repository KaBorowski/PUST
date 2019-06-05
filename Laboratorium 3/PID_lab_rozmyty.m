function PID_lab_rozmyty()
    addpath('F:\SerialCommunication'); % add a path to the functions
    initSerialControl COM21 % initialise com port
    
    figure;
    y=[];
    uplot=[];
    yzadplot=[];
    
    x_fp = 0:0.01:100;       
    fp1 = trapmf(x_fp, [0 0.0001 40 42.5]);
    fp2 = trapmf(x_fp, [40.5 41.5 44 45]);
    fp3 = trapmf(x_fp, [44 45 99.9999 100]);
    
    K(1) = 5;
    Ti(1) = 40;
    Td(1) = 0;
    
    K(2) = 3;
    Ti(2) = 60;
    Td(2) = 0;
    
    K(3) = 2;
    Ti(3) = 35;
    Td(3) = 0;
    
    T = 1;
    
    r0(1:3)=0;
    r1(1:3)=0;
    r2(1:3)=0;
    
    for i=1:3
        r0(i) = K(i)*(1+T/(2*Ti(i))+Td(i)/T);
        r1(i) = K(i)*(T/(2*Ti(i))-(2*Td(i))/T-1);
        r2(i) = (K(i)*Td(i))/T;
    end
    
    uk_1 = 35;
    u(1:3) = 35;
    
    ek_2 = 0;
    ek_1 = 0;
    ek = 0;
    
    sendControls(1, 50);
    measurements = readMeasurements(1:7);
    Tpp = measurements(1);
    yzad(1:30)=Tpp; yzad(31:180)=Tpp+5; yzad(181:550)=Tpp+15; yzad(551:10000)=Tpp;
    E(1:10000) = 0;
    k = 2;
    
    while(1)
        %% obtaining measurements
        measurements = readMeasurements(1:7); % read measurements from 1 to 7
        
        %% processing of the measurements and new control values calculation
        y=[y measurements(1)];
        uplot = [uplot u];
        yzadplot = [yzadplot yzad(k)];
        disp(measurements(1)); % process measurements
        hold on; grid on; plot(y, 'g'); plot(uplot, 'r'); stairs(yzadplot, 'b');
        legend('y(k)','u(k)','yzad(k)', 'Location', 'southeast');
        title(['Regulator PID, E = ' num2str(E(k-1))]);
        drawnow
        
        ek_2 = ek_1;
        ek_1 = ek;
        ek = yzad(k) - measurements(1);
        
        E(k) = E(k-1)+ek^2;

        for i=1:3
           u(i) = uk_1 + r0(i)*ek + r1(i)*ek_1 + r2(i)*ek_2;
           if u(i) > 100
               u(i) = 100;
           end
           if u(i) < 0
               u(i) = 0;
           end
        end
        
        x = measurements(1); %zmienna wybieraj¹ca
        w1 = fp1(x*100);
        w2 = fp2(x*100);
        w3 = fp3(x*100);
        
        u_sum = (w1*u(1)+w2*u(2)+w3*u(3))/(w1+w2+w3);
        
        if u_sum > 100
            u_sum = 100;
        end
            
        if u_sum < 0
            u_sum = 0;
        end
            
        uk_1 = u_sum;
        %% sending new values of control signals
        sendNonlinearControls(u_sum);
     
        %% synchronising with the control process
        k = k + 1;
        waitForNewIteration(); % wait for new batch of measurements to be ready       
        
    end
end