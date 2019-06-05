function E = get_static_U_function(U, Y)
    kk = 600;
    u(1:kk) = U;
    y(1:kk) = Y;  
    e(1:kk) = 0;
    E=0;
    for k=7:kk
        y(k)=symulacja_obiektu10y(u(k-5),u(k-6),y(k-1),y(k-2));
        e(k) = Y-y(k);
        E=E+e(k).^2;
    end
end