function y_beg = get_beg_y(u_beg)
kk = 600;
u(1:kk) = u_beg;
y(1:kk) = 0;
 
for k=7:kk
    y(k)=symulacja_obiektu10y(u(k-5),u(k-6),y(k-1),y(k-2));
end

y_beg = y(end);
end

