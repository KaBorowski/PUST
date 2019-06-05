function DMC_lab()
    addpath('F:\SerialCommunication'); % add a path to the functions
    initSerialControl COM21 % initialise com port
    
    figure;
    y=[];
    yplot=[];
    uplot=[];
    yzadplot=[];
 
    zaklocenie = 0;
    
    load('temp35_39.mat');
    s = (temp35_39-34.68)/4;
       
    D = 440;
    Dz = 100;
    %parametry DMC
    N = 80;
    Nu = 25;
    lambda = 0.01; 
    
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
    
    if zaklocenie==1
        Mzp=zeros(N,Dz-1);
        for i=1:N
           for j=1:Dz-1
              if i+j<=Dz
                 Mzp(i,j)=sz(i+j)-sz(j);
              else
                 Mzp(i,j)=sz(Dz)-sz(j);
              end      
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
    if zaklocenie==1
        kz = K1*Mzp;
    end
    
    du(1:D-1)=0; u(1:2)=35; y(1)=35;
    if zaklocenie==1
        dz(1:Dz-1)=0;
    end
    yzad(1:40)=35; yzad(41:150)=37; yzad(151:10000)=40;
    
    E(1:1000)=0;
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
        title(['Regulator DMC, E = ' num2str(E(k-1))]);
        drawnow
        
             
    e = yzad(k) - y(k);
    E(k) = E(k-1)+e^2;
    
    if zaklocenie==1
      for n=Dz-1:-1:2
         dz(n)=dz(n-1);
      end
      dz(1)=z(k)-z(k-1);
    end 
   
    deltau = ke*e-ku*du';
    if zaklocenie==1
      deltau = deltau-kz*dz';
    end
    
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
        sendControls([1, 5], ... send for these elements
                     [50, u(k)]);  % new corresponding control values
        
        %% synchronising with the control process
        
        
        waitForNewIteration(); % wait for new batch of measurements to be ready
        k = k +1;
        
    end
end