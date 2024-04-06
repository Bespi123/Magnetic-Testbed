function omega_dot = Adaptivefilter(entr)
    bm    = entr(1);
    h     = entr(2);
    omega = entr(3);
    input = entr(4);
    omega_dot = -bm*omega + h*input;
end

