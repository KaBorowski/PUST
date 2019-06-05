function s = generate_step(U, Y, dU)
    kk = 36;
    u(1:6) = U;
    u(7:kk) = U + dU;
    y(1:kk) = Y;  
    for k=7:kk
        y(k)=symulacja_obiektu10y(u(k-5),u(k-6),y(k-1),y(k-2));
    end
    s=y(7:kk);
    s=s-Y;
    s=s/dU;
%     figure;
%     plot(s);
end