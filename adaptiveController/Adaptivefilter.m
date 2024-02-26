function omega_dot = Adaptivefilter(entr)
    bm = entr(1);
    omega = entr(2);
    input = entr(3);
    omega_dot = -bm*omega + input;
end

