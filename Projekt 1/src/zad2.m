u = (linspace(2.7, 3.3, 100))';
y = zeros(100, 1);

for i=1:length(u)
    sim_u = u(i)*ones(200,1);
    sim_y = zeros(200,1);
    for k=12:200
        sim_y(k) = symulacja_obiektu10Y(sim_u(k-10), sim_u(k-11), sim_y(k-1), sim_y(k-2));
    end
    y(i) = sim_y(200);
end
plot(u, y);