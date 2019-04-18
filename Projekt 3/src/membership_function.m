function w = membership_function(x, y_beg, REG_COUNT)
    Y_MIN = -2.6416;
    Y_MAX = 0.0885;
    LEFT_SHOULDER = 0.1*(Y_MAX-Y_MIN)/(REG_COUNT-1);
    RIGHT_SHOULDER = 0.1*(Y_MAX-Y_MIN)/(REG_COUNT-1);
    LEFT_FEET = (Y_MAX-Y_MIN)/(REG_COUNT-1);
    RIGHT_FEET = (Y_MAX-Y_MIN)/(REG_COUNT-1);
    
    if y_beg == Y_MAX
        LEFT_SHOULDER = 0.01;
        RIGHT_SHOULDER = 0.01;
        LEFT_FEET = 0.08;
        RIGHT_FEET = 0.08;
    end
    
    w = trapmf(x, [y_beg-LEFT_FEET y_beg-LEFT_SHOULDER y_beg+RIGHT_SHOULDER y_beg+RIGHT_FEET]);
end