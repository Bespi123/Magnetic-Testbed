function u = controller(input)
    %
    r = [input(1),input(2),input(3)]';
    y = [input(4),input(5),input(6)]';
    
    a_r_est = diag([input(7 ), input(8 ), input(9 )]);
    a_y_est = diag([input(10), input(11), input(12)]);
    
    u = a_r_est*r+a_y_est*y;
end

