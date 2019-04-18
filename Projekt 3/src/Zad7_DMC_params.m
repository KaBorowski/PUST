function lambda = Zad7_DMC_params(y_beg, dY)
    init_point = 1;
    minimal = 0.001;
    maximum = 50;
    lambda = fmincon(@(lambda)Zad7_DMC_function(lambda, y_beg, dY), init_point, [],[],[],[], minimal, maximum);
%     disp(lambda);
%     disp(Zad7_DMC_function(lambda, y_beg, dY));
end