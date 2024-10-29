function u = controller_centralized(entr)
    %
    r = [entr(1),entr(2),entr(3)]';
    x = [entr(4),entr(5),entr(6)]';
    
    K_x = [entr(7),entr(8),entr(9);
           entr(10),entr(11),entr(12);
           entr(13),entr(14),entr(15)];

    K_r = [entr(16),entr(17),entr(18);
           entr(19),entr(20),entr(21);
           entr(22),entr(23),entr(24)];

    Theta = [entr(25),entr(26),entr(27);
           entr(28),entr(29),entr(30);
           entr(31),entr(32),entr(33)];
    
    basis = [entr(34),entr(35),entr(36)]';

    u = K_x*x+K_r*r-Theta'*basis;
end

