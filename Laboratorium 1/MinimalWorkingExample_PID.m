function MinimalWorkingExample_PID()
    addpath('F:\SerialCommunication'); % add a path to the functions
    initSerialControl COM21 % initialise com port
    
    figure;
    y=[];
    uplot=[];
 
    yzad = 45;
    
    K = 3;
    Ti = 5;
    Td = 0.5;
    T = 1;
    
    r0 = K*(1+T/(2*Ti)+Td/T);
    r1 = K*(T/(2*Ti)-(2*Td)/T-1);
    r2 = (K*Td)/T;
    uk_1 = 35;
    
    ek_2 = 0;
    ek_1 = 0;
    ek = 0;
    
    u = 0;
    
    while(1)
        %% obtaining measurements
        measurements = readMeasurements(1:7); % read measurements from 1 to 7
        
        %% processing of the measurements and new control values calculation
        y=[y measurements(1)];
        uplot = [uplot u];
        disp(measurements(1)); % process measurements
        plot(y); hold on;
        plot(uplot);
        drawnow
        
        ek_2 = ek_1;
        ek_1 = ek;
        ek = yzad - measurements(1);
               
        
        u = r2*ek_2 + r1*ek_1 + r0*ek + uk_1;
        
        if (u>100)
            u = 100;
        end
            
        if (u<0)
            u = 0;
        end
            
        uk_1 = u;
        %% sending new values of control signals
        sendControls([1, 5], ... send for these elements
                     [50, u]);  % new corresponding control values
        
        %% synchronising with the control process
        
        
        waitForNewIteration(); % wait for new batch of measurements to be ready
    end
end