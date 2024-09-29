%%%FUNCION DE TRANSFERENCIA
Am = [-1, 0, 0; 0, -1, 0; 0, 0, -1];
Bm = eye(3);  % Para cada entrada
Cm = eye(3);
Dm = 0;
%%%Check if the transfer func fills our needs
sys_ss = ss(Am, Bm, Cm, Dm);
sys_tf = tf(sys_ss);

Q = eye(3);
%%%Solve the lyapunov equation
P = lyap(eye(3),Q,[],Am');

%%%Check
P*Am+Am'*P+Q %%=0